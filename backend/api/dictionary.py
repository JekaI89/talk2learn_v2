from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import FileResponse
from pydantic import BaseModel
from typing import Optional
import traceback
import uuid
import os

from database.db import (
    add_word_to_user_dict,
    get_user_words,
    update_word_status,
    get_vocab_topics,
    get_vocab_cards,
    get_user_languages,
)
from utils.ai_service import generate_voice, translate_word
from config import AUDIO_DIR

router = APIRouter()


class AddWordRequest(BaseModel):
    user_id: int
    word: str
    translation: str
    transcription: str = ""
    context_example: str = ""


class QuickAddWordRequest(BaseModel):
    user_id: int
    word: str
    context_sentence: str = ""
    native_language: str = "ru"
    target_language: str = "en"


class WordStatusRequest(BaseModel):
    user_id: int
    word: str
    status: str  # 'learning' | 'known'


# ====================== ЛИЧНЫЙ СЛОВАРЬ ======================

@router.get("/api/dictionary/{user_id}")
async def get_dictionary(user_id: int):
    try:
        words = await get_user_words(user_id)
        return [
            {
                "word": w["word"],
                "translation": w["translation"],
                "transcription": w["transcription"] or "",
                "context_example": w["context_example"] or "",
                "status": w["status"],
            }
            for w in words
        ]
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, "Ошибка получения словаря")


@router.post("/api/dictionary/add")
async def add_word(data: AddWordRequest):
    try:
        success = await add_word_to_user_dict(
            user_id=data.user_id, word=data.word, translation=data.translation,
            transcription=data.transcription, context=data.context_example,
        )
        if success:
            return {"status": "success", "message": "Слово добавлено в словарь"}
        return {"status": "error", "message": "Не удалось добавить слово"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.post("/api/dictionary/quick_add")
async def quick_add_word(data: QuickAddWordRequest):
    """Перевод слова через AI + сохранение в личный словарь."""
    try:
        word_clean = data.word.strip()
        if not word_clean:
            raise HTTPException(400, "Пустое слово")

        translated = await translate_word(word_clean, context=data.context_sentence)
        if not translated["translation"]:
            return {"status": "error", "message": "Не удалось получить перевод, попробуйте ещё раз"}

        success = await add_word_to_user_dict(
            user_id=data.user_id, word=word_clean,
            translation=translated["translation"],
            transcription=translated["transcription"],
            context=translated["example"] or data.context_sentence,
        )
        if not success:
            return {"status": "error", "message": "Не удалось добавить слово"}

        return {
            "status": "success",
            "word": word_clean,
            "translation": translated["translation"],
            "transcription": translated["transcription"],
            "context_example": translated["example"],
        }
    except HTTPException:
        raise
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.post("/api/dictionary/translate")
async def translate_word_only(data: QuickAddWordRequest):
    try:
        word_clean = data.word.strip()
        if not word_clean:
            raise HTTPException(400, "Пустое слово")

        if data.user_id > 0 and (data.native_language == "ru" and data.target_language == "en"):
            try:
                langs = await get_user_languages(data.user_id)
                native, target = langs["native"], langs["target"]
            except Exception:
                native, target = data.native_language, data.target_language
        else:
            native, target = data.native_language, data.target_language

        translated = await translate_word(
            word_clean, context=data.context_sentence,
            native_lang=native, target_lang=target,
        )
        if not translated["translation"]:
            return {"status": "error", "message": "Не удалось получить перевод"}
        return {
            "status": "success",
            "word": word_clean,
            "translation": translated["translation"],
            "transcription": translated["transcription"],
            "context_example": translated["example"],
        }
    except HTTPException:
        raise
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.post("/api/dictionary/status")
async def set_word_status(data: WordStatusRequest):
    try:
        if data.status not in ("learning", "known"):
            raise HTTPException(400, "status должен быть 'learning' или 'known'")
        await update_word_status(data.user_id, data.word, data.status)
        return {"status": "success"}
    except HTTPException:
        raise
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


# ====================== TTS ======================

@router.get("/api/tts/word")
async def tts_word(word: str = Query(...)):
    """Синтез речи для одного слова через gTTS."""
    try:
        session_id = f"word_{uuid.uuid4().hex[:8]}"
        output_path = os.path.join(AUDIO_DIR, f"{session_id}.mp3")
        await generate_voice(word, output_path)
        return FileResponse(output_path, media_type="audio/mpeg",
                            headers={"Cache-Control": "public, max-age=3600"})
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


# ====================== VOCABULARY CARDS ======================

@router.get("/api/vocab/topics")
async def vocab_topics(level: Optional[str] = Query(None)):
    try:
        rows = await get_vocab_topics(level)
        return [dict(r) for r in rows]
    except Exception as e:
        traceback.print_exc()
        return []


@router.get("/api/vocab/cards")
async def vocab_cards(topic: str = Query(...), level: Optional[str] = Query(None)):
    try:
        rows = await get_vocab_cards(topic, level)
        return [dict(r) for r in rows]
    except Exception as e:
        traceback.print_exc()
        return []
