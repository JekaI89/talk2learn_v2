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

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# ====================== BOT ======================

_bot = None
_dp  = None
_bot_task = None


async def start_telegram_bot():
    global _bot, _dp
    bot_token = os.environ.get("BOT_TOKEN", "")
    webapp_url = os.environ.get("WEBAPP_URL", "https://talk2learn-app.onrender.com").rstrip("/")

    if not bot_token:
        logger.warning("⚠️ BOT_TOKEN не задан — бот не запущен")
        return

    from aiogram import Bot, Dispatcher
    from aiogram.client.default import DefaultBotProperties
    from aiogram.enums import ParseMode
    from handlers import menu, speaking_club

    _bot = Bot(token=bot_token, default=DefaultBotProperties(parse_mode=ParseMode.HTML))
    _dp  = Dispatcher()
    _dp.include_router(menu.router)
    _dp.include_router(speaking_club.router)

    # Удаляем старый webhook если был, затем запускаем polling
    try:
        await _bot.delete_webhook(drop_pending_updates=True)
        logger.info("🤖 Webhook удалён, запускаем polling...")
    except Exception as e:
        logger.warning(f"delete_webhook: {e}")

    try:
        logger.info("🤖 Telegram-бот запущен (polling)...")
        await _dp.start_polling(
            _bot,
            allowed_updates=["message", "callback_query"],
            drop_pending_updates=True,
        )
    except asyncio.CancelledError:
        logger.info("🤖 Polling остановлен")
    except Exception as e:
        logger.error(f"❌ Polling error: {e}")
    finally:
        try:
            await _bot.session.close()
            logger.info("🤖 Bot session closed")
        except Exception:
            pass
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
    global _bot_task
    logger.info("🚀 Запуск Talk2Learn...")
    os.makedirs(AUDIO_DIR, exist_ok=True)
    await init_db()

    _bot_task    = asyncio.create_task(start_telegram_bot())
    cleanup_task = asyncio.create_task(audio_cleanup_loop())

    yield

    logger.info("🛑 Остановка...")
    _bot_task.cancel()
    cleanup_task.cancel()
    await asyncio.gather(_bot_task, cleanup_task, return_exceptions=True)
    await close_pool()
    logger.info("✅ Остановлено")


# ====================== APP ======================

app = FastAPI(lifespan=lifespan)

app.include_router(users.router)
app.include_router(lessons.router)
app.include_router(dictionary.router)
app.include_router(club.router)
app.include_router(admin.router)
app.include_router(auth.router)


# ====================== FAVICON ======================

@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    # 1x1 прозрачный PNG (проще чем ICO, всегда корректный base64)
    import base64
    png = base64.b64decode(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="
    )
    return Response(content=png, media_type="image/png")


# ====================== СТРАНИЦЫ ======================

@app.get("/")
@app.get("/app")
@app.get("/web")
@app.get("/lessons")
@app.get("/dictionary")
@app.get("/club")
@app.get("/situations")
@app.get("/profile")
async def serve_web():
    return FileResponse(os.path.join(WEB_DIR, "index.html"))


@app.get("/mini")
@app.get("/mini/")
async def serve_mini():
    return FileResponse(os.path.join(MINI_DIR, "index.html"))


@app.get("/admin")
async def serve_admin():
    return FileResponse(os.path.join(MINI_DIR, "admin.html"))


@app.get("/site")
@app.get("/site/")
@app.get("/site/app")
@app.get("/site/lessons")
@app.get("/site/dictionary")
@app.get("/site/word")
@app.get("/site/profile")
async def serve_site():
    return FileResponse(os.path.join(WEB_DIR, "app.html"))


# ====================== СТАТИКА ======================

app.mount("/static", StaticFiles(directory=MINI_DIR), name="static")
app.mount("/assets", StaticFiles(directory=WEB_DIR),  name="web-assets")


if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
