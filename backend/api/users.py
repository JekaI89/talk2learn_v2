from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
import traceback

from database.db import (
    register_or_get_user,
    get_all_lessons,
    get_user_category_stats,
    complete_onboarding,
    get_onboarding_status,
    get_user_languages,
    update_user_languages,
)
from config import ADMIN_IDS

router = APIRouter()


class RegisterUserRequest(BaseModel):
    user_id: int
    name: str = ""
    username: str = ""


class OnboardingRequest(BaseModel):
    user_id: int
    level: str
    goal: str = ""
    native_language: str = "ru"
    target_language: str = "en"


class UserLanguagesRequest(BaseModel):
    user_id: int
    native_language: str
    target_language: str


# ====================== ДАШБОРД ======================

@router.get("/api/dashboard/{user_id}")
async def get_dashboard(user_id: int):
    try:
        from database.db import get_pool
        pool = await get_pool()
        async with pool.acquire() as db:
            user = await db.fetchrow(
                "SELECT level, xp, streak, is_admin FROM users WHERE user_id = $1", user_id
            )
        lessons = await get_all_lessons()
        is_admin = user_id in ADMIN_IDS or bool(user and user["is_admin"])
        return {
            "user": {
                "level": user["level"] if user else "A1",
                "xp": user["xp"] if user else 0,
                "streak": user["streak"] if user else 0,
                "is_admin": is_admin,
            },
            "total_lessons": len(lessons),
            "available_levels": ["A1", "A2", "B1", "B2", "C1", "C2"],
        }
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


# ====================== ПРОФИЛЬ ======================

@router.get("/api/profile/{user_id}")
async def get_profile(user_id: int):
    try:
        from database.db import get_pool
        pool = await get_pool()
        async with pool.acquire() as db:
            user = await db.fetchrow("""
                SELECT level, xp, streak, is_premium, is_admin, name, username
                FROM users WHERE user_id = $1
            """, user_id)
            if not user:
                return {"level": "A1", "xp": 0, "streak": 0, "is_premium": False,
                        "is_admin": False, "name": "", "username": "",
                        "lessons_done": 0, "tasks_done": 0}

            row = await db.fetchrow("""
                SELECT COUNT(*) as cnt FROM user_progress
                WHERE user_id = $1 AND content_type IN ('lesson', 'grammar')
            """, user_id)
            lessons_done = row["cnt"]

            row = await db.fetchrow("""
                SELECT COUNT(*) as cnt FROM user_progress
                WHERE user_id = $1 AND content_type IN ('practice', 'speaking', 'question')
            """, user_id)
            tasks_done = row["cnt"]

        is_admin = user_id in ADMIN_IDS or bool(user["is_admin"])
        cat_stats = await get_user_category_stats(user_id)
        return {
            "name": user["name"] or "",
            "username": user["username"] or "",
            "level": user["level"],
            "xp": user["xp"],
            "streak": user["streak"],
            "is_premium": bool(user["is_premium"]),
            "is_admin": is_admin,
            "lessons_done": lessons_done,
            "tasks_done": tasks_done,
            "category_stats": cat_stats,
        }
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


# ====================== РЕГИСТРАЦИЯ ======================

@router.post("/api/register_user")
async def register_user(data: RegisterUserRequest):
    try:
        level = await register_or_get_user(data.user_id, data.name, data.username)
        return {"status": "success", "level": level}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


# ====================== ОНБОРДИНГ ======================

@router.get("/api/onboarding/{user_id}")
async def check_onboarding(user_id: int):
    try:
        done = await get_onboarding_status(user_id)
        # Получаем XP пользователя
        pool = await get_pool()
        async with pool.acquire() as db:
            row = await db.fetchrow(
                "SELECT xp, streak FROM users WHERE user_id = $1", user_id
            )
        xp = row["xp"] if row else 0
        streak = row["streak"] if row else 0
        # Если есть XP или стрик — пользователь уже активный, онбординг не нужен
        if xp > 0 or streak > 0:
            done = True
        return {"onboarding_done": done, "xp": xp}
    except Exception as e:
        traceback.print_exc()
        return {"onboarding_done": True, "xp": 0}


@router.post("/api/onboarding/complete")
async def finish_onboarding(data: OnboardingRequest):
    try:
        await complete_onboarding(
            data.user_id, data.level, data.goal,
            data.native_language, data.target_language
        )
        return {"status": "success"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


@router.get("/api/user/languages/{user_id}")
async def get_languages(user_id: int):
    try:
        return await get_user_languages(user_id)
    except Exception as e:
        traceback.print_exc()
        return {"native": "ru", "target": "en"}


@router.post("/api/user/languages")
async def set_languages(data: UserLanguagesRequest):
    try:
        await update_user_languages(data.user_id, data.native_language, data.target_language)
        return {"status": "success"}
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(500, str(e))


# ====================== СТАТИСТИКА ======================

@router.get("/api/stats/categories/{user_id}")
async def category_stats(user_id: int):
    try:
        return await get_user_category_stats(user_id)
    except Exception as e:
        traceback.print_exc()
        return {}
