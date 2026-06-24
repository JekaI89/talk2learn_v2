from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, Response
from contextlib import asynccontextmanager
import os
import asyncio
import time
import logging
from pathlib import Path

from database.db import init_db, close_pool
from config import MINI_DIR, WEB_DIR, AUDIO_DIR

from api import users, lessons, dictionary, club, admin, auth

logger = logging.getLogger(__name__)

# ====================== BOT (WEBHOOK MODE) ======================
# Webhook исключает TelegramConflictError при деплое:
# новый инстанс просто перехватывает webhook у старого.

_bot = None
_dp  = None


async def setup_bot():
    global _bot, _dp
    bot_token = os.environ.get("BOT_TOKEN", "")
    webapp_url = os.environ.get("WEBAPP_URL", "https://talk2learn-app.onrender.com").rstrip("/")

    if not bot_token:
        logger.warning("⚠️ BOT_TOKEN не задан — Telegram-бот не запущен")
        return

    from aiogram import Bot, Dispatcher
    from aiogram.client.default import DefaultBotProperties
    from aiogram.enums import ParseMode
    from handlers import menu, speaking_club

    _bot = Bot(token=bot_token, default=DefaultBotProperties(parse_mode=ParseMode.HTML))
    _dp  = Dispatcher()
    _dp.include_router(menu.router)
    _dp.include_router(speaking_club.router)

    webhook_url = f"{webapp_url}/webhook/bot"
    await _bot.set_webhook(
        url=webhook_url,
        drop_pending_updates=True,   # сбрасываем старую очередь
        allowed_updates=["message", "callback_query"],
    )
    logger.info(f"🤖 Webhook установлен: {webhook_url}")


async def teardown_bot():
    global _bot, _dp
    if _bot:
        try:
            await _bot.delete_webhook(drop_pending_updates=True)
            await _bot.session.close()
            logger.info("🤖 Webhook удалён, бот остановлен")
        except Exception as e:
            logger.error(f"Ошибка остановки бота: {e}")
        _bot = None
        _dp  = None


# ====================== AUDIO CLEANUP ======================

async def audio_cleanup_loop():
    while True:
        try:
            await asyncio.sleep(1800)
            now = time.time()
            cleaned = sum(
                1 for f in Path(AUDIO_DIR).glob("*.mp3")
                if now - f.stat().st_mtime > 3600 and not f.unlink()
            )
            if cleaned:
                logger.info(f"🧹 Аудиоочистка: удалено {cleaned} файлов")
        except asyncio.CancelledError:
            break
        except Exception as e:
            logger.error(f"Ошибка очистки аудио: {e}")


# ====================== LIFESPAN ======================

@asynccontextmanager
async def lifespan(app: FastAPI):
    logging.basicConfig(level=logging.INFO)
    logger.info("🚀 Запуск Talk2Learn...")
    os.makedirs(AUDIO_DIR, exist_ok=True)

    await init_db()
    await setup_bot()

    cleanup_task = asyncio.create_task(audio_cleanup_loop())

    yield

    logger.info("🛑 Остановка Talk2Learn...")
    cleanup_task.cancel()
    await asyncio.gather(cleanup_task, return_exceptions=True)
    await teardown_bot()
    await close_pool()
    logger.info("✅ Остановка завершена")


# ====================== APP ======================

app = FastAPI(lifespan=lifespan)

app.include_router(users.router)
app.include_router(lessons.router)
app.include_router(dictionary.router)
app.include_router(club.router)
app.include_router(admin.router)
app.include_router(auth.router)


# ====================== WEBHOOK ENDPOINT ======================

@app.post("/webhook/bot")
async def bot_webhook(request: Request):
    if _bot is None or _dp is None:
        return Response(status_code=200)
    from aiogram.types import Update
    data = await request.json()
    update = Update.model_validate(data, context={"bot": _bot})
    await _dp.feed_update(_bot, update)
    return Response(status_code=200)


# ====================== СТАТИКА ======================

app.mount("/static", StaticFiles(directory=MINI_DIR), name="static")
app.mount("/assets", StaticFiles(directory=WEB_DIR),  name="web-assets")


# ====================== FAVICON ======================

@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    import base64
    ico = base64.b64decode(
        "AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    )
    return Response(content=ico, media_type="image/x-icon")


# ====================== СТРАНИЦЫ ======================

# Mini App (Telegram WebApp открывает корень)
@app.get("/")
@app.get("/mini")
@app.get("/mini/")
async def serve_mini():
    return FileResponse(os.path.join(MINI_DIR, "index.html"))


# Веб-сайт (браузер, ссылка из бота)
@app.get("/app")
@app.get("/web")
@app.get("/lessons")
@app.get("/dictionary")
@app.get("/club")
@app.get("/situations")
@app.get("/profile")
async def serve_web():
    return FileResponse(os.path.join(WEB_DIR, "index.html"))


@app.get("/admin")
async def serve_admin():
    return FileResponse(os.path.join(MINI_DIR, "admin.html"))


# SPA роуты
@app.get("/site")
@app.get("/site/")
@app.get("/site/app")
@app.get("/site/lessons")
@app.get("/site/dictionary")
@app.get("/site/word")
@app.get("/site/profile")
async def serve_site():
    return FileResponse(os.path.join(WEB_DIR, "app.html"))


if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
