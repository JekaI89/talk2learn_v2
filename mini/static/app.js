// ─────────────────────────────────────────────
// INIT
// ─────────────────────────────────────────────
const tg = window.Telegram.WebApp;
tg.ready(); tg.expand();
const userId = tg.initDataUnsafe?.user?.id || 0;
let currentLevel = "A1";
let currentCategory = "lessons";
let correctPracticeOption = null;
let currentPracticeQuestionId = null;
let mediaRecorder = null, audioChunks = [], streamRef = null;
let popupWord = '', popupContext = '';

// Языки пользователя (загружаются при старте)
let userNativeLang = 'ru';
let userTargetLang = 'en';

const LANG_FLAGS = {
  'ru':'🇷🇺','en':'🇬🇧','de':'🇩🇪','fr':'🇫🇷',
  'es':'🇪🇸','it':'🇮🇹','pt':'🇵🇹','zh':'🇨🇳','ja':'🇯🇵'
};
const LANG_NAMES_RU = {
  'ru':'Русский','en':'Английский','de':'Немецкий','fr':'Французский',
  'es':'Испанский','it':'Итальянский','pt':'Португальский','zh':'Китайский','ja':'Японский'
};

const LEVELS = ['A1','A2','B1','B2','C1','C2'];
const LEVEL_GRADIENTS = {
  'A1': 'from-green-400 to-teal-500',
  'A2': 'from-blue-400 to-indigo-500',
  'B1': 'from-orange-400 to-amber-500',
  'B2': 'from-pink-400 to-rose-500',
  'C1': 'from-red-400 to-purple-500',
  'C2': 'from-zinc-600 to-gray-800',
};

const SCREENS = [
  'screen-onboarding','screen-no-content',
  'screen-main','screen-levels','screen-personal-dict',
  'screen-lesson','screen-level-complete',
  'screen-practice-task','screen-practice-mode',
  'screen-sentence-builder',
  'screen-situations','screen-situation-chat',
  'screen-club','screen-profile','screen-lang-settings',
  'screen-dictionary','screen-vocab-cards'
];

// Header back-button stack
let backStack = [];

function showScreen(screenId, pushBack = null) {
  SCREENS.forEach(s => {
    const el = document.getElementById(s);
    if (el) el.classList.add('hidden');
  });
  document.getElementById(screenId)?.classList.remove('hidden');
  hideWordPopup();
  updateHeader(screenId, pushBack);
  // Bottom nav only on main
  document.getElementById('bottom-nav').classList.toggle('hidden', screenId !== 'screen-main');
}

function updateHeader(screenId, backTarget) {
  const backBtn = document.getElementById('header-back');
  const avatarEl = document.getElementById('header-avatar');
  const userInfo = document.getElementById('header-user-info');
  const titleBlock = document.getElementById('header-title-block');
  const progressEl = document.getElementById('header-progress');
  const adminBadge = document.getElementById('admin-badge');

  // Reset
  backBtn.classList.add('hidden');
  avatarEl.classList.remove('hidden');
  userInfo.classList.remove('hidden');
  titleBlock.classList.add('hidden');
  progressEl.classList.add('hidden');

  if (screenId === 'screen-main') {
    backStack = [];
  } else {
    backBtn.classList.remove('hidden');
    if (backTarget) backStack.push(backTarget);
  }

  // Screen-specific header tweaks
  if (screenId === 'screen-lesson' || screenId === 'screen-practice-task') {
    progressEl.classList.remove('hidden');
  }
}

function headerBack() {
  if (backStack.length) {
    const prev = backStack.pop();
    showScreen(prev);
  } else {
    showScreen('screen-main');
  }
}

// ─────────────────────────────────────────────
// PROFILE LOAD
// ─────────────────────────────────────────────
async function loadProfile() {
  try {
    const tgUser = tg.initDataUnsafe?.user;
    document.getElementById('user-name').textContent = tgUser?.first_name || 'Ученик';
    document.getElementById('header-avatar').textContent = (tgUser?.first_name || 'TL')[0].toUpperCase();

    await fetch('/api/register_user', {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({ user_id: userId, name: tgUser?.first_name || '', username: tgUser?.username || '' })
    });

    const res = await fetch(`/api/dashboard/${userId}`);
    const data = await res.json();
    const p = data.user || data;
    if (p) {
      document.getElementById('user-streak').textContent = p.streak ?? 0;
      document.getElementById('user-xp').textContent = p.xp ?? 0;
      const xpPct = xpProgress(p.xp || 0);
      document.getElementById('header-progress-fill').style.width = xpPct + '%';
      if (p.is_admin || data.is_admin) {
        document.getElementById('admin-badge').classList.remove('hidden');
      }
    }
  } catch(e) { console.error(e); }
}

// ─────────────────────────────────────────────
// CATEGORY / LEVEL
// ─────────────────────────────────────────────
function chooseCategory(category) {
  currentCategory = category;
  document.getElementById('levels-grid').innerHTML = LEVELS.map(lvl => {
    const g = LEVEL_GRADIENTS[lvl] || LEVEL_GRADIENTS['A1'];
    return `<button onclick="selectLevel('${lvl}')"
      class="bg-gradient-to-br ${g} rounded-2xl p-lg text-white text-left active:scale-95 transition-transform shadow-sm">
      <span class="font-label text-xs text-white/70 uppercase tracking-wider block mb-xs">Уровень</span>
      <span class="font-headline font-extrabold text-3xl block">${lvl}</span>
    </button>`;
  }).join('');
  showScreen('screen-levels', 'screen-main');
}

function selectLevel(level) {
  currentLevel = level;
  document.getElementById('club-level-badge').textContent = level;
  document.getElementById('practice-level-badge').textContent = level;
  document.getElementById('sb-level-badge').textContent = level;
  document.getElementById('pm-level-badge').textContent = level;
  if (currentCategory === 'practice') {
    showScreen('screen-practice-mode', 'screen-levels');
  } else {
    openNextLesson();
  }
}

let currentPracticeMode = 'multiple_choice';
function startPracticeMode(mode) {
  currentPracticeMode = mode;
  if (mode === 'sentence_builder') {
    loadSentenceBuilder();
  } else {
    loadPracticeTask();
  }
}

// ─────────────────────────────────────────────
// LESSONS
// ─────────────────────────────────────────────
async function openNextLesson() {
  showScreen('screen-lesson', 'screen-levels');
  const dataDiv = document.getElementById('lesson-data');
  dataDiv.innerHTML = `<div class="flex items-center gap-sm text-outline py-xl justify-center">
    <span class="material-symbols-outlined animate-spin">progress_activity</span> Загрузка...
  </div>`;
  const typeMap = { lessons:'lesson', grammar:'grammar', vocabulary:'vocabulary' };
  const contentType = typeMap[currentCategory] || 'lesson';
  try {
    const res = await fetch(`/api/lessons/next/${currentLevel}?user_id=${userId}&content_type=${contentType}`);
    const lesson = await res.json();
    if (lesson.completed) { showLevelComplete(); return; }
    renderLesson(lesson);
  } catch(e) {
    dataDiv.innerHTML = `<p class="text-error text-center py-lg">Ошибка загрузки</p>`;
  }
}

function renderLesson(lesson) {
  const dataDiv = document.getElementById('lesson-data');
  const iconMap = { grammar:'edit_note', vocabulary:'psychology', lesson:'menu_book' };
  const icon = iconMap[lesson.type] || 'menu_book';
  const rawText = lesson.lesson_text || 'Текст урока пуст.';
  const clickableBody = makeTextClickable(rawText, rawText);

  dataDiv.innerHTML = `
    <div class="flex items-center gap-sm mb-md">
      <span class="material-symbols-outlined filled text-primary-container">${icon}</span>
      <span class="font-label text-xs text-outline uppercase tracking-wider">${lesson.type || 'урок'} · ${currentLevel}</span>
    </div>
    <h1 class="font-headline font-extrabold text-on-surface text-2xl mb-lg leading-tight">${lesson.title}</h1>
    <p class="font-label text-xs text-outline mb-sm">💡 Нажмите на слово для перевода</p>
    <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-lg text-on-surface-variant leading-loose text-base font-body lesson-text-body mb-xl">
      ${clickableBody}
    </div>
    <button id="complete-lesson-btn" onclick="submitProgress('${lesson.type||'lesson'}', ${lesson.id})"
      class="w-full h-touch rounded-xl bg-tertiary-container text-on-tertiary font-label font-bold uppercase tracking-wider text-sm active:scale-[0.98] transition-transform shadow-md">
      <span data-i18n="btn_complete">✅ Просмотрено · +5 XP</span>
    </button>
  `;
}

// ─────────────────────────────────────────────
// LEVEL COMPLETE
// ─────────────────────────────────────────────
function showLevelComplete() {
  const idx = LEVELS.indexOf(currentLevel);
  const hasNext = idx < LEVELS.length - 1;
  const nextBtn = document.getElementById('btn-next-level');
  const msg = document.getElementById('level-complete-msg');
  if (hasNext) {
    nextBtn.classList.remove('hidden');
    nextBtn.textContent = `Следующий уровень: ${LEVELS[idx+1]} →`;
    msg.textContent = `Вы прошли все материалы уровня ${currentLevel}. Отличная работа!`;
  } else {
    nextBtn.classList.add('hidden');
    msg.textContent = 'Поздравляем! Вы прошли все уровни. Вы — настоящий мастер!';
  }
  showScreen('screen-level-complete');
}

function goNextLevel() {
  const idx = LEVELS.indexOf(currentLevel);
  if (idx < LEVELS.length - 1) {
    currentLevel = LEVELS[idx+1];
    document.getElementById('club-level-badge').textContent = currentLevel;
    openNextLesson();
  }
}

// ─────────────────────────────────────────────
// PROGRESS
// ─────────────────────────────────────────────
async function submitProgress(contentType, contentId) {
  const btn = document.getElementById('complete-lesson-btn');
  if (btn) { btn.disabled = true; btn.textContent = 'Сохранение...'; }
  try {
    const res = await fetch('/api/progress/complete', {
      method: 'POST', headers: {'Content-Type':'application/json'},
      body: JSON.stringify({ user_id: parseInt(userId), content_type: contentType, content_id: parseInt(contentId) })
    });
    if (!res.ok) { showToast('Ошибка сервера'); if(btn){btn.disabled=false;btn.textContent='✅ Просмотрено · +5 XP';} return; }
    const data = await res.json();
    if (data.xp_earned > 0) showToast(`🎉 +${data.xp_earned} XP!`);
    else showToast('Уже изучено ранее', 'neutral');
    await loadProfile();
    openNextLesson();
  } catch(e) {
    showToast('Ошибка соединения','neutral');
    if(btn){btn.disabled=false;btn.textContent='✅ Просмотрено · +5 XP';}
  }
}

// ─────────────────────────────────────────────
// PRACTICE
// ─────────────────────────────────────────────
async function loadPracticeTask() {
  showScreen('screen-practice-task', 'screen-levels');
  document.getElementById('practice-feedback').classList.add('hidden');
  document.getElementById('practice-question-text').textContent = 'Загрузка...';
  document.getElementById('practice-options').innerHTML = '';
  try {
    const res = await fetch(`/api/random_question?user_id=${userId}&type=multiple_choice&level=${currentLevel}`);
    const q = await res.json();
    if (q.error === 'no_more_questions') {
      document.getElementById('practice-question-text').textContent = '🎉 Все вопросы уровня пройдены!';
      return;
    }
    currentPracticeQuestionId = q.question_id;
    correctPracticeOption = q.correct_option;
    document.getElementById('practice-question-text').textContent = q.question;
    document.getElementById('practice-options').innerHTML = q.options.map((opt, i) => `
      <button onclick="checkPracticeAnswer(${i+1}, this)"
        class="w-full text-left px-lg py-md bg-surface-container-lowest border-2 border-surface-variant rounded-xl font-body text-on-surface text-sm chip-shadow active:scale-[0.98] transition-all">
        <span class="font-label text-outline mr-sm">${String.fromCharCode(65+i)}.</span> ${opt}
      </button>`).join('');
  } catch(e) {
    document.getElementById('practice-question-text').textContent = 'Ошибка загрузки вопроса.';
  }
}

async function checkPracticeAnswer(selected, btnElement) {
  document.querySelectorAll('#practice-options button').forEach(b => b.disabled = true);
  const feedback = document.getElementById('practice-feedback');
  feedback.classList.remove('hidden');
  if (selected === correctPracticeOption) {
    btnElement.classList.add('border-[#007f36]','bg-[#f0fdf4]','text-[#006329]');
    feedback.className = 'rounded-xl p-md text-center font-label font-bold text-sm bg-[#f0fdf4] text-[#006329] border border-[#86efac]';
    feedback.textContent = '✅ Правильно!';
    try {
      await fetch('/api/progress/complete',{method:'POST',headers:{'Content-Type':'application/json'},
        body:JSON.stringify({user_id:parseInt(userId),content_type:'practice',content_id:currentPracticeQuestionId})});
      await loadProfile();
    } catch(e){}
  } else {
    btnElement.classList.add('border-[#ba1a1a]','bg-[#fff1f2]','text-[#ba1a1a]');
    feedback.className = 'rounded-xl p-md text-center font-label font-bold text-sm bg-[#fff1f2] text-[#ba1a1a] border border-[#fca5a5]';
    feedback.textContent = '❌ Неверно';
    try { await fetch('/api/check_answer',{method:'POST',headers:{'Content-Type':'application/json'},
      body:JSON.stringify({user_id:userId,queue_item_id:currentPracticeQuestionId,is_correct:false})}); } catch(e){}
  }
  setTimeout(loadPracticeTask, 2200);
}

// ─────────────────────────────────────────────
// CLICKABLE WORDS
// ─────────────────────────────────────────────
function makeTextClickable(text, fullSentence) {
  const ctxId = 'ctx_' + Math.random().toString(36).slice(2, 8);
  window._clickCtx = window._clickCtx || {};
  window._clickCtx[ctxId] = fullSentence;
  const lines = text.split('\n');
  return `<span data-ctx-id="${ctxId}">` + lines.map(line =>
    line.replace(/([A-Za-zÀ-ÿ]{2,})/g, (word) => {
      const safe = word.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
      return `<span class="clickable-word" data-word="${safe}">${safe}</span>`;
    })
  ).join('<br>') + '</span>';
}

document.addEventListener('click', function(e) {
  const span = e.target.closest('.clickable-word');
  if (!span) return;
  const word = span.dataset.word;
  const ctxSpan = span.closest('[data-ctx-id]');
  const ctxId = ctxSpan?.dataset.ctxId;
  const context = (ctxId && window._clickCtx?.[ctxId]) || '';
  handleWordTap(word, context);
});

async function handleWordTap(word, context) {
  popupWord = word; popupContext = context;
  document.getElementById('popup-word').textContent = word;
  document.getElementById('popup-transcription').textContent = '';
  document.getElementById('popup-translation').textContent = '⏳ Перевод...';
  document.getElementById('popup-example').textContent = '';
  document.getElementById('popup-status').textContent = '';
  const btn = document.getElementById('popup-add-btn');
  btn.disabled = false;
  btn.textContent = '+ В мой словарь';
  btn.className = 'w-full h-touch rounded-xl bg-secondary-container text-on-secondary font-label font-bold text-sm uppercase tracking-wider active:scale-[0.98] transition-transform';
  showWordPopup();
  try {
    const res = await fetch('/api/dictionary/translate', {
      method:'POST', headers:{'Content-Type':'application/json'},
      body: JSON.stringify({user_id:parseInt(userId), word, context_sentence: context.substring(0,300), native_language: userNativeLang, target_language: userTargetLang})
    });
    const data = await res.json();
    if (data.status === 'success') {
      document.getElementById('popup-transcription').textContent = data.transcription ? `${data.transcription}` : '';
      document.getElementById('popup-translation').textContent = data.translation || '—';
      document.getElementById('popup-example').textContent = data.context_example ? `"${data.context_example}"` : '';
    } else {
      document.getElementById('popup-translation').textContent = data.message || 'Перевод недоступен';
    }
  } catch(e) {
    document.getElementById('popup-translation').textContent = 'Ошибка соединения';
  }
}

async function addPopupWordToDict() {
  if (!popupWord) return;
  const btn = document.getElementById('popup-add-btn');
  btn.disabled = true; btn.textContent = 'Сохранение...';
  try {
    const res = await fetch('/api/dictionary/quick_add',{method:'POST',headers:{'Content-Type':'application/json'},
      body:JSON.stringify({user_id:parseInt(userId),word:popupWord,context_sentence:popupContext.substring(0,300)})});
    const data = await res.json();
    if (data.status === 'success') {
      document.getElementById('popup-status').textContent = '✅ Добавлено!';
      btn.textContent = '✓ В словаре';
      btn.className = 'w-full h-touch rounded-xl bg-tertiary-container text-on-tertiary font-label font-bold text-sm uppercase tracking-wider active:scale-[0.98] transition-transform';
    } else {
      document.getElementById('popup-status').textContent = data.message || 'Ошибка';
      btn.disabled = false; btn.textContent = '+ В мой словарь';
    }
  } catch(e) {
    document.getElementById('popup-status').textContent = 'Ошибка соединения';
    btn.disabled = false; btn.textContent = '+ В мой словарь';
  }
}

function showWordPopup() {
  document.getElementById('word-popup-overlay').classList.remove('hidden');
  document.getElementById('word-popup').classList.remove('sheet-hidden');
}
function hideWordPopup() {
  document.getElementById('word-popup-overlay').classList.add('hidden');
  document.getElementById('word-popup').classList.add('sheet-hidden');
}

// ─────────────────────────────────────────────
// SITUATIONS
// ─────────────────────────────────────────────
const SITUATION_HINTS = {
  shop:'🛒 Вы покупатель. Попросите найти товар, узнайте цену.',
  restaurant:'🍽️ Вы гость. Закажите блюдо, попросите счёт.',
  airport:'✈️ Вы пассажир. Пройдите регистрацию на рейс.',
  hotel:'🏨 Вы гость. Заселитесь и запросите услуги.',
  doctor:'🏥 Вы пациент. Опишите симптомы врачу.',
  emergency:'🚨 Срочно опишите ситуацию диспетчеру.',
};
let currentSituation = '';
let sitMediaRecorder = null, sitAudioChunks = [], sitStreamRef = null;

function initClubGreeting() {
  const chatBox = document.getElementById('chat-box');
  if (!chatBox) return;
  chatBox.innerHTML = '';
  const greeting = AI_GREETINGS[userTargetLang] || AI_GREETINGS['en'];
  const div = document.createElement('div');
  div.className = 'bg-primary-container text-on-primary p-md rounded-2xl rounded-tl-none max-w-[85%] text-sm shadow-sm';
  div.innerHTML = makeTextClickable(greeting, greeting);
  setTimeout(() => div.querySelectorAll('.clickable-word').forEach(el => el.style.borderBottomColor='rgba(255,255,255,0.4)'), 0);
  chatBox.appendChild(div);
}

function openSituation(situationKey, title, situation) {
  currentSituation = situation;
  showScreen('screen-situation-chat', 'screen-situations');
  document.getElementById('header-title').textContent = title;

  const t = UI_TRANSLATIONS[userNativeLang] || UI_TRANSLATIONS['ru'];
  const HINTS_I18N = {
    ru: { shop:'🛒 Вы покупатель. Попросите найти товар, узнайте цену.', restaurant:'🍽️ Вы гость. Закажите блюдо, попросите счёт.', airport:'✈️ Вы пассажир. Пройдите регистрацию на рейс.', hotel:'🏨 Вы гость. Заселитесь и запросите услуги.', doctor:'🏥 Вы пациент. Опишите симптомы врачу.', emergency:'🚨 Срочно опишите ситуацию диспетчеру.' },
    en: { shop:'🛒 You are a customer. Ask for a product, check the price.', restaurant:'🍽️ You are a guest. Order a dish, ask for the bill.', airport:'✈️ You are a passenger. Check in for your flight.', hotel:'🏨 You are a guest. Check in and request services.', doctor:'🏥 You are a patient. Describe your symptoms.', emergency:'🚨 Urgently describe the situation to the dispatcher.' },
    de: { shop:'🛒 Sie sind ein Kunde. Fragen Sie nach einem Produkt.', restaurant:'🍽️ Sie sind ein Gast. Bestellen Sie ein Gericht.', airport:'✈️ Sie sind ein Passagier. Checken Sie ein.', hotel:'🏨 Sie sind ein Gast. Melden Sie sich an.', doctor:'🏥 Sie sind ein Patient. Beschreiben Sie Ihre Symptome.', emergency:'🚨 Beschreiben Sie die Situation dem Disponenten.' },
    fr: { shop:'🛒 Vous êtes un client. Demandez un produit.', restaurant:'🍽️ Vous êtes un invité. Commandez un plat.', airport:'✈️ Vous êtes passager. Enregistrez-vous.', hotel:'🏨 Vous êtes un client. Enregistrez-vous.', doctor:'🏥 Vous êtes patient. Décrivez vos symptômes.', emergency:'🚨 Décrivez la situation au répartiteur.' },
    es: { shop:'🛒 Eres un cliente. Pide un producto.', restaurant:'🍽️ Eres un comensal. Pide un plato.', airport:'✈️ Eres pasajero. Factura tu equipaje.', hotel:'🏨 Eres huésped. Regístrate.', doctor:'🏥 Eres paciente. Describe tus síntomas.', emergency:'🚨 Describe la situación al despachador.' },
  };
  const hints = HINTS_I18N[userNativeLang] || HINTS_I18N['ru'];
  document.getElementById('situation-hint-bar').textContent = hints[situation] || '';

  const box = document.getElementById('situation-chat-box');
  box.innerHTML = '';
  // Приветствие на языке изучения
  const greetings = SITUATION_GREETINGS[situation] || {};
  const greeting = greetings[userTargetLang] || greetings['en'] || 'Hello! How can I help you today?';
  appendSituationMessage('ai', greeting);
}

function appendSituationMessage(who, text) {
  const box = document.getElementById('situation-chat-box');
  const div = document.createElement('div');
  if (who === 'ai') {
    div.className = 'bg-primary-container text-on-primary p-md rounded-2xl rounded-tl-none max-w-[85%] text-sm shadow-sm';
    div.innerHTML = makeTextClickable(text, text);
    setTimeout(() => div.querySelectorAll('.clickable-word').forEach(el => el.style.borderBottomColor='rgba(255,255,255,0.4)'), 0);
  } else {
    div.className = 'bg-surface-container text-on-surface p-md rounded-2xl rounded-tr-none max-w-[85%] text-sm shadow-sm ml-auto';
    div.textContent = text;
  }
  box.appendChild(div);
  box.scrollTop = box.scrollHeight;
}

async function sendSituationMessage() {
  const input = document.getElementById('situation-input');
  const text = input.value.trim(); if (!text) return;
  input.value = ''; appendSituationMessage('user', text);
  try {
    const fd = new FormData();
    fd.append('user_id', userId); fd.append('text', text);
    fd.append('level', currentLevel); fd.append('situation', currentSituation);
    fd.append('native_language', userNativeLang); fd.append('target_language', userTargetLang);
    const res = await fetch('/api/web-club/text',{method:'POST',body:fd});
    const data = await res.json();
    appendSituationMessage('ai', data.ai_text);
    if (data.audio_url) new Audio(data.audio_url).play().catch(()=>{});
  } catch(e) { appendSituationMessage('ai','Sorry, connection error.'); }
}

async function startSituationRecording(e) {
  if(e)e.preventDefault(); sitAudioChunks=[];
  const btn = document.getElementById('sit-mic-btn');
  btn.querySelector('.material-symbols-outlined').style.color='#ef4444';
  try {
    const stream = await navigator.mediaDevices.getUserMedia({audio:true});
    sitStreamRef = stream;
    let opts = {}; if(MediaRecorder.isTypeSupported('audio/webm;codecs=opus'))opts={mimeType:'audio/webm;codecs=opus'};
    sitMediaRecorder = new MediaRecorder(stream, opts);
    sitMediaRecorder.ondataavailable = e => { if(e.data?.size>0)sitAudioChunks.push(e.data); };
    sitMediaRecorder.onstop = async () => {
      const blob = new Blob(sitAudioChunks,{type:sitMediaRecorder.mimeType});
      appendSituationMessage('user','🎙️ Voice...');
      const fd = new FormData();
      fd.append('user_id',userId); fd.append('file',blob,'voice');
      fd.append('level',currentLevel); fd.append('situation',currentSituation);
      fd.append('native_language',userNativeLang); fd.append('target_language',userTargetLang);
      try {
        const res = await fetch('/api/web-club/voice',{method:'POST',body:fd});
        const data = await res.json();
        const box = document.getElementById('situation-chat-box');
        if(box.lastChild)box.removeChild(box.lastChild);
        appendSituationMessage('user', data.user_text||'🎤');
        appendSituationMessage('ai', data.ai_text);
        if(data.audio_url)new Audio(data.audio_url).play().catch(()=>{});
      } catch(err){ appendSituationMessage('ai','Could not process voice.'); }
    };
    sitMediaRecorder.start();
  } catch(err){
    btn.querySelector('.material-symbols-outlined').style.color='';
    alert('Ошибка микрофона');
  }
}
function stopSituationRecording(e) {
  if(e)e.preventDefault();
  const btn = document.getElementById('sit-mic-btn');
  btn.querySelector('.material-symbols-outlined').style.color='';
  if(sitMediaRecorder?.state!=='inactive')sitMediaRecorder.stop();
  sitStreamRef?.getTracks().forEach(t=>t.stop()); sitStreamRef=null;
}

// ─────────────────────────────────────────────
// SPEAKING CLUB
// ─────────────────────────────────────────────
function appendMessage(sender, text, isAi=false) {
  const chatBox = document.getElementById('chat-box');
  const div = document.createElement('div');
  if (isAi) {
    div.className = 'bg-primary-container text-on-primary p-md rounded-2xl rounded-tl-none max-w-[85%] text-sm shadow-sm';
    div.innerHTML = makeTextClickable(text, text);
    setTimeout(()=>div.querySelectorAll('.clickable-word').forEach(el=>el.style.borderBottomColor='rgba(255,255,255,0.4)'),0);
  } else {
    div.className = 'bg-surface-container text-on-surface p-md rounded-2xl rounded-tr-none max-w-[85%] text-sm shadow-sm ml-auto';
    div.textContent = text;
  }
  chatBox.appendChild(div);
  chatBox.scrollTop = chatBox.scrollHeight;
}

async function sendTextMessage() {
  const input = document.getElementById('chat-input');
  const text = input.value.trim(); if(!text)return;
  input.value=''; appendMessage('You',text,false);
  try {
    const fd = new FormData();
    fd.append('user_id',userId); fd.append('text',text); fd.append('level',currentLevel);
    fd.append('native_language',userNativeLang); fd.append('target_language',userTargetLang);
    const res = await fetch('/api/web-club/text',{method:'POST',body:fd});
    const data = await res.json();
    appendMessage('AI',data.ai_text,true);
    if(data.audio_url)new Audio(data.audio_url).play().catch(()=>{});
  } catch(e){ appendMessage('AI','Sorry, error connecting.',true); }
}

async function startRecording(e) {
  if(e)e.preventDefault(); audioChunks=[];
  const micBtn=document.getElementById('mic-btn');
  micBtn.querySelector('.material-symbols-outlined').style.color='#ef4444';
  try {
    const stream = await navigator.mediaDevices.getUserMedia({audio:true});
    streamRef=stream;
    let options={}; if(MediaRecorder.isTypeSupported('audio/webm;codecs=opus'))options={mimeType:'audio/webm;codecs=opus'};
    mediaRecorder = new MediaRecorder(stream,options);
    mediaRecorder.ondataavailable = event => { if(event.data&&event.data.size>0)audioChunks.push(event.data); };
    mediaRecorder.onstop = async () => {
      const audioBlob = new Blob(audioChunks,{type:mediaRecorder.mimeType});
      appendMessage('You','<i>🎙️ Sending voice...</i>',false);
      const fd=new FormData();
      fd.append('user_id',userId); fd.append('file',audioBlob,'voice_msg'); fd.append('level',currentLevel);
      fd.append('native_language',userNativeLang); fd.append('target_language',userTargetLang);
      try {
        const res=await fetch('/api/web-club/voice',{method:'POST',body:fd});
        const data=await res.json();
        const chatBox=document.getElementById('chat-box');
        if(chatBox.lastChild)chatBox.removeChild(chatBox.lastChild);
        appendMessage('You',data.user_text||'🎤',false);
        appendMessage('AI',data.ai_text,true);
        if(data.audio_url)new Audio(data.audio_url).play().catch(()=>{});
      } catch(err){ appendMessage('AI','Could not process voice.',true); }
    };
    mediaRecorder.start();
  } catch(err){
    micBtn.querySelector('.material-symbols-outlined').style.color='';
    alert('Ошибка микрофона. Нужен HTTPS и разрешения.');
  }
}
function stopRecording(e) {
  if(e)e.preventDefault();
  document.getElementById('mic-btn').querySelector('.material-symbols-outlined').style.color='';
  if(mediaRecorder&&mediaRecorder.state!=='inactive')mediaRecorder.stop();
  if(streamRef){streamRef.getTracks().forEach(t=>t.stop());streamRef=null;}
}

// ─────────────────────────────────────────────
// PROFILE SCREEN
// ─────────────────────────────────────────────
async function openProfile() {
  showScreen('screen-profile','screen-main');
  const container = document.getElementById('profile-content');
  container.innerHTML = '<p class="text-outline text-center py-xl">Загрузка...</p>';
  try {
    const res = await fetch(`/api/profile/${userId}`);
    const p = await res.json();
    const xpPct = xpProgress(p.xp || 0);
    const xpToNext = XP_PER_LEVEL - ((p.xp || 0) % XP_PER_LEVEL);

    // Категорийная статистика
    let catHtml = '';
    try {
      const catRes = await fetch(`/api/stats/categories/${userId}`);
      const cats = await catRes.json();
      const catLabels = {
        lesson:      { icon:'📖', name:'Уроки' },
        grammar:     { icon:'✍️', name:'Грамматика' },
        vocabulary:  { icon:'💬', name:'Лексика (уроки)' },
        practice:    { icon:'🎯', name:'Практика' },
        vocab_cards: { icon:'🃏', name:'Словарь (карточки)' },
        words:       { icon:'📒', name:'Личный блокнот' },
      };
      catHtml = Object.entries(catLabels).map(([key, {icon, name}]) => {
        const s = cats[key] || {completed:0, total:0};
        const pct = s.total > 0 ? Math.min(100, Math.round(s.completed / s.total * 100)) : 0;

        let rightLabel, barColor = 'bg-primary-container';
        if (key === 'words') {
          if (s.total === 0) rightLabel = 'пусто';
          else { rightLabel = 'знаю ' + s.completed + ' из ' + s.total; barColor = 'bg-tertiary-container'; }
        } else {
          if (s.total === 0) rightLabel = 'нет контента';
          else rightLabel = s.completed + ' / ' + s.total;
        }

        return `<div class="mb-md">
          <div class="flex justify-between items-center mb-xs">
            <span class="font-label text-xs text-on-surface-variant flex items-center gap-xs">
              <span>${icon}</span> ${name}
            </span>
            <span class="font-label text-xs ${s.total===0?'text-outline italic':pct===100?'text-tertiary-container font-bold':'text-outline'}">${rightLabel}</span>
          </div>
          <div class="h-1.5 w-full bg-surface-container-high rounded-full overflow-hidden">
            <div class="h-full ${barColor} rounded-full transition-all" style="width:${pct}%"></div>
          </div>
        </div>`;
      }).join('');
    } catch(e) {}

    container.innerHTML = `
      <div class="bg-gradient-to-br from-primary to-primary-container rounded-2xl p-lg text-white text-center mb-lg">
        <div class="w-20 h-20 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-sm">
          <span class="material-symbols-outlined filled text-4xl text-white">school</span>
        </div>
        <div class="font-headline font-extrabold text-2xl">${p.name||'Ученик'}</div>
        <div class="text-white/70 text-sm">${p.username?'@'+p.username:''}</div>
        <div class="flex justify-center gap-sm mt-sm">
          ${p.is_premium?'<span class="px-sm py-xs bg-[#f59e0b] text-white text-xs font-label font-bold rounded-full">⭐ Premium</span>':''}
          ${p.is_admin?'<span class="px-sm py-xs bg-error text-on-error text-xs font-label font-bold rounded-full">⚙ Admin</span>':''}
        </div>
      </div>
      <div class="grid grid-cols-2 gap-sm mb-md">
        <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-md text-center">
          <div class="font-headline font-extrabold text-3xl text-secondary-container">${p.streak}</div>
          <div class="font-label text-xs text-outline mt-xs">🔥 Дней подряд</div>
        </div>
        <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-md text-center">
          <div class="font-headline font-extrabold text-3xl text-[#f59e0b]">${p.xp}</div>
          <div class="font-label text-xs text-outline mt-xs">⭐ Всего XP</div>
        </div>
        <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-md text-center">
          <div class="font-headline font-extrabold text-3xl text-primary-container">${p.lessons_done}</div>
          <div class="font-label text-xs text-outline mt-xs">📖 Уроков</div>
        </div>
        <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-md text-center">
          <div class="font-headline font-extrabold text-3xl text-tertiary-container">${p.tasks_done}</div>
          <div class="font-label text-xs text-outline mt-xs">🎯 Заданий</div>
        </div>
      </div>
      <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-md mb-md">
        <div class="flex justify-between font-label text-xs text-on-surface-variant mb-sm">
          <span class="font-bold">Прогресс XP</span>
          <span>${p.xp} XP · +${xpToNext} до следующего</span>
        </div>
        <div class="h-2 w-full bg-surface-container-high rounded-full overflow-hidden">
          <div class="h-full bg-primary-container rounded-full transition-all" style="width:${xpPct}%"></div>
        </div>
      </div>
      ${catHtml ? `<div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-md">
        <p class="font-label text-xs text-outline uppercase tracking-wider mb-md">Прогресс по разделам</p>
        ${catHtml}
      </div>` : ''}
    `;
  } catch(e) {
    container.innerHTML = '<p class="text-error text-center py-lg">Ошибка загрузки</p>';
  }
}

// ─────────────────────────────────────────────
// PERSONAL DICTIONARY
// ─────────────────────────────────────────────
async function openPersonalDictionary() {
  showScreen('screen-personal-dict','screen-main');
  const listDiv = document.getElementById('personal-dict-list');
  const countSpan = document.getElementById('dict-count');
  listDiv.innerHTML = '<p class="text-outline text-center py-xl">Загрузка...</p>';
  try {
    const res = await fetch(`/api/dictionary/${userId}`);
    const words = await res.json();
    countSpan.textContent = words.length + ' слов';
    if (!words.length) {
      listDiv.innerHTML = `<div class="text-center py-xl bg-surface-container rounded-2xl border border-dashed border-outline-variant">
        <span class="material-symbols-outlined text-outline text-4xl">book_2</span>
        <p class="text-outline text-sm mt-sm">Нажмите на слово в уроке — оно появится здесь</p>
      </div>`; return;
    }
    listDiv.innerHTML = words.map(w => `
      <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-md shadow-sm">
        <div class="flex justify-between items-start">
          <div>
            <div class="font-headline font-bold text-on-surface text-lg">${w.word}</div>
            ${w.transcription?`<div class="font-label text-xs text-outline">${w.transcription}</div>`:''}
            <div class="text-primary font-body font-bold mt-xs">${w.translation}</div>
          </div>
          <button onclick="toggleWordStatus('${w.word.replace(/'/g,"\\'")}','${w.status}')"
            class="flex-shrink-0 px-sm py-xs rounded-full text-xs font-label font-bold transition-all active:scale-90 ${w.status==='known'?'bg-tertiary-container text-on-tertiary':'bg-surface-container text-on-surface-variant'}">
            ${w.status==='known'?'✓ Знаю':'Учу'}
          </button>
        </div>
        ${w.context_example?`<div class="mt-sm font-body text-sm text-on-surface-variant italic border-t border-surface-variant pt-sm">"${w.context_example}"</div>`:''}
      </div>`).join('');
  } catch(e) {
    listDiv.innerHTML = '<p class="text-error text-center py-lg">Ошибка загрузки</p>';
  }
}

// ─────────────────────────────────────────────
// VISUAL DICTIONARY
// ─────────────────────────────────────────────
const TOPIC_ICONS = {
  'Animals':'🐾','Food':'🍽️','Transport':'🚀','Home':'🏠',
  'Nature':'🌿','Emotions':'😊','Sports':'⚽','Technology':'💻',
};
const LEVEL_COLORS = {
  'A1':'from-green-400 to-teal-500','A2':'from-blue-400 to-indigo-500',
  'B1':'from-orange-400 to-amber-500','B2':'from-pink-400 to-rose-500',
  'C1':'from-red-400 to-purple-500','C2':'from-zinc-600 to-gray-800',
};

async function showDictionary() {
  showScreen('screen-dictionary','screen-main');
  await loadVocabTopics(null);
}

async function loadVocabTopics(level) {
  document.querySelectorAll('.vocab-lvl-btn').forEach(btn => {
    const isActive = level===null ? btn.dataset.lvl==='all' : btn.dataset.lvl===level;
    btn.className = `vocab-lvl-btn px-md py-xs rounded-full text-xs font-label font-bold transition-all ${isActive?'bg-primary-container text-on-primary':'bg-surface-container text-on-surface-variant'}`;
  });
  const grid = document.getElementById('vocab-topics-list');
  grid.innerHTML = '<p class="col-span-2 text-outline text-center py-lg">Загрузка...</p>';
  try {
    const url = level ? `/api/vocab/topics?level=${level}` : '/api/vocab/topics';
    const res = await fetch(url);
    const topics = await res.json();
    if (!topics.length) { grid.innerHTML = '<p class="col-span-2 text-outline text-center py-lg">Темы не добавлены</p>'; return; }
    const byTopic = {};
    topics.forEach(t => {
      if (!byTopic[t.topic]) byTopic[t.topic] = {count:0,levels:[]};
      byTopic[t.topic].count += parseInt(t.card_count);
      byTopic[t.topic].levels.push(t.level);
    });
    grid.innerHTML = Object.entries(byTopic).map(([topic, info]) => {
      const icon = TOPIC_ICONS[topic] || '📖';
      const lvl = info.levels[0] || 'A1';
      const g = LEVEL_COLORS[lvl] || LEVEL_COLORS['A1'];
      const badges = [...new Set(info.levels)].sort().map(l=>`<span class="text-[10px] bg-white/25 px-xs py-[2px] rounded-full font-label">${l}</span>`).join('');
      return `<button onclick="openVocabTopic('${topic.replace(/'/g,"\\'")}','${level||''}')"
        class="bg-gradient-to-br ${g} rounded-2xl p-md text-white text-left active:scale-95 transition-transform shadow-sm flex flex-col h-[130px]">
        <span class="text-3xl block mb-xs leading-none">${icon}</span>
        <span class="font-headline font-extrabold text-sm block truncate w-full">${topic}</span>
        <span class="font-label text-xs text-white/70 mt-auto">${info.count} слов</span>
        <div class="flex gap-xs mt-xs flex-wrap">${badges}</div>
      </button>`;
    }).join('');
  } catch(e) { grid.innerHTML = '<p class="col-span-2 text-error text-center py-lg">Ошибка</p>'; }
}

async function openVocabTopic(topic, level) {
  showScreen('screen-vocab-cards', 'screen-dictionary');
  document.getElementById('vf-topic-name').textContent = (TOPIC_ICONS[topic]||'📖') + ' ' + topic;
  document.getElementById('vf-completion').classList.add('hidden');
  document.getElementById('vf-counter').textContent = 'Загрузка...';

  try {
    const url = level
      ? `/api/vocab/cards?topic=${encodeURIComponent(topic)}&level=${level}`
      : `/api/vocab/cards?topic=${encodeURIComponent(topic)}`;
    const res = await fetch(url);
    const cards = await res.json();
    if (!cards.length) {
      document.getElementById('vf-counter').textContent = '0 карточек';
      return;
    }
    startFlashcards(cards);
  } catch(e) {
    document.getElementById('vf-counter').textContent = 'Ошибка загрузки';
  }
}

// ─────────────────────────────────────────────
// ФЛЭШ-КАРТОЧКИ
// ─────────────────────────────────────────────
let vfAllCards   = [];   // все уникальные карточки темы
let vfCurrentIdx = 0;   // текущая позиция в колоде
let vfKnownCards = [];  // оценены «Знаю»
let vfLearningCards = []; // оценены «Учу»
let vfFlipped    = false;
let vfCurrentCard= null;

// Свайп
let vfTouchStartX = 0;
let vfTouchStartY = 0;

function startFlashcards(cards) {
  vfAllCards = shuffleArray([...cards]);
  vfCurrentIdx = 0;
  vfKnownCards = [];
  vfLearningCards = [];
  document.getElementById('vf-swipe-hint').classList.remove('hidden');
  document.getElementById('vf-completion').classList.add('hidden');
  showVfCard(vfAllCards[0]);
  updateVfProgress();
}

function shuffleArray(arr) {
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

function showVfCard(card) {
  vfCurrentCard = card;
  vfFlipped = false;

  // Emoji
  let emoji = '📖';
  try { emoji = String.fromCodePoint(parseInt(card.emoji_code, 16)); } catch(e) {}
  document.getElementById('vf-emoji').textContent = emoji;

  // Градиент фона эмодзи по уровню
  const gradMap = {
    'A1':'linear-gradient(135deg,#4ade80,#2dd4bf)',
    'A2':'linear-gradient(135deg,#60a5fa,#818cf8)',
    'B1':'linear-gradient(135deg,#fb923c,#f59e0b)',
    'B2':'linear-gradient(135deg,#f472b6,#fb7185)',
    'C1':'linear-gradient(135deg,#f87171,#a855f7)',
    'C2':'linear-gradient(135deg,#71717a,#374151)',
  };
  document.getElementById('vf-emoji-bg').style.background = gradMap[card.level] || gradMap['A1'];

  document.getElementById('vf-word').textContent = card.word;
  document.getElementById('vf-level-badge').textContent = card.level;
  document.getElementById('vf-definition').textContent = card.definition || '';
  document.getElementById('vf-translation').textContent = card.translation || '';
  document.getElementById('vf-example').textContent = '';

  // Сбрасываем в лицо
  const inner = document.getElementById('vf-card-inner');
  inner.classList.remove('border-primary-container', 'bg-surface-container-low');
  inner.classList.add('border-surface-variant');
  document.getElementById('vf-back').classList.add('hidden');
  document.getElementById('vf-tap-hint').classList.remove('hidden');
  document.getElementById('vf-action-btns').classList.add('hidden');

  // Анимация появления
  const card_el = document.getElementById('vf-card');
  card_el.classList.remove('card-exit-left','card-exit-right');
  card_el.classList.add('card-enter');
  setTimeout(() => card_el.classList.remove('card-enter'), 320);
}

function flipCard() {
  if (vfFlipped) return;
  vfFlipped = true;

  // Скрываем подсказку свайпа после первой карточки
  document.getElementById('vf-swipe-hint').classList.add('hidden');

  // Показываем перевод
  const inner = document.getElementById('vf-card-inner');
  inner.classList.add('border-primary-container', 'bg-surface-container-low');
  inner.classList.remove('border-surface-variant');
  document.getElementById('vf-back').classList.remove('hidden');
  document.getElementById('vf-tap-hint').classList.add('hidden');
  document.getElementById('vf-action-btns').classList.remove('hidden');

  // Маленький «пульс» карточки
  const card_el = document.getElementById('vf-card');
  card_el.style.transform = 'scale(0.97)';
  setTimeout(() => { card_el.style.transform = ''; }, 120);
}

function rateCard(rating) {
  if (!vfFlipped) { flipCard(); return; }

  if (rating === 'known') {
    vfKnownCards.push(vfCurrentCard);
    // Сохраняем прогресс — карточка изучена
    if (userId > 0 && vfCurrentCard) {
      fetch('/api/progress/complete', {
        method: 'POST',
        headers: {'Content-Type':'application/json'},
        body: JSON.stringify({
          user_id: parseInt(userId),
          content_type: 'vocab_card',
          content_id: vfCurrentCard.id
        })
      }).catch(() => {});
    }
  } else {
    vfLearningCards.push(vfCurrentCard);
    // Незнакомое слово → в личный блокнот для изучения
    if (userId > 0 && vfCurrentCard) {
      fetch('/api/dictionary/quick_add', {
        method: 'POST',
        headers: {'Content-Type':'application/json'},
        body: JSON.stringify({
          user_id: parseInt(userId),
          word: vfCurrentCard.word,
          context_sentence: vfCurrentCard.definition || ''
        })
      }).catch(() => {});
    }
  }

  // Анимация выхода
  const card_el = document.getElementById('vf-card');
  card_el.classList.add(rating === 'known' ? 'card-exit-right' : 'card-exit-left');

  setTimeout(() => {
    vfCurrentIdx++;
    updateVfProgress();
    if (vfCurrentIdx >= vfAllCards.length) {
      showVfCompletion();
    } else {
      showVfCard(vfAllCards[vfCurrentIdx]);
    }
  }, 280);
}

function updateVfProgress() {
  const total = vfAllCards.length;
  const done = vfCurrentIdx;
  const pct = total > 0 ? Math.round(done / total * 100) : 0;
  document.getElementById('vf-progress-bar').style.width = pct + '%';
  document.getElementById('vf-counter').textContent = `${done} / ${total}`;
  document.getElementById('vf-known-count').textContent = vfKnownCards.length + ' знаю';
  document.getElementById('vf-learning-count').textContent = vfLearningCards.length + ' учу';
}

function showVfCompletion() {
  const total = vfAllCards.length;
  document.getElementById('vf-final-known').textContent = vfKnownCards.length;
  document.getElementById('vf-final-learning').textContent = vfLearningCards.length;
  document.getElementById('vf-completion-msg').textContent =
    `Вы прошли ${total} карточек темы «${vfCurrentCard ? document.getElementById('vf-topic-name').textContent : ''}»`;

  const repeatBtn = document.getElementById('vf-repeat-learning-btn');
  repeatBtn.classList.toggle('hidden', vfLearningCards.length === 0);

  document.getElementById('vf-completion').classList.remove('hidden');
  document.getElementById('vf-action-btns').classList.add('hidden');
}

function repeatAll() {
  startFlashcards(vfAllCards);
}

function repeatLearning() {
  if (vfLearningCards.length > 0) {
    startFlashcards(vfLearningCards);
  }
}

async function speakWord() {
  if (!vfCurrentCard) return;
  try {
    const audio = new Audio(`/api/tts/word?word=${encodeURIComponent(vfCurrentCard.word)}`);
    audio.play();
  } catch(e) { console.error(e); }
}

async function addCurrentWordToDict() {
  if (!vfCurrentCard) return;
  try {
    const res = await fetch('/api/dictionary/quick_add', {
      method:'POST', headers:{'Content-Type':'application/json'},
      body: JSON.stringify({
        user_id: parseInt(userId),
        word: vfCurrentCard.word,
        context_sentence: vfCurrentCard.definition || ''
      })
    });
    const data = await res.json();
    showToast(data.status === 'success' ? '✅ Добавлено в блокнот!' : '⚠️ ' + (data.message||'Ошибка'));
  } catch(e) {
    showToast('Ошибка соединения', 'neutral');
  }
}

// Свайп-жесты на карточке
(function() {
  let el, sx, sy;
  function onStart(e) {
    el = e.currentTarget;
    const t = e.touches ? e.touches[0] : e;
    sx = t.clientX; sy = t.clientY;
  }
  function onEnd(e) {
    const t = e.changedTouches ? e.changedTouches[0] : e;
    const dx = t.clientX - sx;
    const dy = t.clientY - sy;
    if (!vfFlipped) return; // свайп только после флипа
    if (Math.abs(dx) > Math.abs(dy) && Math.abs(dx) > 55) {
      rateCard(dx > 0 ? 'known' : 'learning');
    }
  }
  document.addEventListener('DOMContentLoaded', () => {
    const c = document.getElementById('vf-card');
    if (!c) return;
    c.addEventListener('touchstart', onStart, {passive:true});
    c.addEventListener('touchend',   onEnd,   {passive:true});
  });
})();

// ─────────────────────────────────────────────
// ОНБОРДИНГ
// ─────────────────────────────────────────────
let obGoal = 'general';
let obLevel = 'A1';
let obTargetLang = 'en';
let obNativeLang = 'ru';

function selectTargetLang(lang) {
  obTargetLang = lang;
  document.querySelectorAll('.ob-lang-btn').forEach(b => {
    const isMe = b.dataset.lang === lang;
    b.classList.toggle('border-primary-container', isMe);
    b.classList.toggle('bg-surface-container-low', isMe);
    b.classList.toggle('border-surface-variant', !isMe);
  });
  setTimeout(() => {
    document.getElementById('ob-step-0').classList.add('hidden');
    document.getElementById('ob-step-05').classList.remove('hidden');
    // Скрываем родной язык = целевому
    document.querySelectorAll('.ob-native-btn').forEach(b => {
      b.classList.toggle('hidden', b.dataset.lang === lang);
    });
  }, 280);
}

function selectNativeLang(lang) {
  obNativeLang = lang;
  document.querySelectorAll('.ob-native-btn').forEach(b => {
    const isMe = b.dataset.lang === lang;
    b.classList.toggle('border-primary-container', isMe);
    b.classList.toggle('bg-surface-container-low', isMe);
    b.classList.toggle('border-surface-variant', !isMe);
  });
  setTimeout(() => {
    document.getElementById('ob-step-05').classList.add('hidden');
    document.getElementById('ob-step-1').classList.remove('hidden');
  }, 280);
}

function selectGoal(goal) {
  obGoal = goal;
  document.querySelectorAll('.ob-goal').forEach(b => {
    const isMe = b.dataset.goal === goal;
    b.classList.toggle('border-primary-container', isMe);
    b.classList.toggle('bg-surface-container-low', isMe);
    b.classList.toggle('border-surface-variant', !isMe);
  });
  setTimeout(() => {
    document.getElementById('ob-step-1').classList.add('hidden');
    document.getElementById('ob-step-2').classList.remove('hidden');
  }, 300);
}

function selectObLevel(level) {
  obLevel = level;
  document.getElementById('ob-step-2').classList.add('hidden');
  const tFlag = LANG_FLAGS[obTargetLang] || '🌍';
  const tName = LANG_NAMES_RU[obTargetLang] || obTargetLang;
  document.getElementById('ob-ready-msg').textContent =
    `Вы изучаете ${tFlag} ${tName}. Уровень ${level}. Поехали!`;
  document.getElementById('ob-step-3').classList.remove('hidden');
}

async function finishOnboarding() {
  try {
    userNativeLang = obNativeLang;
    userTargetLang = obTargetLang;
    currentLevel   = obLevel;
    await fetch('/api/onboarding/complete', {
      method:'POST', headers:{'Content-Type':'application/json'},
      body: JSON.stringify({
        user_id: parseInt(userId),
        level: obLevel,
        goal: obGoal,
        native_language: obNativeLang,
        target_language: obTargetLang
      })
    });
    updateLangUI();
    await loadProfile();
    showScreen('screen-main');
  } catch(e) {
    showScreen('screen-main');
  }
}

// ─────────────────────────────────────────────
// СЧЁТЧИК «УРОК X ИЗ Y» + ЭКРАН НЕТ УРОКОВ
// ─────────────────────────────────────────────
function renderLesson(lesson) {
  const dataDiv = document.getElementById('lesson-data');
  const iconMap = { grammar:'edit_note', vocabulary:'psychology', lesson:'menu_book' };
  const icon = iconMap[lesson.type] || 'menu_book';
  const rawText = lesson.lesson_text || 'Текст урока пуст.';
  const clickableBody = makeTextClickable(rawText, rawText);

  // Счётчик прогресса
  const p = lesson.progress || {};
  const total = p.total || 0;
  const num = p.next_num || 1;
  const pct = total > 0 ? Math.round(((num - 1) / total) * 100) : 0;
  const counterHtml = total > 0 ? `
    <div class="mb-md">
      <div class="flex justify-between font-label text-xs text-outline mb-xs">
        <span>Урок ${num} из ${total}</span>
        <span>${pct}%</span>
      </div>
      <div class="h-1.5 w-full bg-surface-container-high rounded-full overflow-hidden">
        <div class="h-full bg-primary-container rounded-full transition-all" style="width:${pct}%"></div>
      </div>
    </div>` : '';

  dataDiv.innerHTML = `
    ${counterHtml}
    <div class="flex items-center gap-sm mb-md">
      <span class="material-symbols-outlined filled text-primary-container">${icon}</span>
      <span class="font-label text-xs text-outline uppercase tracking-wider">${lesson.type||'урок'} · ${currentLevel}</span>
    </div>
    <h1 class="font-headline font-extrabold text-on-surface text-2xl mb-lg leading-tight">${lesson.title}</h1>
    <p class="font-label text-xs text-outline mb-sm">💡 Нажмите на слово для перевода</p>
    <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-lg text-on-surface-variant leading-loose text-base font-body lesson-text-body mb-xl">
      ${clickableBody}
    </div>
    <button id="complete-lesson-btn" onclick="submitProgress('${lesson.type||'lesson'}', ${lesson.id})"
      class="w-full h-touch rounded-xl bg-tertiary-container text-on-tertiary font-label font-bold uppercase tracking-wider text-sm active:scale-[0.98] transition-transform shadow-md">
      ✅ Просмотрено · +5 XP
    </button>
  `;
}

async function openNextLesson() {
  showScreen('screen-lesson', 'screen-levels');
  const dataDiv = document.getElementById('lesson-data');
  dataDiv.innerHTML = `<div class="flex items-center gap-sm text-outline py-xl justify-center">
    <span class="material-symbols-outlined animate-spin">progress_activity</span> Загрузка...
  </div>`;
  const typeMap = { lessons:'lesson', grammar:'grammar', vocabulary:'vocabulary' };
  const contentType = typeMap[currentCategory] || 'lesson';
  try {
    const res = await fetch(`/api/lessons/next/${currentLevel}?user_id=${userId}&content_type=${contentType}`);
    const lesson = await res.json();
    if (lesson.completed) {
      // Различаем «уровень пройден» от «уроков нет совсем»
      const prog = lesson.progress || {};
      if (prog.total === 0) {
        showScreen('screen-no-content');
      } else {
        showLevelComplete();
      }
      return;
    }
    renderLesson(lesson);
  } catch(e) {
    dataDiv.innerHTML = `<p class="text-error text-center py-lg">Ошибка загрузки</p>`;
  }
}

// ─────────────────────────────────────────────
// XP ПРОГРЕСС-БАР (реальные пороги)
// ─────────────────────────────────────────────
// 10 уроков × 5 XP = 50 XP на уровень — реалистичный порог
const XP_PER_LEVEL = 50;

function xpProgress(xp) {
  const inLevel = xp % XP_PER_LEVEL;
  return Math.min(100, Math.round((inLevel / XP_PER_LEVEL) * 100));
}

// ─────────────────────────────────────────────
// СТАТУС СЛОВА В БЛОКНОТЕ
// ─────────────────────────────────────────────
async function toggleWordStatus(word, currentStatus) {
  const newStatus = currentStatus === 'known' ? 'learning' : 'known';
  try {
    await fetch('/api/dictionary/status', {
      method: 'POST', headers: {'Content-Type':'application/json'},
      body: JSON.stringify({ user_id: parseInt(userId), word, status: newStatus })
    });
    await openPersonalDictionary(); // перерисовываем список
  } catch(e) {
    showToast('Ошибка обновления', 'neutral');
  }
}

// ─────────────────────────────────────────────
// SENTENCE BUILDER
// ─────────────────────────────────────────────
let sbCorrectSentence = '';
let sbQuestionId = null;
let sbSelectedWords = [];  // порядок слов в зоне сборки

async function loadSentenceBuilder() {
  showScreen('screen-sentence-builder', 'screen-practice-mode');
  document.getElementById('sb-feedback').classList.add('hidden');
  document.getElementById('sb-source-text').textContent = '⏳ Загрузка...';
  document.getElementById('sb-word-bank').innerHTML = '';
  document.getElementById('sb-drop-zone').innerHTML =
    '<div id="sb-empty-hint" class="absolute inset-0 flex items-center justify-center"><p class="font-body text-outline text-sm opacity-60">Нажимайте слова, чтобы составить фразу</p></div>';
  sbSelectedWords = [];
  updateSbButton();

  try {
    const res = await fetch(`/api/random_question?user_id=${userId}&level=${currentLevel}&type=sentence_builder`);
    const q = await res.json();

    if (q.error === 'no_more_questions') {
      document.getElementById('sb-source-text').textContent = '🎉 Все предложения уровня пройдены!';
      document.getElementById('sb-word-bank').innerHTML = `
        <button onclick="showScreen('screen-practice-mode')"
          class="mt-lg px-lg py-md bg-primary-container text-on-primary font-label font-bold rounded-xl active:scale-95 transition-transform">
          ← К выбору режима
        </button>`;
      return;
    }

    sbCorrectSentence = q.correct_sentence;
    sbQuestionId = q.question_id;
    document.getElementById('sb-source-text').textContent = q.question;
    renderSbWordBank(q.word_bank);
  } catch(e) {
    document.getElementById('sb-source-text').textContent = 'Ошибка загрузки задания';
  }
}

function renderSbWordBank(words) {
  const bank = document.getElementById('sb-word-bank');
  bank.innerHTML = words.map((word, i) =>
    `<button
      class="sb-chip px-md py-sm bg-surface-container-lowest border border-surface-variant rounded-xl
             font-body text-on-surface text-base chip-shadow active:scale-95 transition-all"
      data-word="${word.replace(/"/g,'&quot;')}"
      data-idx="${i}"
      onclick="sbMoveToZone(this)">
      ${word}
    </button>`
  ).join('');
}

function sbMoveToZone(btn) {
  const word = btn.dataset.word;
  const idx = btn.dataset.idx;

  // Скрываем из банка
  btn.classList.add('opacity-0', 'pointer-events-none');
  setTimeout(() => btn.classList.add('hidden'), 100);

  // Прячем hint
  const hint = document.getElementById('sb-empty-hint');
  if (hint) hint.remove();

  // Создаём чип в зоне
  sbSelectedWords.push({ word, bankIdx: idx });
  const zone = document.getElementById('sb-drop-zone');
  const chip = document.createElement('button');
  chip.className = 'sb-zone-chip px-md py-sm bg-surface-container-lowest border-2 border-primary-container rounded-xl font-body text-primary text-base active:scale-95 transition-all';
  chip.textContent = word;
  chip.dataset.bankIdx = idx;
  chip.onclick = () => sbReturnToBank(chip, idx);
  zone.appendChild(chip);

  updateSbButton();
}

function sbReturnToBank(chip, bankIdx) {
  // Убираем из зоны
  chip.remove();
  sbSelectedWords = sbSelectedWords.filter(w => w.bankIdx !== bankIdx);

  // Возвращаем в банк
  const bankBtn = document.querySelector(`#sb-word-bank button[data-idx="${bankIdx}"]`);
  if (bankBtn) {
    bankBtn.classList.remove('hidden', 'opacity-0', 'pointer-events-none');
  }

  // Возвращаем hint если зона пустая
  const zone = document.getElementById('sb-drop-zone');
  if (sbSelectedWords.length === 0) {
    zone.innerHTML =
      '<div id="sb-empty-hint" class="absolute inset-0 flex items-center justify-center"><p class="font-body text-outline text-sm opacity-60">Нажимайте слова, чтобы составить фразу</p></div>';
  }

  updateSbButton();
}

function updateSbButton() {
  const btn = document.getElementById('sb-check-btn');
  const hasWords = sbSelectedWords.length > 0;
  if (hasWords) {
    btn.disabled = false;
    btn.className = 'w-full h-touch rounded-xl font-label font-bold uppercase tracking-wider text-sm transition-all active:scale-[0.98] bg-primary-container text-on-primary shadow-md';
  } else {
    btn.disabled = true;
    btn.className = 'w-full h-touch rounded-xl font-label font-bold uppercase tracking-wider text-sm transition-all bg-surface-container text-outline cursor-not-allowed';
  }
}

async function checkSentence() {
  const userSentence = sbSelectedWords.map(w => w.word).join(' ');
  const correct = sbCorrectSentence.trim();
  const feedback = document.getElementById('sb-feedback');
  feedback.classList.remove('hidden');

  // Нормализуем для сравнения (без регистра, без лишних пробелов)
  const normalize = s => s.toLowerCase().replace(/[.!?,]/g, '').trim().replace(/\s+/g, ' ');
  const isCorrect = normalize(userSentence) === normalize(correct);

  // Блокируем кнопки в зоне и банке
  document.querySelectorAll('.sb-zone-chip, .sb-chip:not(.hidden)').forEach(b => b.disabled = true);
  document.getElementById('sb-check-btn').disabled = true;

  if (isCorrect) {
    feedback.className = 'mx-md mt-sm px-md py-sm rounded-xl font-label font-bold text-sm text-center bg-[#f0fdf4] text-[#006329] border border-[#86efac]';
    feedback.textContent = '✅ Правильно! Отлично!';
    try {
      await fetch('/api/progress/complete', {
        method: 'POST', headers: {'Content-Type':'application/json'},
        body: JSON.stringify({ user_id: parseInt(userId), content_type: 'practice', content_id: sbQuestionId })
      });
      await loadProfile();
    } catch(e) {}
    setTimeout(loadSentenceBuilder, 2000);
  } else {
    feedback.className = 'mx-md mt-sm px-md py-sm rounded-xl font-label font-bold text-sm text-center bg-[#fff1f2] text-[#ba1a1a] border border-[#fca5a5]';
    feedback.textContent = `❌ Не совсем. Правильно: «${correct}»`;
    setTimeout(loadSentenceBuilder, 3000);
  }
}

// ─────────────────────────────────────────────
// TOAST
// ─────────────────────────────────────────────
function showToast(msg, type='success') {
  const toast = document.createElement('div');
  const bg = type==='success' ? 'bg-tertiary-container text-on-tertiary' : 'bg-on-surface text-surface';
  toast.className = `fixed bottom-24 left-1/2 -translate-x-1/2 ${bg} px-lg py-sm rounded-xl text-sm font-label font-bold shadow-lg z-50 whitespace-nowrap max-w-[90vw]`;
  toast.textContent = msg;
  document.body.appendChild(toast);
  setTimeout(() => toast.remove(), 2800);
}

// ─────────────────────────────────────────────
// I18N — переводы интерфейса
// ─────────────────────────────────────────────
const UI_TRANSLATIONS = {
  ru: {
    sec_study:         'Занятия',
    sec_interactive:   'Интерактив',
    btn_lessons:       'Уроки',       btn_lessons_sub:    'Теория курса',
    btn_grammar:       'Грамматика',  btn_grammar_sub:    'Правила',
    btn_vocab:         'Словарь',     btn_vocab_sub:      'Лексика',
    btn_practice:      'Практика',    btn_practice_sub:   'Тесты',
    btn_situations:    'Ситуации',    btn_situations_sub: 'В магазине, ресторане...',
    btn_club:          'Разговорный клуб', btn_club_sub:  'AI-репетитор',
    btn_notebook:      'Мой блокнот слов', btn_notebook_sub: 'Слова, которые вы сохранили',
    title_choose_level:'Выберите уровень',
    title_level_done:  'Уровень пройден!',
    title_profile:     'Мой профиль',
    btn_complete:      '✅ Просмотрено · +5 XP',
    placeholder_club:  'Напишите сообщение...',
    nav_home:          'Главная', nav_vocab: 'Словарь',
    nav_club:          'Клуб',   nav_profile: 'Профиль',
  },
  en: {
    sec_study:         'Study',
    sec_interactive:   'Interactive',
    btn_lessons:       'Lessons',       btn_lessons_sub:    'Course theory',
    btn_grammar:       'Grammar',       btn_grammar_sub:    'Rules & usage',
    btn_vocab:         'Vocabulary',    btn_vocab_sub:      'Lexicon',
    btn_practice:      'Practice',      btn_practice_sub:   'Quizzes',
    btn_situations:    'Situations',    btn_situations_sub: 'Shop, restaurant...',
    btn_club:          'Speaking Club', btn_club_sub:       'AI tutor',
    btn_notebook:      'My Word Book',  btn_notebook_sub:   'Words you saved',
    title_choose_level:'Choose Level',
    title_level_done:  'Level Complete!',
    title_profile:     'My Profile',
    btn_complete:      '✅ Done · +5 XP',
    placeholder_club:  'Type a message...',
    nav_home:          'Home',  nav_vocab: 'Vocab',
    nav_club:          'Club',  nav_profile: 'Profile',
  },
  de: {
    sec_study:         'Lernen',
    sec_interactive:   'Interaktiv',
    btn_lessons:       'Lektionen',     btn_lessons_sub:    'Kurstheorie',
    btn_grammar:       'Grammatik',     btn_grammar_sub:    'Regeln',
    btn_vocab:         'Wörterbuch',    btn_vocab_sub:      'Lexik',
    btn_practice:      'Übungen',       btn_practice_sub:   'Tests',
    btn_situations:    'Situationen',   btn_situations_sub: 'Im Laden, Restaurant...',
    btn_club:          'Sprechclub',    btn_club_sub:       'KI-Tutor',
    btn_notebook:      'Mein Vokabular',btn_notebook_sub:   'Gespeicherte Wörter',
    title_choose_level:'Niveau wählen',
    title_level_done:  'Niveau geschafft!',
    title_profile:     'Mein Profil',
    btn_complete:      '✅ Erledigt · +5 XP',
    placeholder_club:  'Nachricht eingeben...',
    nav_home:          'Startseite', nav_vocab: 'Wörter',
    nav_club:          'Club',       nav_profile: 'Profil',
  },
  fr: {
    sec_study:         'Cours',
    sec_interactive:   'Interactif',
    btn_lessons:       'Leçons',        btn_lessons_sub:    'Théorie',
    btn_grammar:       'Grammaire',     btn_grammar_sub:    'Règles',
    btn_vocab:         'Vocabulaire',   btn_vocab_sub:      'Lexique',
    btn_practice:      'Pratique',      btn_practice_sub:   'Exercices',
    btn_situations:    'Situations',    btn_situations_sub: 'Magasin, restaurant...',
    btn_club:          'Club de parole',btn_club_sub:       'Tuteur IA',
    btn_notebook:      'Mon carnet',    btn_notebook_sub:   'Mots enregistrés',
    title_choose_level:'Choisir le niveau',
    title_level_done:  'Niveau terminé !',
    title_profile:     'Mon profil',
    btn_complete:      '✅ Vu · +5 XP',
    placeholder_club:  'Écrire un message...',
    nav_home:          'Accueil', nav_vocab: 'Vocab',
    nav_club:          'Club',    nav_profile: 'Profil',
  },
  es: {
    sec_study:         'Clases',
    sec_interactive:   'Interactivo',
    btn_lessons:       'Lecciones',     btn_lessons_sub:    'Teoría del curso',
    btn_grammar:       'Gramática',     btn_grammar_sub:    'Reglas',
    btn_vocab:         'Vocabulario',   btn_vocab_sub:      'Léxico',
    btn_practice:      'Práctica',      btn_practice_sub:   'Ejercicios',
    btn_situations:    'Situaciones',   btn_situations_sub: 'Tienda, restaurante...',
    btn_club:          'Club de habla', btn_club_sub:       'Tutor IA',
    btn_notebook:      'Mi libreta',    btn_notebook_sub:   'Palabras guardadas',
    title_choose_level:'Elige el nivel',
    title_level_done:  '¡Nivel completado!',
    title_profile:     'Mi perfil',
    btn_complete:      '✅ Visto · +5 XP',
    placeholder_club:  'Escribe un mensaje...',
    nav_home:          'Inicio',  nav_vocab: 'Vocab',
    nav_club:          'Club',    nav_profile: 'Perfil',
  },
  it: {
    sec_study:         'Studio',
    sec_interactive:   'Interattivo',
    btn_lessons:       'Lezioni',       btn_lessons_sub:    'Teoria del corso',
    btn_grammar:       'Grammatica',    btn_grammar_sub:    'Regole',
    btn_vocab:         'Vocabolario',   btn_vocab_sub:      'Lessico',
    btn_practice:      'Pratica',       btn_practice_sub:   'Esercizi',
    btn_situations:    'Situazioni',    btn_situations_sub: 'Negozio, ristorante...',
    btn_club:          'Club di parola',btn_club_sub:       'Tutor AI',
    btn_notebook:      'Il mio taccuino', btn_notebook_sub: 'Parole salvate',
    title_choose_level:'Scegli il livello',
    title_level_done:  'Livello completato!',
    title_profile:     'Il mio profilo',
    btn_complete:      '✅ Visto · +5 XP',
    placeholder_club:  'Scrivi un messaggio...',
    nav_home:          'Home',   nav_vocab: 'Vocab',
    nav_club:          'Club',   nav_profile: 'Profilo',
  },
  zh: {
    sec_study:         '学习',
    sec_interactive:   '互动',
    btn_lessons:       '课程',    btn_lessons_sub:    '课程理论',
    btn_grammar:       '语法',    btn_grammar_sub:    '规则',
    btn_vocab:         '词汇',    btn_vocab_sub:      '词汇表',
    btn_practice:      '练习',    btn_practice_sub:   '测验',
    btn_situations:    '情景对话', btn_situations_sub: '商店、餐厅...',
    btn_club:          'AI对话俱乐部', btn_club_sub:   'AI导师',
    btn_notebook:      '我的单词本', btn_notebook_sub: '已保存的单词',
    title_choose_level:'选择级别',
    title_level_done:  '关卡完成！',
    title_profile:     '我的资料',
    btn_complete:      '✅ 已看 · +5 XP',
    placeholder_club:  '输入消息...',
    nav_home:          '首页',  nav_vocab: '词汇',
    nav_club:          '俱乐部', nav_profile: '我的',
  },
};

// Приветствия AI на языке изучения
const AI_GREETINGS = {
  en: "Hello! How can I help you today? Feel free to type or use the microphone!",
  de: "Hallo! Wie kann ich Ihnen heute helfen? Schreiben Sie oder nutzen Sie das Mikrofon!",
  fr: "Bonjour ! Comment puis-je vous aider aujourd'hui ? Écrivez ou utilisez le microphone !",
  es: "¡Hola! ¿En qué puedo ayudarte hoy? ¡Escribe o usa el micrófono!",
  it: "Ciao! Come posso aiutarti oggi? Scrivi o usa il microfono!",
  zh: "你好！今天我能帮你什么？请输入文字或使用麦克风！",
  ja: "こんにちは！今日はどのようにお手伝いできますか？",
  pt: "Olá! Como posso ajudá-lo hoje? Escreva ou use o microfone!",
  ru: "Привет! Чем могу помочь? Пишите или говорите в микрофон!",
};

const SITUATION_GREETINGS = {
  shop:        { en:"Welcome! How can I help you today?", de:"Willkommen! Wie kann ich Ihnen helfen?", fr:"Bienvenue ! Comment puis-je vous aider ?", es:"¡Bienvenido! ¿En qué le puedo ayudar?", it:"Benvenuto! Come posso aiutarla?", zh:"欢迎光临！有什么可以帮您？", ja:"いらっしゃいませ！何かお手伝いできますか？", pt:"Bem-vindo! Como posso ajudá-lo?", ru:"Добро пожаловать! Чем могу помочь?" },
  restaurant:  { en:"Good evening! Do you have a reservation?", de:"Guten Abend! Haben Sie eine Reservierung?", fr:"Bonsoir ! Avez-vous une réservation ?", es:"¡Buenas noches! ¿Tienen reserva?", it:"Buonasera! Avete una prenotazione?", zh:"晚上好！请问有预订吗？", ja:"いらっしゃいませ！ご予約はございますか？", pt:"Boa noite! Tem reserva?", ru:"Добрый вечер! У вас есть бронь?" },
  airport:     { en:"Good morning! May I see your passport and ticket?", de:"Guten Morgen! Darf ich Ihren Pass und Ihr Ticket sehen?", fr:"Bonjour ! Puis-je voir votre passeport et votre billet ?", es:"¡Buenos días! ¿Me puede mostrar su pasaporte y billete?", it:"Buongiorno! Posso vedere il suo passaporto e il biglietto?", zh:"早上好！请出示您的护照和机票。", ja:"おはようございます！パスポートとチケットをお見せください。", pt:"Bom dia! Posso ver o seu passaporte e bilhete?", ru:"Доброе утро! Могу я увидеть ваш паспорт и билет?" },
  hotel:       { en:"Welcome to our hotel! Do you have a reservation?", de:"Willkommen in unserem Hotel! Haben Sie eine Reservierung?", fr:"Bienvenue dans notre hôtel ! Avez-vous une réservation ?", es:"¡Bienvenido a nuestro hotel! ¿Tiene reserva?", it:"Benvenuto nel nostro hotel! Ha una prenotazione?", zh:"欢迎来到我们的酒店！请问有预订吗？", ja:"ご来館ありがとうございます！ご予約はございますか？", pt:"Bem-vindo ao nosso hotel! Tem reserva?", ru:"Добро пожаловать! Есть ли у вас бронь?" },
  doctor:      { en:"Hello! Please take a seat. What brings you in today?", de:"Hallo! Bitte setzen Sie sich. Was führt Sie heute zu mir?", fr:"Bonjour ! Asseyez-vous. Qu'est-ce qui vous amène aujourd'hui ?", es:"¡Hola! Siéntese. ¿Qué le trae hoy?", it:"Salve! Si accomodi. Cosa la porta da me oggi?", zh:"你好！请坐。今天有什么不舒服吗？", ja:"こんにちは！どうぞお座りください。今日はどうされましたか？", pt:"Olá! Por favor sente-se. O que o traz hoje?", ru:"Здравствуйте! Присаживайтесь. Что вас беспокоит?" },
  emergency:   { en:"Emergency services, what is your emergency?", de:"Notruf, was ist Ihr Notfall?", fr:"Services d'urgence, quelle est votre urgence ?", es:"Servicios de emergencia, ¿cuál es su emergencia?", it:"Pronto intervento, qual è la sua emergenza?", zh:"紧急服务，请说明您的紧急情况！", ja:"緊急サービスです。緊急事態を教えてください。", pt:"Serviços de emergência, qual é a sua emergência?", ru:"Служба спасения, что случилось?" },
};

function applyTranslations() {
  const t = UI_TRANSLATIONS[userNativeLang] || UI_TRANSLATIONS['ru'];
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.dataset.i18n;
    if (t[key]) el.textContent = t[key];
  });
  document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
    const key = el.dataset.i18nPlaceholder;
    if (t[key]) el.placeholder = t[key];
  });
}

// ─────────────────────────────────────────────
// ЯЗЫКИ — вспомогательные функции
// ─────────────────────────────────────────────
function updateLangUI() {
  const tFlag = LANG_FLAGS[userTargetLang] || '🌍';
  const profileFlag = document.getElementById('profile-lang-flag');
  if (profileFlag) profileFlag.textContent = tFlag;
  const clubBadge = document.getElementById('club-level-badge');
  if (clubBadge) clubBadge.textContent = currentLevel;

  // Применяем переводы UI
  applyTranslations();

  // Обновляем приветствие в разговорном клубе
  const chatBox = document.getElementById('chat-box');
  if (chatBox && chatBox.children.length === 0) {
    initClubGreeting();
  }
}

// ─────────────────────────────────────────────
// НАСТРОЙКИ ЯЗЫКА
// ─────────────────────────────────────────────
let lsTargetLang = '';
let lsNativeLang = '';

function showLangSettings() {
  lsTargetLang = userTargetLang;
  lsNativeLang = userNativeLang;
  showScreen('screen-lang-settings', 'screen-profile');
  document.getElementById('ls-status').textContent = '';

  // Подсвечиваем текущие языки
  document.querySelectorAll('.ls-target-btn').forEach(b => {
    const active = b.dataset.lang === lsTargetLang;
    b.classList.toggle('border-primary-container', active);
    b.classList.toggle('bg-surface-container-low', active);
    b.classList.toggle('border-surface-variant', !active);
  });
  document.querySelectorAll('.ls-native-btn').forEach(b => {
    const active = b.dataset.lang === lsNativeLang;
    b.classList.toggle('border-primary-container', active);
    b.classList.toggle('bg-surface-container-low', active);
    b.classList.toggle('border-surface-variant', !active);
  });
}

function setLang(type, lang) {
  if (type === 'target') {
    lsTargetLang = lang;
    document.querySelectorAll('.ls-target-btn').forEach(b => {
      const active = b.dataset.lang === lang;
      b.classList.toggle('border-primary-container', active);
      b.classList.toggle('bg-surface-container-low', active);
      b.classList.toggle('border-surface-variant', !active);
    });
    // Скрываем родной = целевому
    document.querySelectorAll('.ls-native-btn').forEach(b => {
      b.classList.toggle('opacity-30 pointer-events-none', b.dataset.lang === lang);
    });
  } else {
    lsNativeLang = lang;
    document.querySelectorAll('.ls-native-btn').forEach(b => {
      const active = b.dataset.lang === lang;
      b.classList.toggle('border-primary-container', active);
      b.classList.toggle('bg-surface-container-low', active);
      b.classList.toggle('border-surface-variant', !active);
    });
  }
}

async function saveLangSettings() {
  if (!lsTargetLang || !lsNativeLang) {
    document.getElementById('ls-status').textContent = 'Выберите оба языка';
    return;
  }
  if (lsTargetLang === lsNativeLang) {
    document.getElementById('ls-status').textContent = '⚠️ Язык изучения и родной не могут совпадать';
    return;
  }
  const btn = document.getElementById('ls-save-btn');
  btn.disabled = true; btn.textContent = 'Сохранение...';
  try {
    await fetch('/api/user/languages', {
      method: 'POST', headers: {'Content-Type':'application/json'},
      body: JSON.stringify({ user_id: parseInt(userId), native_language: lsNativeLang, target_language: lsTargetLang })
    });
    userNativeLang = lsNativeLang;
    userTargetLang = lsTargetLang;
    applyTranslations();
    updateLangUI();
    initClubGreeting();
    document.getElementById('ls-status').textContent = '✅ Сохранено!';
    btn.textContent = 'Сохранить';
    btn.disabled = false;
    setTimeout(() => showScreen('screen-profile'), 1200);
  } catch(e) {
    document.getElementById('ls-status').textContent = 'Ошибка сохранения';
    btn.disabled = false; btn.textContent = 'Сохранить';
  }
}

// ─────────────────────────────────────────────
// INIT
// ─────────────────────────────────────────────
window.onload = async () => {
  await loadProfile();

  // Загружаем языки пользователя из БД
  if (userId > 0) {
    try {
      const res = await fetch(`/api/user/languages/${userId}`);
      const langs = await res.json();
      userNativeLang = langs.native || 'ru';
      userTargetLang = langs.target || 'en';
    } catch(e) {}
  }

  // Применяем переводы и инициализируем UI
  applyTranslations();
  updateLangUI();
  initClubGreeting();

  // Проверяем онбординг
  try {
    const res = await fetch(`/api/onboarding/${userId}`);
    const data = await res.json();
    if (!data.onboarding_done && userId > 0) {
      showScreen('screen-onboarding');
      return;
    }
  } catch(e) {}
  showScreen('screen-main');
};
