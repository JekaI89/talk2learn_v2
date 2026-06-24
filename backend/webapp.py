from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, Response
from contextlib import asynccontextmanager
import os
import asyncio
import time
from pathlib import Path

from database.db import init_db, close_pool
from config import MINI_DIR, WEB_DIR, AUDIO_DIR

from api import users, lessons, dictionary, club, admin, auth


# ====================== BOT ======================

_bot_instance = None  # хранится для корректного shutdown


async def start_telegram_bot():
    global _bot_instance
    bot_token = os.environ.get("BOT_TOKEN", "")
    if not bot_token:
        print("⚠️ BOT_TOKEN не задан — Telegram-бот не запущен")
        return
    try:
        from aiogram import Bot, Dispatcher
        from aiogram.client.default import DefaultBotProperties
        from aiogram.enums import ParseMode
        from handlers import menu, speaking_club

        _bot_instance = Bot(
            token=bot_token,
            default=DefaultBotProperties(parse_mode=ParseMode.HTML)
        )
        dp = Dispatcher()
        dp.include_router(menu.router)
        dp.include_router(speaking_club.router)

        print("🤖 Telegram-бот запущен (polling)...")
        await dp.start_polling(
            _bot_instance,
            allowed_updates=["message", "callback_query"],
            drop_pending_updates=True,   # сбрасываем старую очередь при старте
        )
    except asyncio.CancelledError:
        print("🤖 Telegram-бот: получен сигнал остановки")
    except Exception as e:
        print(f"❌ Ошибка Telegram-бота: {e}")
    finally:
        # Закрываем сессию — иначе следующий инстанс получит Conflict
        if _bot_instance:
            try:
                await _bot_instance.session.close()
            except Exception:
                pass
            _bot_instance = None
        print("🤖 Telegram-бот остановлен")


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
                print(f"🧹 Аудиоочистка: удалено {cleaned} файлов")
        except asyncio.CancelledError:
            break
        except Exception as e:
            print(f"❌ Ошибка очистки аудио: {e}")


# ====================== LIFESPAN ======================

@asynccontextmanager
async def lifespan(app: FastAPI):
    print("🚀 Запуск Talk2Learn...")
    os.makedirs(AUDIO_DIR, exist_ok=True)
    await init_db()

    bot_task     = asyncio.create_task(start_telegram_bot())
    cleanup_task = asyncio.create_task(audio_cleanup_loop())

    yield

    print("🛑 Остановка Talk2Learn...")

    # Отменяем задачи и ждём корректного завершения
    bot_task.cancel()
    cleanup_task.cancel()

    await asyncio.gather(bot_task, cleanup_task, return_exceptions=True)

    await close_pool()
    print("✅ Остановка завершена")


# ====================== APP ======================

app = FastAPI(lifespan=lifespan)

app.include_router(users.router)
app.include_router(lessons.router)
app.include_router(dictionary.router)
app.include_router(club.router)
app.include_router(admin.router)
app.include_router(auth.router)


# ====================== СТАТИКА ======================

app.mount("/static", StaticFiles(directory=MINI_DIR), name="static")
app.mount("/assets", StaticFiles(directory=WEB_DIR),  name="web-assets")


# ====================== FAVICON ======================

@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    # Минимальный 1x1 прозрачный ico в base64
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

@app.get("/")
@app.get("/app")
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


# ====================== SITE (SPA роуты) ======================

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
