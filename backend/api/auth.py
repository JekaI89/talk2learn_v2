from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
import hashlib
import hmac
import random
import string
import time
import os

from database.db import register_or_get_user

router = APIRouter()

# ====================== EMAIL AUTH (тестовый режим) ======================
# Коды хранятся в памяти — сбрасываются при рестарте.
# В продакшене: Redis или таблица в БД + реальный SMTP.

_email_codes: dict[str, dict] = {}
CODE_TTL_SECONDS = 600  # 10 минут


class EmailCodeRequest(BaseModel):
    email: str


class EmailVerifyRequest(BaseModel):
    email: str
    code: str


@router.post("/api/auth/email/request-code")
async def email_request_code(data: EmailCodeRequest):
    email = data.email.strip().lower()
    if not email or "@" not in email:
        raise HTTPException(400, "Некорректный адрес электронной почты")

    code = "".join(random.choices(string.digits, k=6))
    _email_codes[email] = {"code": code, "expires_at": time.time() + CODE_TTL_SECONDS}

    # ТЕСТОВЫЙ РЕЖИМ: код в логах сервера
    print(f"[AUTH] Код для {email}: {code}  ({CODE_TTL_SECONDS // 60} мин)")

    return {
        "status": "ok",
        "message": "Код отправлен. В тестовом режиме смотрите логи сервера.",
        "debug_hint": "Проверьте stdout/логи Render → вкладка Logs",
    }


@router.post("/api/auth/email/verify")
async def email_verify(data: EmailVerifyRequest):
    email = data.email.strip().lower()
    entry = _email_codes.get(email)

    if not entry:
        raise HTTPException(400, "Код не найден. Запросите новый.")
    if time.time() > entry["expires_at"]:
        del _email_codes[email]
        raise HTTPException(400, "Код устарел. Запросите новый.")
    if entry["code"] != data.code.strip():
        raise HTTPException(400, "Неверный код.")

    del _email_codes[email]

    synthetic_user_id = int(hashlib.sha256(email.encode()).hexdigest(), 16) % (10 ** 12)
    level = await register_or_get_user(
        user_id=synthetic_user_id,
        name=email.split("@")[0],
        username=email,
    )
    return {"status": "ok", "user_id": synthetic_user_id, "email": email, "level": level}


# ====================== TELEGRAM LOGIN WIDGET ======================

class TelegramAuthData(BaseModel):
    id: int
    first_name: str
    last_name: Optional[str] = None
    username: Optional[str] = None
    photo_url: Optional[str] = None
    auth_date: int
    hash: str


def _verify_telegram_hash(data: TelegramAuthData) -> bool:
    bot_token = os.environ.get("BOT_TOKEN", "") or os.environ.get("TELEGRAM_BOT_TOKEN", "")
    if not bot_token:
        raise HTTPException(500, "BOT_TOKEN не задан на сервере")

    fields = {"id": str(data.id), "first_name": data.first_name, "auth_date": str(data.auth_date)}
    if data.last_name:  fields["last_name"]  = data.last_name
    if data.username:   fields["username"]   = data.username
    if data.photo_url:  fields["photo_url"]  = data.photo_url

    data_check_string = "\n".join(f"{k}={v}" for k, v in sorted(fields.items()))
    secret_key = hashlib.sha256(bot_token.encode()).digest()
    expected_hash = hmac.new(
        key=secret_key, msg=data_check_string.encode(), digestmod=hashlib.sha256
    ).hexdigest()

    return hmac.compare_digest(expected_hash, data.hash) and (time.time() - data.auth_date) < 86400


@router.post("/api/auth/telegram/verify")
async def telegram_verify(data: TelegramAuthData):
    if not _verify_telegram_hash(data):
        raise HTTPException(403, "Неверная подпись Telegram. Авторизация отклонена.")

    full_name = data.first_name + (f" {data.last_name}" if data.last_name else "")
    level = await register_or_get_user(
        user_id=data.id, name=full_name, username=data.username or ""
    )
    return {
        "status": "ok", "user_id": data.id,
        "name": full_name, "username": data.username or "",
        "photo_url": data.photo_url or "", "level": level,
    }
