from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
import traceback

from database.db import (
    get_admin_statistics,
    get_all_lessons,
    get_lesson_by_id,
    add_lesson,
    update_lesson,
    delete_lesson,
    add_question,
    update_user_status,
    get_all_vocab_cards_admin,
    add_vocab_card,
    update_vocab_card,
    delete_vocab_card,
)

router = APIRouter()


class AddLessonRequest(BaseModel):
    level: str
    title: str
    lesson_text: str = ""
    content_type: str = "lesson"
    order_num: int = 0
    language: str = "en"


class UpdateLessonRequest(BaseModel):
    id: int
    level: str
    title: str
    lesson_text: str = ""
    content_type: str = "lesson"
    order_num: int = 0
    language: str = "en"


class AddQuestionRequest(BaseModel):
    lesson_id: int
    level: str
    task_type: str
    question_text: str
    option_1: str = ""
    option_2: str = ""
    option_3: str = ""
    correct_option: int = 1


class ManageUserRequest(BaseModel):
    tg_id: str
    action: str


class VocabCardCreate(BaseModel):
    topic: str
    level: str = "A1"
    word: str
    translation: str
    emoji_code: str
    definition: str = ""
    order_num: int = 0


class VocabCardUpdate(VocabCardCreate):
    id: int


# ====================== УРОКИ ======================

@router.get("/api/admin/stats")
async def admin_stats():
    try:
        return await get_admin_statistics()
    except Exception as e:
        raise HTTPException(500, str(e))


@router.get("/api/admin/lessons")
async def admin_lessons(language: Optional[str] = Query(None)):
    try:
        rows = await get_all_lessons(language=language)
        return [
            {
                "id": r["id"], "level": r["level"], "title": r["title"],
                "type": r["content_type"], "language": r.get("language", "en"),
                "order_num": r.get("order_num", 0), "lesson_text": r.get("lesson_text", ""),
            }
            for r in rows
        ]
    except Exception as e:
        traceback.print_exc()
        return []


@router.get("/api/admin/lessons_for_questions")
async def admin_lessons_for_questions():
    try:
        rows = await get_all_lessons()
        return [{"id": r["id"], "level": r["level"], "title": r["title"]} for r in rows]
    except Exception as e:
        traceback.print_exc()
        return []


@router.get("/api/admin/lesson/{lesson_id}")
async def admin_get_lesson(lesson_id: int):
    try:
        row = await get_lesson_by_id(lesson_id)
        if not row:
            raise HTTPException(404, "Урок не найден")
        return dict(row)
    except HTTPException:
        raise
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.post("/api/admin/add_lesson")
async def admin_add_lesson(data: AddLessonRequest):
    try:
        lesson_id = await add_lesson(
            level=data.level, title=data.title, lesson_text=data.lesson_text,
            content_type=data.content_type, order_num=data.order_num, language=data.language,
        )
        return {"status": "success", "id": lesson_id, "message": "Урок добавлен"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.put("/api/admin/update_lesson")
async def admin_update_lesson(data: UpdateLessonRequest):
    try:
        await update_lesson(
            lesson_id=data.id, title=data.title, lesson_text=data.lesson_text,
            level=data.level, content_type=data.content_type,
            order_num=data.order_num, language=data.language,
        )
        return {"status": "success", "message": "Урок обновлён"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.delete("/api/admin/delete_lesson/{lesson_id}")
async def admin_delete_lesson(lesson_id: int):
    try:
        await delete_lesson(lesson_id)
        return {"status": "success", "message": f"Урок {lesson_id} удалён"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.post("/api/admin/add_question")
async def admin_add_question(data: AddQuestionRequest):
    try:
        await add_question(
            lesson_id=data.lesson_id, level=data.level, task_type=data.task_type,
            question_text=data.question_text, option_1=data.option_1,
            option_2=data.option_2, option_3=data.option_3, correct_option=data.correct_option,
        )
        return {"status": "success", "message": "Вопрос добавлен"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.post("/api/admin/manage_user")
async def admin_manage_user(data: ManageUserRequest):
    try:
        user_id = int(data.tg_id.lstrip("@"))
    except ValueError:
        raise HTTPException(400, "Некорректный ID пользователя")

    action_map = {
        "grant_premium":  ("is_premium", True),
        "revoke_premium": ("is_premium", False),
        "grant_admin":    ("is_admin",   True),
        "revoke_admin":   ("is_admin",   False),
    }
    if data.action not in action_map:
        raise HTTPException(400, "Неизвестное действие")

    field, value = action_map[data.action]
    try:
        await update_user_status(user_id, field, value)
        return {"status": "success"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


# ====================== VOCAB CARDS ======================

@router.get("/api/admin/vocab")
async def admin_vocab_all():
    try:
        rows = await get_all_vocab_cards_admin()
        return [dict(r) for r in rows]
    except Exception as e:
        traceback.print_exc()
        return []


@router.post("/api/admin/vocab/add")
async def admin_vocab_add(data: VocabCardCreate):
    try:
        card_id = await add_vocab_card(
            topic=data.topic, level=data.level, word=data.word,
            translation=data.translation, emoji_code=data.emoji_code,
            definition=data.definition, order_num=data.order_num,
        )
        return {"status": "success", "id": card_id}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.put("/api/admin/vocab/update")
async def admin_vocab_update(data: VocabCardUpdate):
    try:
        await update_vocab_card(
            card_id=data.id, topic=data.topic, level=data.level,
            word=data.word, translation=data.translation,
            emoji_code=data.emoji_code, definition=data.definition,
        )
        return {"status": "success"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.delete("/api/admin/vocab/delete/{card_id}")
async def admin_vocab_delete(card_id: int):
    try:
        await delete_vocab_card(card_id)
        return {"status": "success"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))
