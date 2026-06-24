from aiogram import Router, types
from aiogram.filters import CommandStart, Command
from aiogram.utils.keyboard import InlineKeyboardBuilder
import os

from database.db import check_is_admin, register_or_get_user, get_pool

router = Router()

WEBAPP_URL = os.environ.get("WEBAPP_URL", "https://talk2learn-app.onrender.com")
ADMIN_IDS = [377424247, 696767499]


@router.message(CommandStart())
async def cmd_start(message: types.Message):
    builder = InlineKeyboardBuilder()
    base_url = WEBAPP_URL.rstrip('/')
    user_id  = message.from_user.id

    # Mini App открывается внутри Telegram
    builder.add(types.InlineKeyboardButton(
        text="🚀 Открыть Talk2Learn",
        web_app=types.WebAppInfo(url=f"{base_url}/")
    ))

    # Разговорный клуб прямо в боте
    builder.add(types.InlineKeyboardButton(
        text="🎙 Разговорный клуб",
        callback_data="enter_speaking_club"
    ))

    # Веб-сайт (открывается в браузере)
    builder.add(types.InlineKeyboardButton(
        text="🌐 Открыть сайт",
        url=f"{base_url}/app?tg_id={user_id}"
    ))

    builder.adjust(1)

    # Регистрируем/обновляем пользователя в БД + сохраняем telegram-привязку
    try:
        user = message.from_user
        full_name = user.first_name + (f" {user.last_name}" if user.last_name else "")
        await register_or_get_user(user.id, full_name, user.username or "")

        pool = await get_pool()
        async with pool.acquire() as db:
            await db.execute("""
                INSERT INTO user_telegram (user_id, telegram_id, telegram_username, telegram_name)
                VALUES ($1, $2, $3, $4)
                ON CONFLICT (telegram_id) DO UPDATE SET
                    telegram_username = EXCLUDED.telegram_username,
                    telegram_name = EXCLUDED.telegram_name
            """, user.id, user.id, user.username or "", full_name)
    except Exception as e:
        print(f"[menu] register error: {e}")

    await message.answer(
        f"👋 Привет, <b>{message.from_user.first_name}</b>!\n\n"
        "Добро пожаловать в <b>Talk2Learn</b> 🇬🇧\n\n"
        "Выбери, чем хочешь заняться:",
        reply_markup=builder.as_markup(),
        parse_mode="HTML"
    )


@router.message(Command("admin"))
async def cmd_admin(message: types.Message):
    """Вход в админ-панель"""
    user_id = message.from_user.id
    
    # Проверка через ADMIN_IDS + базу
    is_admin = user_id in ADMIN_IDS or await check_is_admin(user_id)
    
    if not is_admin:
        await message.answer("⚠️ У вас нет прав администратора.")
        return

    builder = InlineKeyboardBuilder()
    admin_url = f"{WEBAPP_URL.rstrip('/')}/admin"

    builder.add(types.InlineKeyboardButton(
        text="⚙️ Открыть Админ-панель",
        web_app=types.WebAppInfo(url=admin_url)
    ))

    await message.answer(
        "🔐 <b>Админ-панель активирована</b>\n\n"
        "Теперь вы можете управлять пользователями, уроками и статистикой.",
        reply_markup=builder.as_markup(),
        parse_mode="HTML"
    )