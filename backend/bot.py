import asyncio
import logging
import os
from aiogram import Bot, Dispatcher
from aiogram.client.default import DefaultBotProperties
from aiogram.enums import ParseMode

# Импорты обработчиков
from handlers import menu
from handlers import speaking_club

BOT_TOKEN = os.environ.get("BOT_TOKEN", "")

async def main():
    logging.basicConfig(level=logging.INFO)
    if not BOT_TOKEN:
        print("⚠️ BOT_TOKEN не задан")
        return

    bot = Bot(
        token=BOT_TOKEN,
        default=DefaultBotProperties(parse_mode=ParseMode.HTML)
    )
    dp = Dispatcher()

    # Подключаем роутеры
    dp.include_router(menu.router)
    dp.include_router(speaking_club.router)

    print("🤖 Бот запущен...")
    await dp.start_polling(bot)


if __name__ == "__main__":
    asyncio.run(main())