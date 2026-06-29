import os
import asyncio
import json
import urllib.parse
import urllib.request
from openai import AsyncOpenAI
from gtts import gTTS

# Groq API
GROQ_API_KEY = os.environ.get("GROQ_API_KEY")

if not GROQ_API_KEY:
    raise ValueError("GROQ_API_KEY environment variable is not set")

client = AsyncOpenAI(
    api_key=GROQ_API_KEY,
    base_url="https://api.groq.com/openai/v1"
)

# ── Языки ──────────────────────────────────────────────────────────
LANG_NAMES = {
    'ru': 'Russian',    'en': 'English',    'de': 'German',
    'fr': 'French',     'es': 'Spanish',    'it': 'Italian',
    'pt': 'Portuguese', 'zh': 'Chinese',    'ja': 'Japanese',
}

# Коды языков для Whisper
WHISPER_LANG = {
    'ru': 'ru', 'en': 'en', 'de': 'de', 'fr': 'fr',
    'es': 'es', 'it': 'it', 'pt': 'pt', 'zh': 'zh', 'ja': 'ja',
}

# Коды языков для gTTS
GTTS_LANG = {
    'ru': ('ru', 'com'), 'en': ('en', 'com'), 'de': ('de', 'de'),
    'fr': ('fr', 'fr'),  'es': ('es', 'es'),  'it': ('it', 'it'),
    'pt': ('pt', 'com'), 'zh': ('zh-CN', 'com'), 'ja': ('ja', 'co.jp'),
}

LEVEL_RULES = {
    "A1": "Use VERY simple, short sentences (10-20 words). Elementary vocabulary only. Always end with one simple question.",
    "A2": "Use simple grammar, 2-3 sentences. Basic conjugations. Ask a straightforward question at the end.",
    "B1": "Use natural intermediate vocabulary (conditionals, perfect tenses). 3-4 sentences. Ask open-ended questions.",
    "B2": "Speak naturally with idiomatic expressions, phrasal verbs, complex structures.",
    "C1": "Use sophisticated vocabulary, complex grammatical nuances. Native-level flow.",
    "C2": "Use sophisticated vocabulary, precise metaphors, complex nuances. Native-level flow.",
}

SITUATION_ROLES = {
    "shop":        "a friendly shop assistant in a supermarket",
    "restaurant":  "a polite waiter in a mid-range restaurant",
    "airport":     "a check-in agent at an international airport",
    "emergency":   "a calm emergency dispatcher",
    "hotel":       "a receptionist at a 4-star hotel",
    "doctor":      "a friendly general practitioner (GP) doctor",
}


# ── Конвертация ogg → wav ────────────────────────────────────────────
async def convert_ogg_to_wav(ogg_path: str, wav_path: str):
    try:
        import subprocess
        subprocess.run(
            ['ffmpeg', '-i', ogg_path, '-ar', '16000', '-ac', '1', '-c:a', 'pcm_s16le', wav_path],
            check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
        return True
    except Exception as e:
        print(f"❌ ogg → wav: {e}")
        return False


# ── Транскрипция ─────────────────────────────────────────────────────
async def transcribe_voice(file_path: str, target_lang: str = 'en') -> str:
    wav_path = None
    try:
        if file_path.lower().endswith('.ogg'):
            wav_path = file_path.replace('.ogg', '.wav')
            await convert_ogg_to_wav(file_path, wav_path)
            file_path = wav_path

        whisper_lang = WHISPER_LANG.get(target_lang, target_lang)
        with open(file_path, "rb") as f:
            transcript = await client.audio.transcriptions.create(
                model="whisper-large-v3",
                file=f,
                language=whisper_lang
            )
        return transcript.text.strip()
    except Exception as e:
        print(f"❌ Транскрипция: {e}")
        return ""
    finally:
        if wav_path and os.path.exists(wav_path):
            os.remove(wav_path)


# ── AI-ответ репетитора ───────────────────────────────────────────────
async def get_ai_response(
    user_text: str,
    user_level: str = "A1",
    situation: str = "",
    target_lang: str = "en",
    native_lang: str = "ru"
) -> str:
    target_name = LANG_NAMES.get(target_lang, "English")
    native_name  = LANG_NAMES.get(native_lang, "Russian")
    level_key    = (user_level or "A1").upper()
    level_rule   = LEVEL_RULES.get(level_key, LEVEL_RULES["A1"])

    if situation and situation in SITUATION_ROLES:
        role = SITUATION_ROLES[situation]
        system_prompt = (
            f"You are {role} — a native {target_name} speaker. "
            f"The person you are talking to is a {native_name} learner at level {level_key}. "
            f"{level_rule} "
            f"RULES: "
            f"1. Always speak ONLY in {target_name}. Never use {native_name}. Stay in character. "
            f"2. If the learner makes a grammar or vocabulary mistake, correct it naturally and briefly "
            f"   in {target_name} — the way a native speaker would. "
            f"   Example: 'Just a small tip — we say \'I would like\' not \'I want\'. Anyway, ...' "
            f"3. End with a natural in-character question to keep the conversation going."
        )
    else:
        system_prompt = (
            f"You are a native {target_name} speaker having a natural conversation. "
            f"The person you are talking to is learning {target_name} (their native language is {native_name}, level {level_key}). "
            f"{level_rule} "
            f"RULES: "
            f"1. Speak ONLY in {target_name}. Never switch to {native_name} or any other language. "
            f"2. Your {target_name} must always be grammatically perfect — you are the model. "
            f"3. If the learner makes a mistake, correct it gently and naturally in {target_name}, "
            f"   the way a native speaker would — brief, friendly, not like a teacher grading. "
            f"   Example: 'By the way, we usually say \'I went\' — \'go\' is irregular! But I understood you.' "
            f"4. If no mistakes — just continue naturally without mentioning it. "
            f"5. Always end with a question to keep the conversation going."
        )

    try:
        response = await client.chat.completions.create(
            model="llama-3.3-70b-versatile",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user",   "content": user_text}
            ],
            temperature=0.6
        )
        reply = response.choices[0].message.content.strip()
        print(f"💬 AI [{target_name}/{level_key}][{situation or 'club'}]: {reply[:80]}")
        return reply
    except Exception as e:
        print(f"❌ get_ai_response: {e}")
        return "Sorry, I'm having trouble. Could you repeat that?"


# ── Озвучивание ───────────────────────────────────────────────────────
async def generate_voice(text: str, output_path: str, target_lang: str = 'en'):
    try:
        lang_code, tld = GTTS_LANG.get(target_lang, ('en', 'com'))
        def save():
            tts = gTTS(text=text, lang=lang_code, tld=tld)
            tts.save(output_path)
        await asyncio.to_thread(save)
    except Exception as e:
        print(f"❌ generate_voice: {e}")


# ── Перевод слова ─────────────────────────────────────────────────────
def _extract_json(raw: str) -> dict:
    """Надёжное извлечение JSON из ответа LLM."""
    # Убираем markdown
    raw = raw.replace("```json", "").replace("```", "").strip()
    # Пробуем прямой парсинг
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        pass
    # Ищем первый JSON-объект в тексте
    import re
    match = re.search(r'\{[^{}]+\}', raw, re.DOTALL)
    if match:
        try:
            return json.loads(match.group(0))
        except json.JSONDecodeError:
            pass
    return {}


async def translate_word(
    word: str,
    context: str = "",
    native_lang: str = "ru",
    target_lang: str = "en"
) -> dict:
    """
    Переводит слово с target_lang на native_lang.
    Возвращает {translation, transcription, example} или translation="" при ошибке.
    Делает до 2 попыток при пустом переводе.
    """
    target_name = LANG_NAMES.get(target_lang, "English")
    native_name  = LANG_NAMES.get(native_lang, "Russian")

    system_prompt = (
        f"You are a {target_name}-{native_name} dictionary. "
        f"Reply ONLY with a JSON object, no other text. "
        f"Keys: translation ({native_name} meaning), transcription (IPA), example (short {target_name} sentence). "
        'Example reply: {"translation":"привет","transcription":"/həˈloʊ/","example":"Hello, how are you?"}'
    )
    user_content = f"Word: {word}"
    if context.strip():
        user_content += f"\nContext: {context.strip()[:200]}"

    models = ["llama-3.1-8b-instant", "llama-3.3-70b-versatile"]
    for attempt in range(2):
        try:
            response = await client.chat.completions.create(
                model=models[attempt % len(models)],
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user",   "content": user_content}
                ],
                temperature=0.1,
                max_tokens=200,
            )
            raw  = response.choices[0].message.content.strip()
            data = _extract_json(raw)
            translation = str(data.get("translation", "")).strip()
            if translation:
                return {
                    "translation":   translation,
                    "transcription": str(data.get("transcription", "")).strip(),
                    "example":       str(data.get("example", "")).strip()
                }
            print(f"⚠️ translate_word attempt {attempt+1}: empty translation, raw={raw[:100]}")
        except Exception as e:
            print(f"❌ translate_word '{word}' attempt {attempt+1}: {e}")

    # Fallback 1: простой перевод без JSON через Groq
    try:
        resp = await client.chat.completions.create(
            model="llama-3.1-8b-instant",
            messages=[{"role": "user", "content": f'Translate the {target_name} word "{word}" to {native_name}. Reply with just the translation, nothing else.'}],
            temperature=0.1, max_tokens=50,
        )
        t = resp.choices[0].message.content.strip().strip('"\'')
        if t:
            return {"translation": t, "transcription": "", "example": ""}
    except Exception as e:
        print(f"❌ translate_word fallback Groq: {e}")

    # Fallback 2: MyMemory (бесплатный API, без ключа)
    try:
        lang_pair = f"{target_lang}|{native_lang}"
        url = f"https://api.mymemory.translated.net/get?q={urllib.parse.quote(word)}&langpair={lang_pair}"
        def _fetch():
            with urllib.request.urlopen(url, timeout=5) as r:
                return json.loads(r.read().decode())
        data = await asyncio.to_thread(_fetch)
        t = data.get("responseData", {}).get("translatedText", "").strip()
        if t and t.lower() != word.lower():
            print(f"✅ translate_word MyMemory fallback: {word} → {t}")
            return {"translation": t, "transcription": "", "example": ""}
    except Exception as e:
        print(f"❌ translate_word fallback MyMemory: {e}")

    return {"translation": "", "transcription": "", "example": ""}
