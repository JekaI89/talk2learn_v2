"""
auth.py — полная авторизация Talk2Learn

Поддерживаемые сценарии:
  POST /api/auth/register          — регистрация email + пароль
  POST /api/auth/login             — вход email + пароль
  POST /api/auth/email/verify      — подтверждение email кодом
  POST /api/auth/email/resend      — повторная отправка кода
  POST /api/auth/telegram/verify   — вход/регистрация через Telegram Widget
  POST /api/auth/link/telegram     — привязать Telegram к email-аккаунту
  POST /api/auth/link/email        — привязать email к Telegram-аккаунту
  GET  /api/auth/status/{user_id}  — статус привязок пользователя
"""

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
import hashlib
import hmac
import random
import string
import time
import os
import bcrypt
import asyncio

from database.db import register_or_get_user, get_pool

router = APIRouter()

CODE_TTL = 600          # 10 минут
RESEND_COOLDOWN = 60    # нельзя запрашивать код чаще раза в минуту


# ─── helpers ─────────────────────────────────────────────────────────────────

def _gen_code(n=6) -> str:
    return "".join(random.choices(string.digits, k=n))

def _hash_password(plain: str) -> str:
    return bcrypt.hashpw(plain.encode(), bcrypt.gensalt()).decode()

def _check_password(plain: str, hashed: str) -> bool:
    return bcrypt.checkpw(plain.encode(), hashed.encode())

async def _send_code_email(email: str, code: str, subject: str = "Код подтверждения Talk2Learn"):
    """
    Отправляет письмо через Resend.com API.
    Env vars: RESEND_API_KEY, EMAIL_FROM (опционально, default noreply@talk2learn.app)
    Если RESEND_API_KEY не задан — печатает код в логи (dev-режим).
    """
    api_key = os.environ.get("RESEND_API_KEY", "")
    from_addr = os.environ.get("EMAIL_FROM", "Talk2Learn <noreply@talk2learn.app>")

    if not api_key:
        print(f"[AUTH][DEV] Код для {email}: {code}")
        return

    import resend
    resend.api_key = api_key

    html = f"""
    <div style="font-family:sans-serif;max-width:480px;margin:0 auto;padding:32px">
      <h2 style="color:#1a1a2e;margin-bottom:8px">Talk2Learn</h2>
      <p style="color:#555;margin-bottom:24px">Ваш код подтверждения:</p>
      <div style="background:#f0f4ff;border-radius:12px;padding:24px;text-align:center;
                  font-size:36px;font-weight:700;letter-spacing:8px;color:#3b5bdb">
        {code}
      </div>
      <p style="color:#888;font-size:13px;margin-top:24px">
        Код действителен 10 минут. Если вы не запрашивали код — просто проигнорируйте письмо.
      </p>
    </div>
    """
    await asyncio.to_thread(
        resend.Emails.send,
        {"from": from_addr, "to": [email], "subject": subject, "html": html}
    )


# ─── models ──────────────────────────────────────────────────────────────────

class RegisterRequest(BaseModel):
    email: str
    password: str
    name: str = ""

class LoginRequest(BaseModel):
    email: str
    password: str

class EmailCodeRequest(BaseModel):
    email: str

class EmailVerifyRequest(BaseModel):
    email: str
    code: str

class TelegramAuthData(BaseModel):
    id: int
    first_name: str
    last_name: Optional[str] = None
    username: Optional[str] = None
    photo_url: Optional[str] = None
    auth_date: int
    hash: str

class LinkTelegramRequest(BaseModel):
    user_id: int          # email-пользователь
    telegram_data: TelegramAuthData

class LinkEmailRequest(BaseModel):
    telegram_user_id: int  # пользователь вошедший через Telegram
    email: str
    password: str         # создаёт новый пароль или привязывает существующий


# ─── telegram hash check ─────────────────────────────────────────────────────

def _verify_telegram_hash(data: TelegramAuthData) -> bool:
    bot_token = os.environ.get("BOT_TOKEN", "") or os.environ.get("TELEGRAM_BOT_TOKEN", "")
    if not bot_token:
        raise HTTPException(500, "BOT_TOKEN не задан на сервере")

    fields = {"id": str(data.id), "first_name": data.first_name, "auth_date": str(data.auth_date)}
    if data.last_name:  fields["last_name"]  = data.last_name
    if data.username:   fields["username"]   = data.username
    if data.photo_url:  fields["photo_url"]  = data.photo_url

    data_check = "\n".join(f"{k}={v}" for k, v in sorted(fields.items()))
    secret = hashlib.sha256(bot_token.encode()).digest()
    expected = hmac.new(key=secret, msg=data_check.encode(), digestmod=hashlib.sha256).hexdigest()

    return hmac.compare_digest(expected, data.hash) and (time.time() - data.auth_date) < 86400


# ─── /api/auth/register ──────────────────────────────────────────────────────

@router.post("/api/auth/register")
async def register(data: RegisterRequest):
    email = data.email.strip().lower()
    if not email or "@" not in email:
        raise HTTPException(400, "Некорректный email")
    if len(data.password) < 6:
        raise HTTPException(400, "Пароль должен быть не менее 6 символов")

    pool = await get_pool()
    async with pool.acquire() as db:
        # Проверяем: email уже зарегистрирован?
        existing = await db.fetchrow("SELECT id, email_verified FROM user_auth WHERE email=$1", email)
        if existing and existing["email_verified"]:
            raise HTTPException(409, "Email уже зарегистрирован. Используйте вход.")

        # Создаём user_id (хэш email → числовой id)
        synthetic_id = int(hashlib.sha256(email.encode()).hexdigest(), 16) % (10 ** 12)

        # Создаём пользователя в users (если нет)
        name = data.name.strip() or email.split("@")[0]
        await register_or_get_user(synthetic_id, name, email)

        # Генерируем код верификации
        code = _gen_code()
        expires_at = time.time() + CODE_TTL
        pw_hash = _hash_password(data.password)

        if existing:
            # Обновляем незавершённую регистрацию
            await db.execute("""
                UPDATE user_auth SET password_hash=$1, verify_code=$2,
                verify_code_expires_at=to_timestamp($3), updated_at=NOW()
                WHERE email=$4
            """, pw_hash, code, expires_at, email)
        else:
            await db.execute("""
                INSERT INTO user_auth (user_id, email, password_hash, verify_code, verify_code_expires_at)
                VALUES ($1,$2,$3,$4,to_timestamp($5))
            """, synthetic_id, email, pw_hash, code, expires_at)

    await _send_code_email(email, code, "Подтвердите email — Talk2Learn")

    return {
        "status": "verify_required",
        "user_id": synthetic_id,
        "message": "Код подтверждения отправлен на email"
    }


# ─── /api/auth/email/verify ──────────────────────────────────────────────────

@router.post("/api/auth/email/verify")
async def email_verify(data: EmailVerifyRequest):
    email = data.email.strip().lower()
    pool = await get_pool()
    async with pool.acquire() as db:
        row = await db.fetchrow(
            "SELECT user_id, verify_code, verify_code_expires_at FROM user_auth WHERE email=$1", email
        )
        if not row:
            raise HTTPException(400, "Email не найден. Пройдите регистрацию.")
        if not row["verify_code"]:
            raise HTTPException(400, "Код не запрашивался.")
        if row["verify_code_expires_at"].timestamp() < time.time():
            raise HTTPException(400, "Код устарел. Запросите новый.")
        if row["verify_code"] != data.code.strip():
            raise HTTPException(400, "Неверный код.")

        await db.execute("""
            UPDATE user_auth SET email_verified=TRUE, verify_code=NULL,
            verify_code_expires_at=NULL, updated_at=NOW()
            WHERE email=$1
        """, email)
        user_id = row["user_id"]

    return {"status": "ok", "user_id": user_id, "email": email}


# ─── /api/auth/email/resend ──────────────────────────────────────────────────

@router.post("/api/auth/email/resend")
async def email_resend(data: EmailCodeRequest):
    email = data.email.strip().lower()
    pool = await get_pool()
    async with pool.acquire() as db:
        row = await db.fetchrow(
            "SELECT verify_code_expires_at FROM user_auth WHERE email=$1", email
        )
        if not row:
            raise HTTPException(400, "Email не найден.")

        # Антиспам: нельзя слать чаще раза в минуту
        if row["verify_code_expires_at"]:
            remaining = row["verify_code_expires_at"].timestamp() - time.time()
            if remaining > (CODE_TTL - RESEND_COOLDOWN):
                raise HTTPException(429, f"Повторная отправка доступна через {int(remaining - (CODE_TTL - RESEND_COOLDOWN))} сек.")

        code = _gen_code()
        expires_at = time.time() + CODE_TTL
        await db.execute("""
            UPDATE user_auth SET verify_code=$1, verify_code_expires_at=to_timestamp($2), updated_at=NOW()
            WHERE email=$3
        """, code, expires_at, email)

    await _send_code_email(email, code, "Новый код подтверждения — Talk2Learn")
    return {"status": "ok", "message": "Новый код отправлен"}


# ─── /api/auth/login ─────────────────────────────────────────────────────────

@router.post("/api/auth/login")
async def login(data: LoginRequest):
    email = data.email.strip().lower()
    pool = await get_pool()
    async with pool.acquire() as db:
        row = await db.fetchrow(
            "SELECT user_id, password_hash, email_verified FROM user_auth WHERE email=$1", email
        )
        if not row or not row["password_hash"]:
            raise HTTPException(401, "Неверный email или пароль")
        if not _check_password(data.password, row["password_hash"]):
            raise HTTPException(401, "Неверный email или пароль")
        if not row["email_verified"]:
            raise HTTPException(403, "Email не подтверждён. Проверьте почту.")

        user_id = row["user_id"]
        user = await db.fetchrow("SELECT name, username, level FROM users WHERE user_id=$1", user_id)

    return {
        "status": "ok",
        "user_id": user_id,
        "email": email,
        "name": user["name"] if user else "",
        "level": user["level"] if user else "A1",
    }


# ─── /api/auth/telegram/verify ───────────────────────────────────────────────

@router.post("/api/auth/telegram/verify")
async def telegram_verify(data: TelegramAuthData):
    if not _verify_telegram_hash(data):
        raise HTTPException(403, "Неверная подпись Telegram.")

    full_name = data.first_name + (f" {data.last_name}" if data.last_name else "")
    pool = await get_pool()
    async with pool.acquire() as db:
        # Ищем существующую привязку telegram_id → user_id
        tg_row = await db.fetchrow(
            "SELECT user_id FROM user_telegram WHERE telegram_id=$1", data.id
        )
        if tg_row:
            user_id = tg_row["user_id"]
        else:
            # Создаём пользователя и сохраняем привязку
            user_id = data.id  # telegram_id как user_id для tg-пользователей
            await register_or_get_user(user_id, full_name, data.username or "")
            await db.execute("""
                INSERT INTO user_telegram (user_id, telegram_id, telegram_username, telegram_name)
                VALUES ($1,$2,$3,$4)
                ON CONFLICT (telegram_id) DO UPDATE SET
                    telegram_username=EXCLUDED.telegram_username,
                    telegram_name=EXCLUDED.telegram_name
            """, user_id, data.id, data.username or "", full_name)

        # Получаем email (если привязан)
        auth_row = await db.fetchrow("SELECT email FROM user_auth WHERE user_id=$1", user_id)

    return {
        "status": "ok",
        "user_id": user_id,
        "name": full_name,
        "username": data.username or "",
        "photo_url": data.photo_url or "",
        "email": auth_row["email"] if auth_row else None,
    }


# ─── /api/auth/link/telegram ─────────────────────────────────────────────────

@router.post("/api/auth/link/telegram")
async def link_telegram(data: LinkTelegramRequest):
    """Привязывает Telegram к существующему email-аккаунту."""
    if not _verify_telegram_hash(data.telegram_data):
        raise HTTPException(403, "Неверная подпись Telegram.")

    tg = data.telegram_data
    pool = await get_pool()
    async with pool.acquire() as db:
        # Проверяем что email-аккаунт существует
        auth_row = await db.fetchrow(
            "SELECT user_id FROM user_auth WHERE user_id=$1 AND email_verified=TRUE", data.user_id
        )
        if not auth_row:
            raise HTTPException(404, "Email-аккаунт не найден.")

        # Telegram уже привязан к другому аккаунту?
        existing = await db.fetchrow(
            "SELECT user_id FROM user_telegram WHERE telegram_id=$1", tg.id
        )
        if existing and existing["user_id"] != data.user_id:
            raise HTTPException(409, "Этот Telegram уже привязан к другому аккаунту.")

        full_name = tg.first_name + (f" {tg.last_name}" if tg.last_name else "")
        await db.execute("""
            INSERT INTO user_telegram (user_id, telegram_id, telegram_username, telegram_name)
            VALUES ($1,$2,$3,$4)
            ON CONFLICT (telegram_id) DO UPDATE SET
                user_id=EXCLUDED.user_id,
                telegram_username=EXCLUDED.telegram_username,
                telegram_name=EXCLUDED.telegram_name
        """, data.user_id, tg.id, tg.username or "", full_name)

    return {"status": "ok", "message": "Telegram успешно привязан"}


# ─── /api/auth/link/email ────────────────────────────────────────────────────

@router.post("/api/auth/link/email")
async def link_email(data: LinkEmailRequest):
    """Привязывает email+пароль к Telegram-аккаунту."""
    email = data.email.strip().lower()
    if not email or "@" not in email:
        raise HTTPException(400, "Некорректный email")
    if len(data.password) < 6:
        raise HTTPException(400, "Пароль должен быть не менее 6 символов")

    pool = await get_pool()
    async with pool.acquire() as db:
        # Telegram-пользователь существует?
        tg_row = await db.fetchrow(
            "SELECT user_id FROM user_telegram WHERE user_id=$1", data.telegram_user_id
        )
        if not tg_row:
            raise HTTPException(404, "Telegram-аккаунт не найден.")

        # Email уже занят другим аккаунтом?
        existing_auth = await db.fetchrow(
            "SELECT user_id FROM user_auth WHERE email=$1", email
        )
        if existing_auth and existing_auth["user_id"] != data.telegram_user_id:
            raise HTTPException(409, "Email уже зарегистрирован на другом аккаунте.")

        code = _gen_code()
        expires_at = time.time() + CODE_TTL
        pw_hash = _hash_password(data.password)

        if existing_auth:
            await db.execute("""
                UPDATE user_auth SET password_hash=$1, verify_code=$2,
                verify_code_expires_at=to_timestamp($3), updated_at=NOW()
                WHERE email=$4
            """, pw_hash, code, expires_at, email)
        else:
            await db.execute("""
                INSERT INTO user_auth (user_id, email, password_hash, verify_code, verify_code_expires_at)
                VALUES ($1,$2,$3,$4,to_timestamp($5))
            """, data.telegram_user_id, email, pw_hash, code, expires_at)

    await _send_code_email(email, code, "Подтвердите email для привязки — Talk2Learn")
    return {
        "status": "verify_required",
        "message": "Код подтверждения отправлен на email"
    }


# ─── /api/auth/status/{user_id} ──────────────────────────────────────────────

class TelegramAutoLoginRequest(BaseModel):
    telegram_id: int


@router.post("/api/auth/telegram/autologin")
async def telegram_autologin(data: TelegramAutoLoginRequest):
    """
    Авто-логин по telegram_id без верификации хэша.
    Используется только когда ссылка пришла из самого бота (?tg_id=...).
    Работает только для уже зарегистрированных пользователей.
    """
    pool = await get_pool()
    async with pool.acquire() as db:
        # Ищем пользователя по telegram_id
        tg_row = await db.fetchrow(
            "SELECT user_id FROM user_telegram WHERE telegram_id=$1", data.telegram_id
        )
        if not tg_row:
            # Пользователь ещё не зарегистрирован через бота — отказ
            raise HTTPException(404, "Пользователь не найден. Войдите через бота командой /start")

        user_id = tg_row["user_id"]
        user = await db.fetchrow("SELECT name, username FROM users WHERE user_id=$1", user_id)

    return {
        "status": "ok",
        "user_id": user_id,
        "name": user["name"] if user else "",
        "username": user["username"] if user else "",
    }


@router.get("/api/auth/status/{user_id}")
async def auth_status(user_id: int):
    """Возвращает статус привязок аккаунта."""
    pool = await get_pool()
    async with pool.acquire() as db:
        auth_row = await db.fetchrow(
            "SELECT email, email_verified FROM user_auth WHERE user_id=$1", user_id
        )
        tg_row = await db.fetchrow(
            "SELECT telegram_id, telegram_username, telegram_name FROM user_telegram WHERE user_id=$1",
            user_id
        )
    return {
        "user_id": user_id,
        "email": auth_row["email"] if auth_row else None,
        "email_verified": auth_row["email_verified"] if auth_row else False,
        "telegram_id": tg_row["telegram_id"] if tg_row else None,
        "telegram_username": tg_row["telegram_username"] if tg_row else None,
        "telegram_name": tg_row["telegram_name"] if tg_row else None,
    }
