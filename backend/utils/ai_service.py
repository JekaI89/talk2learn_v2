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
    "A1": "Vocabulary: basic nouns, verbs, adjectives (200-500 words). Grammar: present simple, 'to be', 'have got'. Sentences: 5-12 words max. Topics: family, food, home, daily routine, simple feelings. Ask ONE very simple question.",
    "A2": "Vocabulary: ~1000 words, common phrases. Grammar: past simple, future 'going to', comparatives. 2-3 sentences. Topics: work, transport, weather, hobbies, travel. Ask a clear simple question.",
    "B1": "Vocabulary: ~2000 words, some idioms. Grammar: present perfect, conditionals (1st/2nd), passive. 3-4 sentences. Topics: news, environment, culture, opinions. Ask an open question.",
    "B2": "Vocabulary: ~4000 words, phrasal verbs, idiomatic expressions. Complex structures, nuanced opinions. Topics: society, technology, abstract ideas. Engage in real debate.",
    "C1": "Near-native fluency. Sophisticated lexis, humor, implicit meaning, complex arguments. Any topic.",
    "C2": "Full native-level fluency. Metaphors, irony, cultural references, precise nuance.",
}

CONVERSATION_TOPICS = {
    "A1": ["your name and age", "your family", "your favorite food", "your daily routine", "where you live", "pets", "colors and numbers", "the weather today"],
    "A2": ["your job or studies", "your last weekend", "your hobbies", "a place you like", "your morning routine", "shopping", "your hometown"],
    "B1": ["a recent trip", "your opinion on social media", "a book or film you liked", "environmental issues", "future plans", "work-life balance"],
    "B2": ["technology and society", "political issues", "cultural differences", "career ambitions", "ethical dilemmas", "art and creativity"],
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
    native_lang: str = "ru",
    history: list = None
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
        import random
        topics = CONVERSATION_TOPICS.get(level_key, CONVERSATION_TOPICS["A1"])
        topic_hint = random.choice(topics)
        system_prompt = (
            f"You are Alex, a friendly native {target_name} speaker chatting with a language learner. "
            f"Learner level: {level_key}. {level_rule} "
            f"PERSONALITY: warm, curious, encouraging. You love asking about people's lives, opinions, experiences. "
            f"VARIETY RULES — critical: "
            f"1. NEVER repeat phrases you've already said. NEVER say 'That's great!', 'That sounds wonderful!', 'You are happy', 'That's amazing!' more than once per conversation. "
            f"2. Vary your reactions: sometimes express surprise, sometimes share your own opinion, sometimes disagree gently, sometimes tell a short anecdote. "
            f"3. Don't always ask the same type of question. Mix: yes/no, open-ended, follow-up, hypothetical. "
            f"4. If the learner gives a short answer, dig deeper — ask a follow-up about details. "
            f"5. Speak ONLY in {target_name}. Grammatically perfect always. "
            f"6. Gently correct mistakes the natural way: weave the correct form into your reply. "
            f"7. Keep responses {('short — 1-2 sentences max' if level_key in ('A1','A2') else '2-4 sentences')}. "
            f"If the conversation is just starting, ask about: {topic_hint}."
        )

    try:
        # Строим messages с историей (последние 10 обменов = 20 сообщений)
        messages = [{"role": "system", "content": system_prompt}]
        if history:
            for msg in history[-20:]:
                role = msg.get("role", "user")
                if role not in ("user", "assistant"): continue
                messages.append({"role": role, "content": msg.get("content", "")})
        messages.append({"role": "user", "content": user_text})

        response = await client.chat.completions.create(
            model="llama-3.3-70b-versatile",
            messages=messages,
            temperature=0.8,
            max_tokens=300,
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
