from fastapi import APIRouter, HTTPException, File, UploadFile, Form
import traceback
import shutil
import uuid
import os

from utils.ai_service import transcribe_voice, get_ai_response, generate_voice
from config import AUDIO_DIR

router = APIRouter()


@router.post("/api/web-club/text")
async def web_club_text(
    user_id: int = Form(...),
    text: str = Form(...),
    level: str = Form("A1"),
    situation: str = Form(""),
    native_language: str = Form("ru"),
    target_language: str = Form("en"),
):
    try:
        ai_response = await get_ai_response(
            text, user_level=level, situation=situation,
            target_lang=target_language, native_lang=native_language,
        )
        session_id = f"ai_{user_id}_{uuid.uuid4().hex[:6]}"
        output_path = os.path.join(AUDIO_DIR, f"{session_id}.mp3")
        await generate_voice(ai_response, output_path, target_lang=target_language)
        return {
            "user_text": text,
            "ai_text": ai_response,
            "audio_url": f"/static/audio/{session_id}.mp3",
        }
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.post("/api/web-club/voice")
async def web_club_voice(
    user_id: int = Form(...),
    file: UploadFile = File(...),
    level: str = Form("A1"),
    situation: str = Form(""),
    native_language: str = Form("ru"),
    target_language: str = Form("en"),
):
    try:
        temp_path = os.path.join(AUDIO_DIR, f"user_{user_id}_{uuid.uuid4().hex[:6]}.wav")
        with open(temp_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        user_text = await transcribe_voice(temp_path, target_lang=target_language)
        if os.path.exists(temp_path):
            os.remove(temp_path)

        if not user_text.strip():
            return {"user_text": "", "ai_text": "I couldn't hear you. Please try again!", "audio_url": ""}

        ai_response = await get_ai_response(
            user_text, user_level=level, situation=situation,
            target_lang=target_language, native_lang=native_language,
        )
        session_id = f"ai_{user_id}_{uuid.uuid4().hex[:6]}"
        output_path = os.path.join(AUDIO_DIR, f"{session_id}.mp3")
        await generate_voice(ai_response, output_path, target_lang=target_language)

        return {
            "user_text": user_text,
            "ai_text": ai_response,
            "audio_url": f"/static/audio/{session_id}.mp3",
        }
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))
