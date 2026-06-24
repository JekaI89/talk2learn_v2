from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
import traceback
import random as _random

from database.db import (
    get_all_lessons,
    get_next_uncompleted_lesson,
    get_lesson_progress,
    save_user_progress,
    update_user_streak,
    get_random_practice_question,
    get_user_languages,
)

router = APIRouter()


class AnswerCheckRequest(BaseModel):
    user_id: int
    queue_item_id: int
    is_correct: bool


class ProgressRequest(BaseModel):
    user_id: int
    content_type: str
    content_id: int


# ====================== УРОКИ ======================

@router.get("/api/lessons/{level}")
async def get_lessons_by_level(level: str, user_id: Optional[int] = Query(None)):
    try:
        lessons = await get_all_lessons()
        filtered = [l for l in lessons if l["level"] == level]
        return [
            {"id": l["id"], "title": l["title"], "type": l["content_type"], "completed": False}
            for l in filtered
        ]
    except Exception as e:
        traceback.print_exc()
        return []


@router.get("/api/lessons/next/{level}")
async def get_next_lesson(level: str, user_id: int = Query(...),
                          content_type: Optional[str] = Query(None)):
    try:
        langs = await get_user_languages(user_id)
        row = await get_next_uncompleted_lesson(
            user_id, level, content_type, language=langs["target"]
        )
        progress = await get_lesson_progress(user_id, level, content_type)

        if not row:
            return {"completed": True, "progress": progress}

        return {
            "completed": False,
            "id": row["id"],
            "title": row["title"],
            "lesson_text": row["lesson_text"] or "",
            "type": row["content_type"],
            "progress": progress,
        }
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, "Ошибка загрузки урока")


@router.get("/api/lesson/{lesson_id}")
async def get_lesson(lesson_id: int):
    try:
        from database.db import get_pool
        pool = await get_pool()
        async with pool.acquire() as db:
            row = await db.fetchrow("""
                SELECT id, title, lesson_text, content_type
                FROM lessons WHERE id = $1 AND is_active = TRUE
            """, lesson_id)
        if not row:
            raise HTTPException(404, "Урок не найден")
        return {
            "id": row["id"],
            "title": row["title"],
            "lesson_text": row["lesson_text"] or "",
            "type": row["content_type"],
        }
    except HTTPException:
        raise
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, "Ошибка загрузки урока")


# ====================== ПРОГРЕСС ======================

@router.post("/api/progress/complete")
async def complete_content(data: ProgressRequest):
    try:
        result = await save_user_progress(data.user_id, data.content_type, data.content_id)
        await update_user_streak(data.user_id)
        return {
            "status": "success",
            "xp_earned": result["xp_earned"],
            "message": "Баллы зачислены" if result["status"] == "success" else "Уже пройдено ранее",
        }
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


# ====================== ПРАКТИКА ======================

@router.get("/api/random_question")
async def random_question(
    user_id: int = Query(...),
    level: str = Query("A1"),
    task_type: str = Query("multiple_choice", alias="type"),
):
    try:
        langs = await get_user_languages(user_id)
        row = await get_random_practice_question(user_id, level, task_type, language=langs["target"])
        if not row:
            return {"error": "no_more_questions"}

        if task_type == "sentence_builder":
            correct_sentence = row["option_1"] or ""
            distractors = [w.strip() for w in (row["option_2"] or "").split(",") if w.strip()]
            word_bank = correct_sentence.split() + distractors
            _random.shuffle(word_bank)
            return {
                "question_id": row["id"],
                "task_type": "sentence_builder",
                "question": row["question_text"],
                "correct_sentence": correct_sentence,
                "word_bank": word_bank,
            }

        return {
            "question_id": row["id"],
            "task_type": "multiple_choice",
            "question": row["question_text"],
            "options": [row["option_1"], row["option_2"], row["option_3"]],
            "correct_option": row["correct_option"],
        }
    except Exception as e:
        traceback.print_exc()
        return {"error": "server_error"}


@router.post("/api/check_answer")
async def check_answer(data: AnswerCheckRequest):
    try:
        return {"status": "success", "is_correct": data.is_correct}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))
