// ── Состояние ──
let userId = 0, userEmail = '', isAdmin = false;
let _clubRecording = false;
let userNativeLang = 'ru', userTargetLang = 'en';
let currentLevel = 'A1', currentCategory = 'lessons';
let popupWord = '', popupContext = '';
let obTarget = 'en', obNative = 'ru', obLevel = 'A1';
let currentSituation = '';
let clubMediaRecorder = null, clubAudioChunks = [], clubStreamRef = null;
let sitMediaRecorder = null, sitAudioChunks = [], sitStreamRef = null;
let vfCards = [], vfIdx = 0, vfKnown = [], vfLearning = [], vfFlipped = false, vfCard = null;
let sbCorrect = '', sbQId = null, sbSelected = [];
let currentPracticeQId = null, correctPracticeOption = null;

const XP_PER_LEVEL = 50;
const LEVELS = ['A1','A2','B1','B2','C1','C2'];
const LEVEL_META = {
  A1: { gradient:'linear-gradient(135deg,#34d399,#0891b2)', bg:'#ecfdf5', color:'#065f46', label:'Начинающий',    desc:'Базовые фразы и простые диалоги',       emoji:'🌱' },
  A2: { gradient:'linear-gradient(135deg,#60a5fa,#6366f1)', bg:'#eff6ff', color:'#1e3a8a', label:'Элементарный',  desc:'Повседневные ситуации и простой текст',  emoji:'📘' },
  B1: { gradient:'linear-gradient(135deg,#fb923c,#f59e0b)', bg:'#fff7ed', color:'#92400e', label:'Средний',       desc:'Основные темы и несложные тексты',       emoji:'⚡' },
  B2: { gradient:'linear-gradient(135deg,#f472b6,#ec4899)', bg:'#fdf2f8', color:'#831843', label:'Выше среднего', desc:'Сложные темы и беглая речь',             emoji:'🔥' },
  C1: { gradient:'linear-gradient(135deg,#a78bfa,#7c3aed)', bg:'#f5f3ff', color:'#4c1d95', label:'Продвинутый',   desc:'Академический язык и нюансы',            emoji:'💎' },
  C2: { gradient:'linear-gradient(135deg,#4b5563,#1f2937)', bg:'#f9fafb', color:'#111827', label:'Мастерство',    desc:'Свободное владение на уровне носителя',  emoji:'🏆' },
};
const TOPIC_ICONS = {
  'Animals':'🐾','Food':'🍽️','Transport':'🚀','Home':'🏠','Nature':'🌿',
  'Emotions':'😊','Sports':'⚽','Technology':'💻',
  'Drinks':'🥤','Colors':'🎨','Family':'👨‍👩‍👧‍👦','Body':'🫀',
  'Clothes':'👗','Weather':'🌤️','Time':'⏰','School':'🏫',
  'Places':'🗺️','Greetings':'👋','Actions':'🏃','Adjectives':'✨',
  'Numbers':'🔢','Work':'💼','Health':'🏥','Travel':'✈️',
  'Shopping':'🛒','Hobby':'🎨','Music':'🎵','Art':'🖼️',
};
const AI_GREETINGS = {en:"Hello! How can I help you today? Feel free to type or use the microphone!",de:"Hallo! Wie kann ich Ihnen heute helfen?",fr:"Bonjour ! Comment puis-je vous aider ?",es:"¡Hola! ¿En qué puedo ayudarte?",it:"Ciao! Come posso aiutarti?",zh:"你好！今天我能帮你什么？",ru:"Привет! Чем могу помочь?"};
const SIT_GREETINGS = {shop:{en:"Welcome! How can I help you today?",ru:"Добро пожаловать! Чем могу помочь?"},restaurant:{en:"Good evening! Do you have a reservation?",ru:"Добрый вечер! У вас есть бронь?"},airport:{en:"Good morning! May I see your passport?",ru:"Доброе утро! Ваш паспорт, пожалуйста."},hotel:{en:"Welcome to our hotel! Do you have a reservation?",ru:"Добро пожаловать! Есть бронь?"},doctor:{en:"Hello! What brings you in today?",ru:"Здравствуйте! Что вас беспокоит?"},emergency:{en:"Emergency services, what is your emergency?",ru:"Служба спасения, что случилось?"}};
const SIT_HINTS = {shop:'🛒 Вы покупатель. Попросите найти товар.',restaurant:'🍽️ Вы гость. Закажите блюдо.',airport:'✈️ Вы пассажир. Пройдите регистрацию.',hotel:'🏨 Вы гость. Заселитесь.',doctor:'🏥 Вы пациент. Опишите симптомы.',emergency:'🚨 Срочно опишите ситуацию.'};

// ── AUTH ──
let _regEmail = '';

function switchAuthTab(tab) {
  ['login','register'].forEach(t => {
    const btn = document.getElementById('tab-'+t);
    const panel = document.getElementById('auth-'+t);
    const active = t === tab;
    btn.style.background  = active ? '#fff' : 'transparent';
    btn.style.color       = active ? '#1a1a2e' : '#6b7280';
    btn.style.boxShadow   = active ? '0 1px 3px rgba(0,0,0,0.12)' : 'none';
    panel.style.display   = active ? 'block' : 'none';
  });
}

function _showErr(id, msg) {
  const el = document.getElementById(id);
  if (!el) return;
  el.textContent = msg;
  el.style.display = msg ? 'block' : 'none';
}

async function loginWithEmail() {
  _showErr('login-error','');
  const email    = document.getElementById('login-email').value.trim();
  const password = document.getElementById('login-password').value;
  if (!email || !password) { _showErr('login-error','Заполните все поля'); return; }
  try {
    const res  = await fetch('/api/auth/login', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email,password})});
    const data = await res.json();
    if (!res.ok) { _showErr('login-error', data.detail||'Неверный email или пароль'); return; }
    userId = data.user_id; userEmail = email;
    localStorage.setItem('t2l_user_id', userId);
    localStorage.setItem('t2l_email', email);
    await initApp();
  } catch(e) { _showErr('login-error','Ошибка соединения'); }
}

async function registerWithEmail() {
  _showErr('reg-error','');
  const name     = document.getElementById('reg-name').value.trim();
  const email    = document.getElementById('reg-email').value.trim();
  const password = document.getElementById('reg-password').value;
  if (!email || !password) { _showErr('reg-error','Email и пароль обязательны'); return; }
  if (password.length < 6) { _showErr('reg-error','Пароль минимум 6 символов'); return; }
  try {
    const res  = await fetch('/api/auth/register', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email,password,name})});
    const data = await res.json();
    if (!res.ok) { _showErr('reg-error', data.detail||'Ошибка регистрации'); return; }
    _regEmail = email;
    userId    = data.user_id;
    document.getElementById('reg-email-display').textContent = email;
    document.getElementById('reg-step1').style.display = 'none';
    document.getElementById('reg-step2').style.display = 'block';
  } catch(e) { _showErr('reg-error','Ошибка соединения'); }
}

async function verifyEmailCode() {
  _showErr('reg-verify-error','');
  const code = document.getElementById('reg-code').value.trim();
  try {
    const res  = await fetch('/api/auth/email/verify', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email:_regEmail,code})});
    const data = await res.json();
    if (!res.ok) { _showErr('reg-verify-error', data.detail||'Неверный код'); return; }
    userEmail = _regEmail;
    localStorage.setItem('t2l_user_id', userId);
    localStorage.setItem('t2l_email', _regEmail);
    await initApp();
  } catch(e) { _showErr('reg-verify-error','Ошибка соединения'); }
}

async function resendCode() {
  try {
    const res  = await fetch('/api/auth/email/resend', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email:_regEmail})});
    const data = await res.json();
    if (!res.ok) { _showErr('reg-verify-error', data.detail||'Ошибка'); return; }
    showToast('Новый код отправлен');
  } catch(e) {}
}

async function onTelegramAuth(user) {
  const errEl = document.getElementById('tg-auth-error');
  if (errEl) { errEl.style.display = 'none'; errEl.textContent = ''; }
  try {
    const res  = await fetch('/api/auth/telegram/verify', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(user)});
    const data = await res.json();
    if (!res.ok) {
      const msg = data.detail || 'Ошибка авторизации Telegram';
      if (errEl) { errEl.textContent = msg; errEl.style.display = 'block'; }
      else alert(msg);
      return;
    }
    userId = data.user_id;
    if (data.email) userEmail = data.email;
    localStorage.setItem('t2l_user_id', userId);
    localStorage.setItem('t2l_name', data.name);
    if (data.email) localStorage.setItem('t2l_email', data.email);
    await initApp();
  } catch(e) {
    const msg = 'Ошибка соединения с сервером';
    if (errEl) { errEl.textContent = msg; errEl.style.display = 'block'; }
    else alert(msg);
  }
}

function logout() {
  localStorage.removeItem('t2l_user_id');
  localStorage.removeItem('t2l_email');
  localStorage.removeItem('t2l_name');
  userId = 0; userEmail = '';
  const authEl = document.getElementById('screen-auth');
  const appEl  = document.getElementById('screen-app');
  authEl.style.display = '';
  authEl.classList.add('active');
  appEl.classList.remove('active');
  appEl.style.display = 'none';
}

// ── LINK ACCOUNTS (профиль) ──
async function linkTelegramAccount(telegramData) {
  try {
    const res  = await fetch('/api/auth/link/telegram', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:userId, telegram_data:telegramData})});
    const data = await res.json();
    if (!res.ok) { showToast(data.detail||'Ошибка привязки','error'); return; }
    showToast('Telegram успешно привязан ✓');
    loadProfile();
  } catch(e) { showToast('Ошибка соединения','error'); }
}

async function linkEmailAccount() {
  _showErr('link-email-error','');
  const email    = document.getElementById('link-email-input').value.trim();
  const password = document.getElementById('link-email-password').value;
  if (!email || !password) { _showErr('link-email-error','Заполните email и пароль'); return; }
  try {
    const res  = await fetch('/api/auth/link/email', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({telegram_user_id:userId, email, password})});
    const data = await res.json();
    if (!res.ok) { _showErr('link-email-error', data.detail||'Ошибка'); return; }
    _regEmail = email;
    document.getElementById('link-email-form').style.display  = 'none';
    document.getElementById('link-email-verify').style.display = 'block';
    document.getElementById('link-email-display').textContent  = email;
  } catch(e) { _showErr('link-email-error','Ошибка соединения'); }
}

async function verifyLinkCode() {
  _showErr('link-verify-error','');
  const code = document.getElementById('link-verify-code').value.trim();
  try {
    const res  = await fetch('/api/auth/email/verify', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email:_regEmail, code})});
    const data = await res.json();
    if (!res.ok) { _showErr('link-verify-error', data.detail||'Неверный код'); return; }
    userEmail = _regEmail;
    localStorage.setItem('t2l_email', _regEmail);
    showToast('Email успешно привязан ✓');
    loadProfile();
  } catch(e) { _showErr('link-verify-error','Ошибка соединения'); }
}

// ── SIDEBAR ──
function openSidebar() {
  document.getElementById('app-sidebar').classList.add('open');
  document.getElementById('sidebar-overlay').classList.add('active');
  document.body.style.overflow = 'hidden';
}
function closeSidebar() {
  document.getElementById('app-sidebar').classList.remove('open');
  document.getElementById('sidebar-overlay').classList.remove('active');
  document.body.style.overflow = '';
}

// ── INIT ──
async function initApp() {
  const authEl = document.getElementById('screen-auth');
  const appEl  = document.getElementById('screen-app');
  authEl.classList.remove('active');
  authEl.style.display = 'none';
  appEl.style.display  = 'flex';
  appEl.style.flexDirection = 'row';
  appEl.classList.add('active');

  // Показываем главную СРАЗУ — до всех fetch запросов
  // Это убирает белый экран пока грузятся данные
  navTo('main');

  await loadUserData();

  try {
    const res = await fetch(`/api/user/languages/${userId}`);
    const langs = await res.json();
    userNativeLang = langs.native || 'ru';
    userTargetLang = langs.target || 'en';
  } catch(e) {}

  applyTranslations();

  document.getElementById('club-level').textContent = currentLevel;
  initClubGreeting();

  // Онбординг только для новых пользователей (нет XP и нет прогресса)
  // Существующие пользователи всегда идут на главную
  try {
    const res = await fetch(`/api/onboarding/${userId}`);
    const data = await res.json();
    const isNewUser = !data.onboarding_done && (data.xp === 0 || data.xp === undefined);
    if (isNewUser) { showPage('onboarding'); return; }
  } catch(e) {}
  // navTo('main') уже вызван в начале initApp
}

async function loadUserData() {
  try {
    const res = await fetch(`/api/dashboard/${userId}`);
    const data = await res.json();
    const p = data.user || data;
    const name = p.name || userEmail.split('@')[0] || 'Ученик';
    const streak = p.streak ?? 0;
    const xp = p.xp ?? 0;
    currentLevel = p.level || 'A1';
    isAdmin = !!p.is_admin;

    document.getElementById('sidebar-name').textContent = name;
    document.getElementById('sidebar-streak').textContent = streak;
    const statStreakEl = document.getElementById('stat-streak');
    if (statStreakEl) statStreakEl.textContent = streak;
    document.getElementById('sidebar-xp').textContent = xp;
    document.getElementById('sidebar-avatar').textContent = name[0].toUpperCase();
    document.getElementById('mobile-avatar').textContent = name[0].toUpperCase();
    document.getElementById('mobile-xp').textContent = `⭐ ${xp} XP`;

    // Показываем кнопки для админов
    document.querySelectorAll('.admin-only').forEach(el => {
      el.style.display = isAdmin ? '' : 'none';
    });
  } catch(e) {}
}

// ── NAVIGATION ──
const FLEX_COL_PAGES = new Set(['main','dictionary','club','lesson','flashcards','situation-chat','profile','notebook','onboarding']);

function navTo(section) {
  document.querySelectorAll('.page').forEach(p => {
    p.style.display = 'none';
    p.style.flexDirection = '';
  });
  const page = document.getElementById('page-' + section);
  if (page) {
    page.style.display = 'block';
    if (FLEX_COL_PAGES.has(section)) {
      page.style.display = 'flex';
      page.style.flexDirection = 'column';
    }
  }

  // Sidebar nav highlight
  document.querySelectorAll('.nav-btn[data-nav]').forEach(b => {
    b.classList.toggle('active-nav', b.dataset.nav === section);
  });
  // Bottom nav highlight
  document.querySelectorAll('[data-mob-nav]').forEach(b => {
    b.classList.toggle('active-nav', b.dataset.mobNav === section);
  });

  // Update mobile title
  const titles = {main:'Главная',dictionary:'Словарь',notebook:'Блокнот',club:'Клуб',situations:'Ситуации',profile:'Профиль'};
  const el = document.getElementById('mobile-title');
  if (el && titles[section]) el.textContent = titles[section];

  // Close sidebar on mobile
  closeSidebar();

  // Lazy load sections
  if (section === 'dictionary' && !_vocabTopicsCache.length) loadVocabTopics(null);
  if (section === 'notebook') loadNotebook();
  if (section === 'profile') loadProfile();
}

function showPage(name) {
  document.querySelectorAll('.page').forEach(p => {
    p.style.display = 'none';
    p.style.flexDirection = '';
  });
  const page = document.getElementById('page-' + name);
  if (page) {
    page.style.display = 'block';
    if (FLEX_COL_PAGES.has(name)) {
      page.style.display = 'flex';
      page.style.flexDirection = 'column';
    }
  }
}

// ── LESSONS ──
function startCategory(cat) {
  currentCategory = cat;
  renderLevelsGrid();
  showPage('levels');
}

function renderLevelsGrid() {
  const t = (typeof UI_TRANSLATIONS !== 'undefined' && UI_TRANSLATIONS[userNativeLang]) || {};
  const catKey = 'cat_' + currentCategory;
  const catName = t[catKey] || currentCategory;
  const labelEl = document.getElementById('levels-category-label');
  if (labelEl) labelEl.textContent = (t.levels_section || 'Раздел:') + ' ' + catName;

  document.getElementById('levels-grid').innerHTML = LEVELS.map(lvl => {
    const m = LEVEL_META[lvl];
    const label = t['lvl_' + lvl] || m.label;
    const desc = t['lvl_' + lvl + '_desc'] || m.desc;
    return `<button onclick="selectLevel('${lvl}')"
      style="background:#fff;border:1px solid rgba(195,198,215,0.25);border-radius:20px;padding:0;text-align:left;cursor:pointer;box-shadow:0 2px 12px rgba(0,0,0,0.06);transition:transform 0.18s,box-shadow 0.18s;overflow:hidden"
      onmouseenter="this.style.transform='translateY(-4px)';this.style.boxShadow='0 8px 28px rgba(0,0,0,0.12)'"
      onmouseleave="this.style.transform='';this.style.boxShadow='0 2px 12px rgba(0,0,0,0.06)'">
      <div style="background:${m.gradient};padding:20px 18px 16px;position:relative;overflow:hidden">
        <div style="font-size:32px;line-height:1;margin-bottom:8px;filter:drop-shadow(0 2px 4px rgba(0,0,0,0.15))">${m.emoji}</div>
        <div style="font-size:28px;font-weight:900;color:#fff;line-height:1;letter-spacing:-1px">${lvl}</div>
        <div style="position:absolute;right:-8px;bottom:-8px;font-size:64px;opacity:0.08;font-weight:900;color:#fff;line-height:1">${lvl}</div>
      </div>
      <div style="padding:12px 14px 14px">
        <div style="font-size:13px;font-weight:700;color:#191c1e;margin-bottom:3px">${label}</div>
        <div style="font-size:11px;color:#737686;line-height:1.4">${desc}</div>
      </div>
    </button>`;
  }).join('');
}

function selectLevel(level) {
  currentLevel = level;
  document.getElementById('club-level').textContent = level;
  if (currentCategory === 'practice') { showPage('practice-mode'); return; }
  loadNextLesson();
}

async function loadNextLesson() {
  showPage('lesson');
  const typeMap = {lessons:'lesson', grammar:'grammar', vocabulary:'vocabulary'};
  const contentType = typeMap[currentCategory] || 'lesson';
  document.getElementById('lesson-content').innerHTML = '<div class="text-center py-12 text-outline"><span class="material-symbols-outlined animate-spin text-3xl">progress_activity</span></div>';
  try {
    const res = await fetch(`/api/lessons/next/${currentLevel}?user_id=${userId}&content_type=${contentType}`);
    const lesson = await res.json();
    if (lesson.completed) { renderLevelComplete(); return; }
    renderLesson(lesson);
  } catch(e) {
    document.getElementById('lesson-content').innerHTML = '<p class="text-error text-center py-8">Ошибка загрузки</p>';
  }
}

function renderLesson(lesson) {
  // Сохраняем текущий урок глобально
  window._currentLesson = lesson;

  const iconMap = {grammar:'edit_note', vocabulary:'psychology', lesson:'menu_book'};
  const typeLabels = {grammar:'ГРАММАТИКА', vocabulary:'ЛЕКСИКА', lesson:'УРОК'};
  const typeColors = {grammar:{bg:'#f5f3ff',color:'#7c3aed'}, vocabulary:{bg:'#f0fdf4',color:'#16a34a'}, lesson:{bg:'#eef2ff',color:'#4f65ef'}};
  const t = lesson.type || 'lesson';
  const tc = typeColors[t] || typeColors.lesson;

  // Обновляем хедер
  document.getElementById('lesson-title-header').textContent = lesson.title || 'Урок';
  const typeBadge = document.getElementById('lesson-type-badge');
  typeBadge.textContent = typeLabels[t] || 'УРОК';
  typeBadge.style.background = tc.bg; typeBadge.style.color = tc.color;
  document.getElementById('lesson-level-badge').textContent = currentLevel;

  // Прогресс-бар
  const p = lesson.progress || {};
  const total = p.total || 0, num = p.next_num || 1;
  const pct = total > 0 ? Math.round(((num-1)/total)*100) : 0;
  document.getElementById('lesson-progress-bar').style.width = pct + '%';
  document.getElementById('lesson-progress-label').textContent = total > 0 ? `${num-1} / ${total}` : '';

  // Кнопка завершения — сохраняем данные
  const btn = document.getElementById('lesson-complete-btn');
  btn.dataset.lessonType = t; btn.dataset.lessonId = lesson.id;
  btn.disabled = false;
  btn.querySelector('.lesson-complete-label').textContent = '+5 XP';

  // Вкладка "Урок" — основной текст
  document.getElementById('lesson-content').innerHTML = `
    <div style="display:flex;align-items:center;gap:8px;margin-bottom:16px">
      <div style="width:36px;height:36px;border-radius:10px;background:${tc.bg};display:flex;align-items:center;justify-content:center;flex-shrink:0">
        <span class="material-symbols-outlined filled" style="font-size:18px;color:${tc.color}">${iconMap[t]||'menu_book'}</span>
      </div>
      <div>
        <div style="font-size:12px;font-weight:700;color:${tc.color};text-transform:uppercase;letter-spacing:.06em">${typeLabels[t]||'УРОК'} · ${currentLevel}</div>
        <div style="font-size:18px;font-weight:800;color:#191c1e;line-height:1.3">${lesson.title||''}</div>
      </div>
    </div>
    <div style="background:#fffbeb;border:1px solid #fde68a;border-radius:10px;padding:8px 12px;margin-bottom:16px;display:flex;align-items:center;gap:6px">
      <span style="font-size:14px">💡</span>
      <span style="font-size:12px;color:#92400e;font-weight:500">Нажмите на любое слово для перевода</span>
    </div>
    <div style="background:#fff;border:1px solid rgba(195,198,215,0.3);border-radius:16px;padding:20px;line-height:1.9;font-size:15px;color:#434655;box-shadow:0 1px 8px rgba(0,0,0,0.04);margin-bottom:20px">${makeClickable(lesson.lesson_text||'')}</div>`;

  // Вкладка "Лексика" — извлекаем слова из текста
  const words = extractKeyWords(lesson.lesson_text || '', lesson.title);
  renderVocabTab(words);

  // Вкладка "Грамматика" — базовые конструкции
  renderGrammarTab(lesson);

  // Вкладка "Практика" — инициализируем чат
  initLessonPractice(lesson);

  // Активируем вкладку "Урок"
  switchLessonTab('content');
}

function extractKeyWords(text, title) {
  // Только английские слова из текста урока (латиница)
  const stopWordsEn = new Set([
    'the','and','for','are','but','not','you','all','can','her','was','one','our','out',
    'day','get','has','him','his','how','its','let','may','now','old','own','say','she',
    'too','use','way','who','did','off','put','set','two','any','come','give','most',
    'some','take','than','them','then','they','this','that','have','from','been','when',
    'will','with','your','were','what','also','each','into','just','know','more','much',
    'over','such','well','year','used','very','also','about','which','their','there',
    'here','where','these','those','have','been','said','made','like','time','look',
    'make','good','here','verb','form','word','mean','used','note','example'
  ]);
  // Берём только латинские слова длиной 3+ символов
  const words = text.match(/[A-Za-z]{3,}/g) || [];
  const unique = [...new Set(words.map(w => w.toLowerCase()))]
    .filter(w => !stopWordsEn.has(w));
  return unique.slice(0, 12);
}

// Кэш переводов чтобы не делать повторные запросы
const _vocabCache = {};

function renderVocabTab(words) {
  const el = document.getElementById('lesson-vocab-content');
  if (!el) return;
  if (!words.length) {
    el.innerHTML = `<div style="text-align:center;padding:48px 0;color:#9aa0b4">
      <div style="font-size:32px;margin-bottom:8px">📭</div>
      <div style="font-size:14px">В уроке нет английских слов для изучения</div>
    </div>`;
    return;
  }
  el.innerHTML = `
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px">
      <h3 style="font-size:14px;font-weight:700;color:#191c1e">Слова из урока</h3>
      <span style="font-size:12px;color:#9aa0b4">${words.length} слов — нажмите для перевода</span>
    </div>
    <div style="display:flex;flex-direction:column;gap:8px" id="vocab-cards-list">
      ${words.map(w => `
        <div id="wcard-${w}" onclick="translateVocabCard('${w}')"
          style="background:#fff;border:1.5px solid rgba(195,198,215,0.4);border-radius:14px;padding:14px 16px;cursor:pointer;transition:all 0.15s;display:flex;align-items:center;justify-content:space-between;gap:12px"
          onmouseenter="this.style.borderColor='#4f65ef';this.style.boxShadow='0 2px 12px rgba(79,101,239,0.12)'"
          onmouseleave="this.style.borderColor='rgba(195,198,215,0.4)';this.style.boxShadow=''">
          <div style="min-width:0">
            <div style="font-size:16px;font-weight:700;color:#191c1e">${w}</div>
            <div id="wcard-tr-${w}" style="font-size:13px;color:#9aa0b4;margin-top:2px">нажмите для перевода</div>
            <div id="wcard-ex-${w}" style="font-size:12px;color:#737686;margin-top:4px;display:none;font-style:italic"></div>
          </div>
          <div style="display:flex;align-items:center;gap:8px;flex-shrink:0">
            <button onclick="event.stopPropagation();speakVocabWord('${w}')"
              style="width:32px;height:32px;border-radius:50%;border:none;background:#f0f2f5;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:background 0.15s"
              title="Произнести" onmouseenter="this.style.background='#e0e3e8'" onmouseleave="this.style.background='#f0f2f5'">
              <span class="material-symbols-outlined" style="font-size:16px;color:#434655">volume_up</span>
            </button>
            <button onclick="event.stopPropagation();addVocabToNotebook('${w}')"
              id="wcard-add-${w}"
              style="width:32px;height:32px;border-radius:50%;border:none;background:#eef2ff;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:background 0.15s"
              title="В блокнот" onmouseenter="this.style.background='#dbe4ff'" onmouseleave="this.style.background='#eef2ff'">
              <span class="material-symbols-outlined" style="font-size:16px;color:#4f65ef">bookmark_add</span>
            </button>
          </div>
        </div>`).join('')}
    </div>`;
}

async function translateVocabCard(word) {
  const trEl = document.getElementById('wcard-tr-' + word);
  const exEl = document.getElementById('wcard-ex-' + word);
  if (!trEl) return;

  // Уже переведено
  if (_vocabCache[word]) {
    const c = _vocabCache[word];
    trEl.style.color = '#4f65ef';
    trEl.textContent = c.translation + (c.transcription ? '  ' + c.transcription : '');
    if (c.example) { exEl.textContent = c.example; exEl.style.display = 'block'; }
    return;
  }

  // Показываем загрузку
  trEl.textContent = '⏳ перевод...';
  trEl.style.color = '#9aa0b4';

  try {
    const res = await fetch('/api/dictionary/translate', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        user_id: userId,
        word,
        native_language: userNativeLang || 'ru',
        target_language: userTargetLang || 'en',
      })
    });
    const data = await res.json();
    if (data.status === 'success' && data.translation) {
      _vocabCache[word] = data;
      trEl.style.color = '#4f65ef';
      trEl.textContent = data.translation + (data.transcription ? '  ' + data.transcription : '');
      if (data.context_example) { exEl.textContent = data.context_example; exEl.style.display = 'block'; }
    } else {
      trEl.textContent = 'не удалось получить перевод';
      trEl.style.color = '#e34948';
    }
  } catch(e) {
    trEl.textContent = 'ошибка соединения';
    trEl.style.color = '#e34948';
  }
}

function speakVocabWord(word) {
  const audio = new Audio('/api/tts/word?word=' + encodeURIComponent(word));
  audio.play().catch(() => {});
}

async function addVocabToNotebook(word) {
  const btn = document.getElementById('wcard-add-' + word);
  if (!btn) return;
  const cached = _vocabCache[word];
  if (!cached) {
    await translateVocabCard(word);
  }
  const c = _vocabCache[word];
  if (!c) return;
  try {
    const res = await fetch('/api/dictionary/add', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        user_id: userId,
        word,
        translation: c.translation || '',
        transcription: c.transcription || '',
        context_example: c.context_example || '',
      })
    });
    const data = await res.json();
    if (data.status === 'success') {
      btn.style.background = '#dcfce7';
      btn.querySelector('.material-symbols-outlined').textContent = 'bookmark';
      btn.querySelector('.material-symbols-outlined').style.color = '#16a34a';
      btn.title = 'Добавлено в блокнот';
      showToast('✅ ' + word + ' добавлено в блокнот');
    }
  } catch(e) {}
}

function renderGrammarTab(lesson) {
  const el = document.getElementById('lesson-grammar-content');
  if (!el) return;
  // Ищем паттерны в тексте
  const text = lesson.lesson_text || '';
  const patterns = [];
  if (/I am|He is|She is|They are/i.test(text)) patterns.push({title:'To be (быть)', ex:'I am a student. She is happy.', rule:'am / is / are зависит от подлежащего'});
  if (/can/i.test(text)) patterns.push({title:'Modal: can (мочь)', ex:'I can speak English.', rule:'can + глагол в базовой форме'});
  if (/would like|want to/i.test(text)) patterns.push({title:'Would like / want to', ex:'I would like some water.', rule:'вежливая просьба или желание'});
  if (/How much|How many/i.test(text)) patterns.push({title:'How much / How many', ex:'How much is it? How many apples?', rule:'much — неисчисляемые, many — исчисляемые'});
  if (!patterns.length) patterns.push({title:'Структура урока', ex:lesson.title||'', rule:'Изучите текст урока, затем практикуйтесь в чате'});

  el.innerHTML = `
    <h3 style="font-size:14px;font-weight:700;color:#191c1e;margin:0 0 14px">Грамматика урока</h3>
    <div style="display:flex;flex-direction:column;gap:12px">
      ${patterns.map(p=>`
        <div style="background:#fff;border:1px solid rgba(195,198,215,0.3);border-radius:14px;padding:16px;box-shadow:0 1px 6px rgba(0,0,0,0.04)">
          <div style="font-size:14px;font-weight:700;color:#4f65ef;margin-bottom:6px">${p.title}</div>
          <div style="background:#f0f4ff;border-radius:8px;padding:8px 12px;font-size:13px;color:#191c1e;font-family:monospace;margin-bottom:6px">${p.ex}</div>
          <div style="font-size:12px;color:#737686">${p.rule}</div>
        </div>`).join('')}
    </div>`;
}

function initLessonPractice(lesson) {
  const box = document.getElementById('lesson-chat-box');
  if (!box) return;
  box.innerHTML = '';
  document.getElementById('lesson-practice-title').textContent = lesson.title || 'Практика по уроку';
  document.getElementById('lesson-practice-hint').textContent = `Уровень ${currentLevel} · Поговорите с AI`;
  const greeting = {
    en: `Hi! Let's practice based on the lesson "${lesson.title}". Feel free to ask me anything or start a conversation! 😊`,
    de: `Hallo! Lass uns basierend auf der Lektion "${lesson.title}" üben!`,
    fr: `Bonjour! Pratiquons la leçon "${lesson.title}" ensemble!`,
    es: `¡Hola! Vamos a practicar la lección "${lesson.title}".`,
  };
  addLessonMsg('ai', greeting[userTargetLang] || greeting.en, box);
}

function resetLessonChat() {
  if (window._currentLesson) initLessonPractice(window._currentLesson);
}

function addLessonMsg(who, text, box) {
  const wrap = document.createElement('div');
  wrap.style.cssText = 'display:flex;' + (who==='ai' ? 'justify-content:flex-start' : 'justify-content:flex-end');
  const div = document.createElement('div');
  if (who === 'ai') {
    div.style.cssText = 'background:linear-gradient(135deg,#eef2ff,#f5f3ff);border:1px solid rgba(79,101,239,0.12);color:#191c1e;padding:10px 14px;border-radius:18px;border-top-left-radius:4px;max-width:82%;font-size:14px;line-height:1.5;box-shadow:0 1px 6px rgba(0,0,0,0.05)';
    div.innerHTML = makeClickable(text);
  } else {
    div.style.cssText = 'background:linear-gradient(135deg,#4f65ef,#7c3aed);color:#fff;padding:10px 14px;border-radius:18px;border-top-right-radius:4px;max-width:82%;font-size:14px;line-height:1.5;box-shadow:0 2px 10px rgba(79,101,239,0.2)';
    div.textContent = text;
  }
  wrap.appendChild(div); box.appendChild(wrap);
  box.scrollTo({top:box.scrollHeight, behavior:'smooth'});
}

async function sendLessonMessage() {
  const inp = document.getElementById('lesson-chat-input');
  const text = inp.value.trim(); if (!text) return;
  inp.value = ''; inp.style.height = 'auto';
  const box = document.getElementById('lesson-chat-box');
  addLessonMsg('user', text, box);

  // Typing indicator
  const typing = document.createElement('div');
  typing.style.cssText = 'display:flex;justify-content:flex-start';
  typing.innerHTML = '<div style="background:#eef2ff;border:1px solid rgba(79,101,239,0.12);padding:10px 16px;border-radius:18px;border-top-left-radius:4px;font-size:20px;letter-spacing:4px">···</div>';
  box.appendChild(typing); box.scrollTo({top:box.scrollHeight, behavior:'smooth'});

  try {
    const lesson = window._currentLesson || {};
    const context = `You are an AI language tutor helping a student practice the lesson "${lesson.title||''}". Level: ${currentLevel}. Keep responses concise and encouraging.`;
    const fd = new FormData();
    fd.append('user_id', userId); fd.append('text', text); fd.append('level', currentLevel);
    fd.append('situation', context); fd.append('native_language', userNativeLang); fd.append('target_language', userTargetLang);
    const data = await (await fetch('/api/web-club/text', {method:'POST', body:fd})).json();
    box.removeChild(typing);
    addLessonMsg('ai', data.ai_text, box);
    if (data.audio_url) new Audio(data.audio_url).play().catch(()=>{});
  } catch(e) {
    box.removeChild(typing);
    addLessonMsg('ai', 'Ошибка соединения. Попробуйте ещё раз.', box);
  }
}

let _lessonRecording = false, _lessonRecorder = null, _lessonStream = null, _lessonChunks = [];
async function startLessonRecording(e) {
  e.preventDefault();
  if (_lessonRecording) return;
  _lessonChunks = [];
  try {
    const stream = await navigator.mediaDevices.getUserMedia({audio:true});
    _lessonStream = stream;
    let opts = MediaRecorder.isTypeSupported('audio/webm;codecs=opus') ? {mimeType:'audio/webm;codecs=opus'} : {};
    _lessonRecorder = new MediaRecorder(stream, opts);
    _lessonRecorder.ondataavailable = ev => { if (ev.data?.size>0) _lessonChunks.push(ev.data); };
    _lessonRecorder.onstop = async () => {
      const blob = new Blob(_lessonChunks, {type:_lessonRecorder.mimeType});
      const box = document.getElementById('lesson-chat-box');
      addLessonMsg('user', '🎙️ ...', box);
      const fd = new FormData(); fd.append('user_id', userId); fd.append('file', blob, 'voice');
      fd.append('level', currentLevel); fd.append('native_language', userNativeLang); fd.append('target_language', userTargetLang);
      try {
        const data = await (await fetch('/api/web-club/voice', {method:'POST',body:fd})).json();
        if (box.lastChild) box.removeChild(box.lastChild);
        addLessonMsg('user', data.user_text||'🎤', box);
        addLessonMsg('ai', data.ai_text, box);
        if (data.audio_url) new Audio(data.audio_url).play().catch(()=>{});
      } catch(e) { addLessonMsg('ai', 'Ошибка.', box); }
    };
    _lessonRecorder.start(); _lessonRecording = true;
    const btn = document.getElementById('lesson-mic-btn');
    btn.style.background = '#fee2e2'; btn.style.animation = 'micPulse 0.8s ease-in-out infinite';
    btn.querySelector('.material-symbols-outlined').style.color = '#ef4444';
  } catch(e) { alert('Нужен HTTPS и разрешение на микрофон'); }
}
function stopLessonRecording(e) {
  e.preventDefault();
  if (!_lessonRecording) return; _lessonRecording = false;
  const btn = document.getElementById('lesson-mic-btn');
  btn.style.background = '#f0f2f5'; btn.style.animation = '';
  btn.querySelector('.material-symbols-outlined').style.color = '#434655';
  if (_lessonRecorder?.state !== 'inactive') _lessonRecorder.stop();
  _lessonStream?.getTracks().forEach(t=>t.stop()); _lessonStream = null;
}

function switchLessonTab(name) {
  // Кнопки
  document.querySelectorAll('.lesson-tab').forEach(btn => {
    const active = btn.dataset.tab === name;
    btn.style.color = active ? '#4f65ef' : '#9aa0b4';
    btn.style.borderBottomColor = active ? '#4f65ef' : 'transparent';
    btn.style.fontWeight = active ? '700' : '600';
  });
  // Панели
  document.querySelectorAll('.lesson-tab-panel').forEach(p => {
    p.style.display = 'none';
  });
  const panel = document.getElementById('lesson-tab-' + name);
  if (panel) {
    panel.style.display = name === 'practice' ? 'flex' : 'block';
  }
  // Инициализация вкладки практики
  if (name === 'practice') {
    const box = document.getElementById('lesson-chat-box');
    if (box && !box.children.length && window._currentLesson) initLessonPractice(window._currentLesson);
  }
}

function loadLessonQuiz() {
  if (currentCategory === 'practice') { loadPractice(); return; }
  // Загружаем тест для текущего уровня
  showPage('practice-mode');
}

function completeLessonFromHeader() {
  const btn = document.getElementById('lesson-complete-btn');
  const t = btn.dataset.lessonType || 'lesson';
  const id = parseInt(btn.dataset.lessonId || '0');
  if (id) completeLesson(t, id);
}

function autoResizeTA(el) {
  el.style.height = 'auto';
  el.style.height = Math.min(el.scrollHeight, 120) + 'px';
}

async function renderLevelComplete() {
  const idx = LEVELS.indexOf(currentLevel);
  const hasNext = idx < LEVELS.length - 1;

  // Сколько раз уже проходили
  let passInfo = '';
  try {
    const r = await fetch(`/api/lessons/session/${userId}/${currentLevel}`);
    const d = await r.json();
    if (d.total_passes > 1) {
      passInfo = `<div style="display:inline-block;background:#f0fdf4;color:#16a34a;font-size:12px;font-weight:700;padding:4px 12px;border-radius:8px;margin-bottom:16px">🔄 Прохождение #${d.session}</div>`;
    }
  } catch(e) {}

  document.getElementById('lesson-content').innerHTML = `
    <div style="text-align:center;padding:48px 16px">
      <div style="font-size:64px;margin-bottom:12px">🎉</div>
      ${passInfo}
      <h2 style="font-size:22px;font-weight:800;color:#191c1e;margin:0 0 8px">Уровень ${currentLevel} пройден!</h2>
      <p style="font-size:14px;color:#737686;margin:0 0 24px">Все материалы уровня изучены. Отличная работа!</p>
      <div style="display:flex;flex-direction:column;gap:10px;align-items:center">
        ${hasNext ? `<button onclick="currentLevel='${LEVELS[idx+1]}';loadNextLesson()" style="background:linear-gradient(135deg,#4f65ef,#7c3aed);color:#fff;border:none;border-radius:14px;padding:12px 28px;font-size:14px;font-weight:700;cursor:pointer;box-shadow:0 4px 16px rgba(79,101,239,0.3);width:240px">Следующий уровень: ${LEVELS[idx+1]} →</button>` : '<p style="font-size:16px;font-weight:700;color:#16a34a">🏆 Вы прошли все уровни!</p>'}
        <button onclick="restartLevel('${currentLevel}')"
          style="background:#fff;border:1.5px solid rgba(195,198,215,0.6);color:#434655;border-radius:14px;padding:11px 28px;font-size:14px;font-weight:600;cursor:pointer;width:240px;display:flex;align-items:center;justify-content:center;gap:6px;transition:background 0.15s"
          onmouseenter="this.style.background='#f7f9fb'" onmouseleave="this.style.background='#fff'">
          <span style="font-size:16px">🔄</span> Пройти ${currentLevel} заново
        </button>
        <button onclick="navTo('main')" style="background:none;border:none;font-size:13px;color:#9aa0b4;cursor:pointer;margin-top:4px">← На главную</button>
      </div>
    </div>`;
  document.getElementById('lesson-tabs').style.display = 'none';
}

async function restartLevel(level) {
  try {
    const res = await fetch('/api/lessons/restart', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({user_id: userId, level})
    });
    const data = await res.json();
    if (!res.ok) { alert('Ошибка: ' + (data.detail || 'неизвестная')); return; }
    showToast(`${level} начат заново! (${data.message})`);
    // Возвращаем табы и загружаем первый урок
    document.getElementById('lesson-tabs').style.display = '';
    await loadNextLesson();
  } catch(e) {
    alert('Ошибка соединения');
  }
}


async function completeLesson(type, id) {
  const btn = document.getElementById('complete-btn');
  if (btn) { btn.disabled=true; btn.textContent='Сохранение...'; }
  try {
    const res = await fetch('/api/progress/complete',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),content_type:type,content_id:parseInt(id)})});
    const data = await res.json();
    if (data.xp_earned > 0) showToast(`🎉 +${data.xp_earned} XP!`);
    await loadUserData();
    await loadNextLesson();
  } catch(e) { showToast('Ошибка','neutral'); if(btn){btn.disabled=false;btn.textContent='✅ Просмотрено · +5 XP';} }
}

// ── PRACTICE ──
function startPracticeMode(mode) {
  if (mode === 'sentence_builder') loadSentenceBuilder();
  else loadPractice();
}

async function loadPractice() {
  showPage('practice');
  document.getElementById('practice-content').innerHTML = '<div class="text-center py-12 text-outline"><span class="material-symbols-outlined animate-spin text-3xl">progress_activity</span></div>';
  try {
    const res = await fetch(`/api/random_question?user_id=${userId}&type=multiple_choice&level=${currentLevel}`);
    const q = await res.json();
    if (q.error === 'no_more_questions') { document.getElementById('practice-content').innerHTML='<p class="text-center py-8 text-on-surface-variant">🎉 Все вопросы уровня пройдены!</p>'; return; }
    currentPracticeQId = q.question_id;
    correctPracticeOption = q.correct_option;
    document.getElementById('practice-content').innerHTML = `
      <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 mb-4">
        <p class="font-label text-xs text-outline uppercase tracking-wider mb-2">Вопрос</p>
        <p class="font-body text-on-surface text-base">${q.question}</p>
      </div>
      <div class="space-y-2" id="practice-options">
        ${q.options.map((opt,i)=>`<button onclick="checkAnswer(${i+1},this)" class="w-full text-left px-4 py-3 bg-surface-container-lowest border-2 border-surface-variant rounded-xl font-body text-on-surface text-sm hover:border-primary transition-colors"><span class="font-label text-outline mr-2">${String.fromCharCode(65+i)}.</span>${opt}</button>`).join('')}
      </div>
      <div id="practice-feedback" class="hidden mt-3 rounded-xl p-3 text-center font-label font-bold text-sm"></div>`;
  } catch(e) { document.getElementById('practice-content').innerHTML='<p class="text-error text-center py-8">Ошибка загрузки</p>'; }
}

async function checkAnswer(selected, btn) {
  document.querySelectorAll('#practice-options button').forEach(b=>b.disabled=true);
  const fb = document.getElementById('practice-feedback');
  fb.classList.remove('hidden');
  if (selected === correctPracticeOption) {
    btn.classList.add('border-green-500','bg-green-50','text-green-800');
    fb.className='rounded-xl p-3 text-center font-label font-bold text-sm bg-green-50 text-green-800 border border-green-200';
    fb.textContent='✅ Правильно!';
    try { await fetch('/api/progress/complete',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),content_type:'practice',content_id:currentPracticeQId})}); await loadUserData(); } catch(e){}
  } else {
    btn.classList.add('border-red-400','bg-red-50','text-red-700');
    fb.className='rounded-xl p-3 text-center font-label font-bold text-sm bg-red-50 text-red-700 border border-red-200';
    fb.textContent='❌ Неверно';
  }
  setTimeout(loadPractice, 2000);
}

// ── SENTENCE BUILDER ──
async function loadSentenceBuilder() {
  showPage('sentence-builder');
  sbSelected = [];
  document.getElementById('sb-content').innerHTML = '<div class="text-center py-12 text-outline"><span class="material-symbols-outlined animate-spin text-3xl">progress_activity</span></div>';
  try {
    const res = await fetch(`/api/random_question?user_id=${userId}&level=${currentLevel}&type=sentence_builder`);
    const q = await res.json();
    if (q.error==='no_more_questions') { document.getElementById('sb-content').innerHTML='<p class="text-center py-8">🎉 Все задания пройдены!</p>'; return; }
    sbCorrect = q.correct_sentence;
    sbQId = q.question_id;
    document.getElementById('sb-content').innerHTML = `
      <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 mb-4">
        <p class="font-label text-xs text-outline mb-1">Переведите:</p>
        <p class="font-body text-on-surface" id="sb-source">${q.question}</p>
      </div>
      <div id="sb-zone" class="min-h-16 border-2 border-dashed border-outline-variant rounded-2xl p-3 mb-3 flex flex-wrap gap-2 items-start">
        <p id="sb-zone-hint" class="text-outline text-sm opacity-60 w-full text-center">Нажимайте слова, чтобы составить фразу</p>
      </div>
      <div id="sb-bank" class="flex flex-wrap gap-2 mb-4">
        ${q.word_bank.map((w,i)=>`<button class="sb-chip px-3 py-1.5 bg-surface-container-lowest border border-surface-variant rounded-xl text-sm font-body text-on-surface hover:border-primary transition-colors" data-word="${w.replace(/"/g,'&quot;')}" data-idx="${i}" onclick="sbPickWord(this)">${w}</button>`).join('')}
      </div>
      <div id="sb-feedback" class="hidden mb-3"></div>
      <button id="sb-check" onclick="checkSb()" disabled class="w-full py-3 rounded-xl bg-surface-container text-outline font-label font-bold text-sm cursor-not-allowed">
        Проверить
      </button>`;
  } catch(e) { document.getElementById('sb-content').innerHTML='<p class="text-error text-center py-8">Ошибка</p>'; }
}

function sbPickWord(btn) {
  const word = btn.dataset.word, idx = btn.dataset.idx;
  btn.classList.add('opacity-0','pointer-events-none');
  setTimeout(()=>btn.classList.add('hidden'),100);
  const hint = document.getElementById('sb-zone-hint');
  if(hint) hint.remove();
  sbSelected.push({word,idx});
  const zone = document.getElementById('sb-zone');
  const chip = document.createElement('button');
  chip.className = 'px-3 py-1.5 bg-white border-2 border-primary-container rounded-xl text-sm font-body text-primary hover:opacity-80';
  chip.textContent = word;
  chip.dataset.idx = idx;
  chip.onclick = () => sbReturnWord(chip, idx);
  zone.appendChild(chip);
  updateSbBtn();
}

function sbReturnWord(chip, idx) {
  chip.remove();
  sbSelected = sbSelected.filter(w=>w.idx!==idx);
  const bankBtn = document.querySelector(`#sb-bank button[data-idx="${idx}"]`);
  if(bankBtn) bankBtn.classList.remove('hidden','opacity-0','pointer-events-none');
  if(sbSelected.length===0) {
    const zone = document.getElementById('sb-zone');
    const hint = document.createElement('p');
    hint.id='sb-zone-hint'; hint.className='text-outline text-sm opacity-60 w-full text-center';
    hint.textContent='Нажимайте слова, чтобы составить фразу';
    zone.appendChild(hint);
  }
  updateSbBtn();
}

function updateSbBtn() {
  const btn = document.getElementById('sb-check');
  if (!btn) return;
  if (sbSelected.length > 0) { btn.disabled=false; btn.className='w-full py-3 rounded-xl bg-primary-container text-on-primary font-label font-bold text-sm hover:opacity-90 transition-opacity'; }
  else { btn.disabled=true; btn.className='w-full py-3 rounded-xl bg-surface-container text-outline font-label font-bold text-sm cursor-not-allowed'; }
}

async function checkSb() {
  const user = sbSelected.map(w=>w.word).join(' ');
  const normalize = s => s.toLowerCase().replace(/[.!?,]/g,'').trim().replace(/\s+/g,' ');
  const ok = normalize(user) === normalize(sbCorrect);
  const fb = document.getElementById('sb-feedback');
  fb.classList.remove('hidden');
  document.querySelectorAll('#sb-zone button, #sb-bank button').forEach(b=>b.disabled=true);
  document.getElementById('sb-check').disabled=true;
  if (ok) {
    fb.className='rounded-xl p-3 text-center font-label font-bold text-sm bg-green-50 text-green-800 border border-green-200';
    fb.textContent='✅ Правильно!';
    try { await fetch('/api/progress/complete',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),content_type:'practice',content_id:sbQId})}); await loadUserData(); } catch(e){}
    setTimeout(loadSentenceBuilder, 2000);
  } else {
    fb.className='rounded-xl p-3 text-center font-label font-bold text-sm bg-red-50 text-red-700 border border-red-200';
    fb.textContent=`❌ Правильно: «${sbCorrect}»`;
    setTimeout(loadSentenceBuilder, 3000);
  }
}

// ── СЛОВАРЬ (ТЕМЫ) ──
// ── VOCAB STATE ──
let _vocabLevel = null, _vocabSearch = '';
let _vocabTopicsCache = [];

const TOPIC_GRADIENTS = {
  'Animals':    {from:'#34d399',to:'#0891b2',bg:'#ecfdf5'},
  'Food':       {from:'#fb923c',to:'#ef4444',bg:'#fff7ed'},
  'Transport':  {from:'#60a5fa',to:'#818cf8',bg:'#eff6ff'},
  'Home':       {from:'#a78bfa',to:'#ec4899',bg:'#f5f3ff'},
  'Nature':     {from:'#4ade80',to:'#22d3ee',bg:'#f0fdf4'},
  'Emotions':   {from:'#f472b6',to:'#fb923c',bg:'#fdf2f8'},
  'Sports':     {from:'#f59e0b',to:'#ef4444',bg:'#fffbeb'},
  'Technology': {from:'#6366f1',to:'#2563eb',bg:'#eef2ff'},
  'default':    {from:'#94a3b8',to:'#64748b',bg:'#f8fafc'},
};
const LEVEL_BADGE = {
  A1:{bg:'#dcfce7',color:'#16a34a'},
  A2:{bg:'#dbeafe',color:'#2563eb'},
  B1:{bg:'#fef3c7',color:'#d97706'},
  B2:{bg:'#fce7f3',color:'#db2777'},
  C1:{bg:'#f3e8ff',color:'#9333ea'},
  C2:{bg:'#f1f5f9',color:'#475569'},
};

function setVocabLevel(level) {
  _vocabLevel = level;
  document.querySelectorAll('.vocab-lvl').forEach(b => {
    const active = level===null ? b.dataset.lvl==='all' : b.dataset.lvl===level;
    b.style.background = active ? '#4f65ef' : '#f0f2f5';
    b.style.color      = active ? '#fff'    : '#737686';
    b.style.transform  = active ? 'scale(1.05)' : '';
  });
  renderVocabGrid();
}

function filterVocabTopics() {
  _vocabSearch = (document.getElementById('vocab-search')?.value||'').toLowerCase();
  renderVocabGrid();
}

async function loadVocabTopics(level) {
  _vocabLevel = level;
  const grid = document.getElementById('vocab-topics-grid');
  if (!grid) return;
  grid.innerHTML = '<div style="grid-column:1/-1;text-align:center;padding:48px 0;color:#9aa0b4"><span class="material-symbols-outlined" style="font-size:32px;display:block;margin-bottom:8px">sync</span>Загрузка...</div>';
  try {
    const url = '/api/vocab/topics';
    const topics = await (await fetch(url)).json();
    _vocabTopicsCache = topics;
    renderVocabGrid();
  } catch(e) {
    grid.innerHTML = '<div style="grid-column:1/-1;text-align:center;padding:48px 0;color:#ba1a1a">Ошибка загрузки</div>';
  }
}

function renderVocabGrid() {
  const grid = document.getElementById('vocab-topics-grid');
  if (!grid) return;
  let topics = _vocabTopicsCache;

  // Группируем по теме
  const byTopic = {};
  topics.forEach(t => {
    if (!byTopic[t.topic]) byTopic[t.topic] = {count:0, levels:[]};
    byTopic[t.topic].count += parseInt(t.card_count)||0;
    if (!byTopic[t.topic].levels.includes(t.level)) byTopic[t.topic].levels.push(t.level);
  });

  // Фильтруем по уровню
  let entries = Object.entries(byTopic);
  if (_vocabLevel) {
    entries = entries.filter(([,info]) => info.levels.includes(_vocabLevel));
  }
  // Фильтруем по поиску
  if (_vocabSearch) {
    entries = entries.filter(([topic]) => topic.toLowerCase().includes(_vocabSearch));
  }

  if (!entries.length) {
    grid.innerHTML = `<div style="grid-column:1/-1;text-align:center;padding:64px 16px">
      <div style="font-size:48px;margin-bottom:12px">🔍</div>
      <div style="font-size:16px;font-weight:700;color:#434655;margin-bottom:4px">Темы не найдены</div>
      <div style="font-size:13px;color:#9aa0b4">Попробуйте другой уровень или запрос</div>
    </div>`;
    return;
  }

  grid.innerHTML = entries.map(([topic, info]) => {
    const icon   = TOPIC_ICONS[topic] || '📖';
    const colors = TOPIC_GRADIENTS[topic] || TOPIC_GRADIENTS.default;
    const lvl    = info.levels[0] || 'A1';
    const badge  = LEVEL_BADGE[lvl] || LEVEL_BADGE.A1;
    const lvlLabel = _vocabLevel ? _vocabLevel : (info.levels.length > 1 ? info.levels.join('/') : lvl);
    return `<button onclick="openVocabTopic('${topic.replace(/'/g,"\\'")}','${_vocabLevel||''}')"
      style="background:#fff;border:1px solid rgba(195,198,215,0.25);border-radius:20px;padding:0;text-align:left;cursor:pointer;box-shadow:0 2px 12px rgba(0,0,0,0.06);transition:transform 0.18s,box-shadow 0.18s;overflow:hidden"
      onmouseenter="this.style.transform='translateY(-4px)';this.style.boxShadow='0 8px 28px rgba(0,0,0,0.12)'"
      onmouseleave="this.style.transform='';this.style.boxShadow='0 2px 12px rgba(0,0,0,0.06)'">
      <!-- Card top — gradient emoji area -->
      <div style="background:linear-gradient(135deg,${colors.from},${colors.to});padding:24px 16px 20px;display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:110px">
        <span style="font-size:44px;line-height:1;filter:drop-shadow(0 2px 4px rgba(0,0,0,0.15))">${icon}</span>
      </div>
      <!-- Card bottom — info -->
      <div style="padding:12px 14px 14px">
        <div style="font-size:14px;font-weight:800;color:#191c1e;margin-bottom:4px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${topic}</div>
        <div style="display:flex;align-items:center;justify-content:space-between;gap:6px">
          <span style="font-size:12px;color:#737686">${info.count} ${info.count===1?'слово':info.count<5?'слова':'слов'}</span>
          <span style="font-size:10px;font-weight:700;padding:2px 7px;border-radius:6px;background:${badge.bg};color:${badge.color};white-space:nowrap">${lvlLabel}</span>
        </div>
      </div>
    </button>`;
  }).join('');
}


async function openVocabTopic(topic, level) {
  const lvl = level || _vocabLevel || '';
  showPage('flashcards');
  const fc = document.getElementById('flashcard-content');
  fc.innerHTML = `<div style="text-align:center;padding:48px 0;color:#9aa0b4">
    <span class="material-symbols-outlined" style="font-size:40px;display:block;margin-bottom:12px">sync</span>
    <div style="font-size:14px">Загружаем карточки...</div>
  </div>`;
  // Back button title
  const backBtn = document.querySelector('#page-flashcards button');
  if (backBtn) backBtn.innerHTML = '<span class="material-symbols-outlined" style="font-size:18px;vertical-align:middle">arrow_back</span> ' + topic;

  try {
    const url = lvl
      ? `/api/vocab/cards?topic=${encodeURIComponent(topic)}&level=${lvl}`
      : `/api/vocab/cards?topic=${encodeURIComponent(topic)}`;
    const cards = await (await fetch(url)).json();
    if (!cards.length) {
      fc.innerHTML = `<div style="text-align:center;padding:48px 0">
        <div style="font-size:40px;margin-bottom:12px">📭</div>
        <div style="font-size:15px;font-weight:700;color:#434655">Карточки не найдены</div>
        <div style="font-size:13px;color:#9aa0b4;margin-top:4px">Добавьте карточки через панель администратора</div>
      </div>`;
      return;
    }
    startFlashcards(cards);
  } catch(e) {
    fc.innerHTML = '<p style="text-align:center;padding:32px;color:#ba1a1a">Ошибка загрузки</p>';
  }
}

function startFlashcards(cards) {
  vfCards = shuffle([...cards]); vfIdx=0; vfKnown=[]; vfLearning=[]; vfFlipped=false;
  renderFlashcard();
}

function shuffle(arr) {
  for(let i=arr.length-1;i>0;i--){const j=Math.floor(Math.random()*(i+1));[arr[i],arr[j]]=[arr[j],arr[i]];}
  return arr;
}

function renderFlashcard() {
  if (vfIdx >= vfCards.length) { renderFlashcardCompletion(); return; }
  vfCard = vfCards[vfIdx]; vfFlipped=false;
  const gradMap = {A1:'linear-gradient(135deg,#4ade80,#2dd4bf)',A2:'linear-gradient(135deg,#60a5fa,#818cf8)',B1:'linear-gradient(135deg,#fb923c,#f59e0b)',B2:'linear-gradient(135deg,#f472b6,#fb7185)',C1:'linear-gradient(135deg,#f87171,#a855f7)',C2:'linear-gradient(135deg,#71717a,#374151)'};
  // Конвертируем emoji_code в символ (может быть hex, текст или emoji)
  let emojiChar = vfCard.emoji_code || '📖';
  if (/^[0-9A-Fa-f]{4,6}$/.test(emojiChar)) {
    try { emojiChar = String.fromCodePoint(parseInt(emojiChar,16)); } catch(e) {}
  }
  const _t2e = {'cat':'🐱','dog':'🐶','bird':'🐦','fish':'🐟','horse':'🐴','cow':'🐄','pig':'🐷','sheep':'🐑','rabbit':'🐰','duck':'🦆','bear':'🐻','lion':'🦁','elephant':'🐘','monkey':'🐒','snake':'🐍','frog':'🐸','tiger':'🐯','wolf':'🐺','fox':'🦊','mouse':'🐭','chicken':'🐔','penguin':'🐧','dolphin':'🐬','turtle':'🐢','bee':'🐝','butterfly':'🦋','ant':'🐜','spider':'🕷','deer':'🦌','hamster':'🐹','apple':'🍎','banana':'🍌','bread':'🍞','egg':'🥚','rice':'🍚','soup':'🍲','pizza':'🍕','burger':'🍔','cake':'🎂','salad':'🥗','cheese':'🧀','butter':'🧈','milk':'🥛','orange':'🍊','lemon':'🍋','tomato':'🍅','potato':'🥔','carrot':'🥕','onion':'🧅','garlic':'🧄','pasta':'🍝','sandwich':'🥪','ice-cream':'🍦','chocolate':'🍫','cookie':'🍪','honey':'🍯','strawberry':'🍓','grapes':'🍇','watermelon':'🍉','mushroom':'🍄','corn':'🌽','pepper':'🌶','cucumber':'🥒','meat':'🥩','water':'💧','coffee':'☕','juice':'🧃','drink':'🥤','beer':'🍺','wine':'🍷','champagne':'🍾','house':'🏠','door':'🚪','kitchen':'🍳','bed':'🛏','bath':'🛁','window':'🪟','chair':'🪑','sofa':'🛋','lamp':'💡','clock':'🕐','mirror':'🪞','stairs':'🪜','ice':'🧊','tv':'📺','phone':'📱','pc':'💻','books':'📚','key':'🔑','bag':'👜','box':'📦','cup':'☕','plate':'🍽','spoon':'🥄','red':'🔴','blue':'🔵','green':'🟢','yellow':'🟡','purple':'🟣','pink':'🩷','black':'⚫','white':'⚪','grey':'🩶','brown':'🟫','gold':'🌟','silver':'⭐','woman':'👩','man':'👨','girl':'👧','boy':'👦','granny':'👵','grandpa':'👴','bride':'👰','groom':'🤵','baby':'👶','child':'🧒','parents':'👨‍👩‍👦','family':'👨‍👩‍👧‍👦','head':'🗣','hair':'💇','eye':'👁','ear':'👂','nose':'👃','mouth':'👄','tooth':'🦷','tongue':'👅','arm':'💪','hand':'🤚','finger':'☝','leg':'🦵','foot':'🦶','heart':'❤','face':'😊','thumbs-up':'👍','nail':'💅','shirt':'👕','pants':'👖','dress':'👗','jacket':'🧥','shoes':'👟','boots':'👢','socks':'🧦','hat':'🎩','scarf':'🧣','gloves':'🧤','sweater':'🧶','suit':'👔','sun':'☀','rain':'🌧','snow':'❄','cloud':'☁','wind':'💨','storm':'⛈','lightning':'⚡','fog':'🌫','rainbow':'🌈','hot':'🥵','cold':'🥶','warm':'🌤','morning':'🌅','evening':'🌆','night':'🌙','date':'📅','week':'📆','month':'🗓','hour':'⏰','minute':'⏱','holiday':'🎉','tree':'🌳','flower':'🌸','grass':'🌿','river':'🏞','sea':'🌊','mountain':'⛰','forest':'🌲','beach':'🏖','moon':'🌕','earth':'🌍','island':'🏝','desert':'🏜','rock':'🪨','leaf':'🍃','plant':'🌱','school':'🏫','teacher':'👩‍🏫','student':'🧑‍🎓','book':'📖','pen':'🖊','pencil':'✏','paper':'📄','notebook':'📓','homework':'📝','word':'💬','question':'❓','car':'🚗','bus':'🚌','train':'🚂','plane':'✈','bike':'🚲','taxi':'🚕','boat':'⛵','ship':'🚢','moto':'🏍','truck':'🚛','tram':'🚃','subway':'🚇','heli':'🚁','station':'🚉','ticket':'🎫','city':'🏙','village':'🏡','shop':'🏪','market':'🛒','hospital':'🏥','bank':'🏦','park':'🌳','restaurant':'🍽','hotel':'🏨','museum':'🏛','cinema':'🎬','church':'⛪','office':'🏢','factory':'🏭','farm':'🚜','gym':'🏋','wave':'👋','pray':'🙏','yes':'✅','no':'❌','help':'🆘','smile':'😊','handshake':'🤝','eat':'🍴','sleep':'😴','walk':'🚶','run':'🏃','sit':'🪑','stand':'🧍','speak':'🗣','buy':'🛒','make':'🛠','like':'❤','want':'💭','work':'💼','play':'🎮','read':'📖','write':'✍','watch':'📺','cook':'🍳','clean':'🧹','big':'🔵','small':'🔹','new':'✨','old':'🏚','sad':'😢','fast':'⚡','slow':'🐢','beautiful':'🌸','free':'🆓','busy':'💼','understand':'🧠'};
  if (_t2e[emojiChar]) emojiChar = _t2e[emojiChar];
  // Twemoji URL
  const _cp = [...emojiChar].map(c=>c.codePointAt(0).toString(16)).join('-');
  const _twUrl = `https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/${_cp}.png`;
  const _emojiImg = `<img src="${_twUrl}" style="width:56px;height:56px;object-fit:contain" onerror="this.style.display='none';this.nextSibling.style.display='block'"/><span style="font-size:48px;display:none">${emojiChar}</span>`;
  const pct = vfCards.length>0?Math.round(vfIdx/vfCards.length*100):0;
  document.getElementById('flashcard-content').innerHTML = `
    <div class="mb-3"><div class="flex justify-between text-xs text-outline font-label mb-1"><span>${vfIdx}/${vfCards.length}</span><span>${vfKnown.length} знаю · ${vfLearning.length} учу</span></div>
    <div class="h-1.5 w-full bg-surface-container-high rounded-full overflow-hidden"><div class="h-full bg-primary-container rounded-full transition-all" style="width:${pct}%"></div></div></div>
    <div id="vf-card" onclick="flipCard()" class="cursor-pointer bg-surface-container-lowest border-2 border-surface-variant rounded-3xl p-6 mb-4 text-center min-h-[240px] flex flex-col items-center justify-center card-enter transition-all">
      <div id="vf-emoji-bg" class="w-20 h-20 rounded-2xl flex items-center justify-center text-4xl mb-3" style="background:${gradMap[vfCard.level]||gradMap.A1}">${_emojiImg}</div>
      <div class="font-headline font-extrabold text-2xl text-on-surface mb-1">${vfCard.word}</div>
      <span class="text-xs bg-surface-container text-outline px-2 py-0.5 rounded-full font-label">${vfCard.level}</span>
      <div id="vf-tap-hint" class="text-xs text-outline mt-3 font-label">Нажмите, чтобы открыть</div>
      <div id="vf-back" class="hidden mt-3 text-center">
        <div class="text-primary-container font-bold text-lg font-headline">${vfCard.translation||''}</div>
        <div class="text-on-surface-variant text-sm mt-1">${vfCard.definition||''}</div>
      </div>
    </div>
    <div id="vf-btns" class="hidden grid grid-cols-2 gap-3">
      <button onclick="rateCard('learning')" class="py-3 bg-red-50 border border-red-200 text-red-700 font-label font-bold rounded-xl hover:bg-red-100">👈 Учу</button>
      <button onclick="rateCard('known')" class="py-3 bg-green-50 border border-green-200 text-green-700 font-label font-bold rounded-xl hover:bg-green-100">Знаю 👉</button>
    </div>
    <button onclick="speakWord()" class="mt-2 w-full py-2 text-sm text-outline hover:text-on-surface transition-colors font-label flex items-center justify-center gap-1">
      <span class="material-symbols-outlined text-base">volume_up</span> Произношение
    </button>`;
}

function flipCard() {
  if (vfFlipped) return; vfFlipped=true;
  document.getElementById('vf-tap-hint').classList.add('hidden');
  document.getElementById('vf-back').classList.remove('hidden');
  document.getElementById('vf-btns').classList.remove('hidden');
  document.getElementById('vf-btns').classList.add('grid');
  document.getElementById('vf-card').classList.add('border-primary-container','bg-surface-container-low');
}

function rateCard(rating) {
  if (!vfFlipped) { flipCard(); return; }
  if (rating==='known') {
    vfKnown.push(vfCard);
    fetch('/api/progress/complete',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),content_type:'vocab_card',content_id:vfCard.id})}).catch(()=>{});
  } else {
    vfLearning.push(vfCard);
    fetch('/api/dictionary/quick_add',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),word:vfCard.word,context_sentence:vfCard.definition||''})}).catch(()=>{});
  }
  vfIdx++;
  renderFlashcard();
}

function renderFlashcardCompletion() {
  document.getElementById('flashcard-content').innerHTML = `
    <div class="text-center py-8">
      <div class="text-5xl mb-4">🎉</div>
      <h3 class="font-headline font-extrabold text-xl text-on-surface mb-2">Тема пройдена!</h3>
      <div class="grid grid-cols-2 gap-3 mb-6">
        <div class="bg-green-50 border border-green-200 rounded-2xl p-4"><div class="font-headline font-extrabold text-2xl text-green-700">${vfKnown.length}</div><div class="text-xs text-green-600 font-label">Знаю</div></div>
        <div class="bg-red-50 border border-red-200 rounded-2xl p-4"><div class="font-headline font-extrabold text-2xl text-red-700">${vfLearning.length}</div><div class="text-xs text-red-600 font-label">Учу</div></div>
      </div>
      <button onclick="startFlashcards(vfCards)" class="w-full py-3 bg-primary-container text-on-primary font-label font-bold rounded-xl mb-2">Повторить все</button>
      ${vfLearning.length>0?`<button onclick="startFlashcards(vfLearning)" class="w-full py-3 bg-surface-container text-on-surface-variant font-label font-bold rounded-xl">Повторить «учу»</button>`:''}
    </div>`;
}

function speakWord() {
  if (!vfCard) return;
  new Audio(`/api/tts/word?word=${encodeURIComponent(vfCard.word)}`).play().catch(()=>{});
}

// ── БЛОКНОТ ──
async function loadNotebook() {
  const list = document.getElementById('notebook-list');
  const count = document.getElementById('notebook-count');
  list.innerHTML='<p class="text-center py-8 text-outline">Загрузка...</p>';
  try {
    const words = await (await fetch(`/api/dictionary/${userId}`)).json();
    count.textContent = words.length + ' слов';
    if (!words.length) { list.innerHTML='<div class="text-center py-8 bg-surface-container rounded-2xl border-2 border-dashed border-outline-variant"><span class="material-symbols-outlined text-outline text-4xl">book_2</span><p class="text-outline text-sm mt-2">Нажмите на слово в уроке — оно появится здесь</p></div>'; return; }
    list.innerHTML = words.map(w=>`
      <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 mb-3 shadow-sm">
        <div class="flex justify-between items-start">
          <div><div class="font-headline font-bold text-on-surface text-lg">${w.word}</div>${w.transcription?`<div class="font-label text-xs text-outline">${w.transcription}</div>`:''}<div class="text-primary font-body font-bold mt-1">${w.translation}</div></div>
          <button onclick="toggleWordStatus('${w.word.replace(/'/g,"\\'")}','${w.status}')" class="px-2 py-1 rounded-full text-xs font-label font-bold transition-all ${w.status==='known'?'bg-tertiary-container text-on-tertiary':'bg-surface-container text-on-surface-variant'}">${w.status==='known'?'✓ Знаю':'Учу'}</button>
        </div>
        ${w.context_example?`<div class="mt-2 text-sm text-on-surface-variant italic border-t border-surface-variant pt-2">"${w.context_example}"</div>`:''}
      </div>`).join('');
  } catch(e) { list.innerHTML='<p class="text-error text-center py-8">Ошибка загрузки</p>'; }
}

async function toggleWordStatus(word, status) {
  const newStatus = status==='known'?'learning':'known';
  try { await fetch('/api/dictionary/status',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),word,status:newStatus})}); loadNotebook(); } catch(e){}
}

// ── РАЗГОВОРНЫЙ КЛУБ ──
function initClubGreeting() {
  const box = document.getElementById('chat-box');
  if (!box) return;
  box.innerHTML='';
  addChatMsg('ai', AI_GREETINGS[userTargetLang]||AI_GREETINGS.en, box);
}

function addChatMsg(who, text, box) {
  const wrap = document.createElement('div');
  wrap.style.cssText = 'display:flex;' + (who==='ai' ? 'justify-content:flex-start' : 'justify-content:flex-end');

  const div = document.createElement('div');
  if (who === 'ai') {
    div.style.cssText = 'background:linear-gradient(135deg,#eef2ff,#f5f3ff);border:1px solid rgba(79,101,239,0.12);color:#191c1e;padding:10px 14px;border-radius:18px;border-top-left-radius:4px;max-width:82%;font-size:14px;line-height:1.5;box-shadow:0 1px 6px rgba(0,0,0,0.06)';
    div.innerHTML = makeClickable(text);
  } else {
    div.style.cssText = 'background:linear-gradient(135deg,#4f65ef,#7c3aed);color:#fff;padding:10px 14px;border-radius:18px;border-top-right-radius:4px;max-width:82%;font-size:14px;line-height:1.5;box-shadow:0 2px 10px rgba(79,101,239,0.25)';
    div.textContent = text;
  }
  wrap.appendChild(div);
  box.appendChild(wrap);
  box.scrollTo({top:box.scrollHeight, behavior:'smooth'});
}

function autoResizeClubInput(el) {
  el.style.height = 'auto';
  el.style.height = Math.min(el.scrollHeight, 120) + 'px';
}

async function sendClubMessage() {
  const inp=document.getElementById('chat-input'); const text=inp.value.trim(); if(!text)return;
  inp.value=''; inp.style.height='auto'; const box=document.getElementById('chat-box');
  addChatMsg('user',text,box);
  try {
    const fd=new FormData(); fd.append('user_id',userId); fd.append('text',text); fd.append('level',currentLevel); fd.append('native_language',userNativeLang); fd.append('target_language',userTargetLang);
    const data=await (await fetch('/api/web-club/text',{method:'POST',body:fd})).json();
    addChatMsg('ai',data.ai_text,box);
    if(data.audio_url)new Audio(data.audio_url).play().catch(()=>{});
  } catch(e){addChatMsg('ai','Connection error.',box);}
}

async function startClubRecording(e) {
  e.preventDefault();
  if (_clubRecording) return;
  clubAudioChunks = [];
  try {
    const stream = await navigator.mediaDevices.getUserMedia({audio:true});
    clubStreamRef = stream;
    let opts = {};
    if (MediaRecorder.isTypeSupported('audio/webm;codecs=opus')) opts = {mimeType:'audio/webm;codecs=opus'};
    clubMediaRecorder = new MediaRecorder(stream, opts);
    clubMediaRecorder.ondataavailable = ev => { if (ev.data?.size > 0) clubAudioChunks.push(ev.data); };
    clubMediaRecorder.onstop = async () => {
      const blob = new Blob(clubAudioChunks, {type: clubMediaRecorder.mimeType});
      const box = document.getElementById('chat-box');
      addChatMsg('user', '🎙️ ...', box);
      const fd = new FormData();
      fd.append('user_id', userId); fd.append('file', blob, 'voice');
      fd.append('level', currentLevel); fd.append('native_language', userNativeLang); fd.append('target_language', userTargetLang);
      try {
        const data = await (await fetch('/api/web-club/voice', {method:'POST', body:fd})).json();
        const last = box.lastChild; if (last) box.removeChild(last);
        addChatMsg('user', data.user_text || '🎤', box);
        addChatMsg('ai', data.ai_text, box);
        if (data.audio_url) new Audio(data.audio_url).play().catch(()=>{});
      } catch(e) { addChatMsg('ai', 'Ошибка соединения.', box); }
    };
    clubMediaRecorder.start();
    _clubRecording = true;
    const micIcon = document.getElementById('club-mic-btn');
    micIcon.style.background = '#fee2e2';
    micIcon.querySelector('.material-symbols-outlined').style.color = '#ef4444';
    // Пульсация
    micIcon.style.animation = 'micPulse 0.8s ease-in-out infinite';
  } catch(e) { alert('Нужен HTTPS и разрешение на использование микрофона'); }
}

function stopClubRecording(e) {
  e.preventDefault();
  if (!_clubRecording) return;
  _clubRecording = false;
  const micIcon = document.getElementById('club-mic-btn');
  micIcon.style.background = '#f0f2f5';
  micIcon.style.animation = '';
  micIcon.querySelector('.material-symbols-outlined').style.color = '#434655';
  if (clubMediaRecorder?.state !== 'inactive') clubMediaRecorder.stop();
  clubStreamRef?.getTracks().forEach(t => t.stop());
  clubStreamRef = null;
}

// ── СИТУАЦИИ ──
function openSituation(key, title, sit) {
  currentSituation=sit;
  document.getElementById('sit-title').textContent=title;
  document.getElementById('sit-hint').textContent=SIT_HINTS[sit]||'';
  const box=document.getElementById('sit-chat-box'); box.innerHTML='';
  const greet=(SIT_GREETINGS[sit]||{})[userTargetLang]||(SIT_GREETINGS[sit]||{}).en||'Hello!';
  addSitMsg('ai',greet,box);
  showPage('situation-chat');
}

function addSitMsg(who,text,box) {
  const div=document.createElement('div');
  if(who==='ai'){div.className='bg-primary-container text-on-primary p-3 rounded-2xl rounded-tl-none max-w-[85%] text-sm shadow-sm';div.innerHTML=makeClickable(text);}
  else{div.className='bg-surface-container text-on-surface p-3 rounded-2xl rounded-tr-none max-w-[85%] text-sm shadow-sm ml-auto';div.textContent=text;}
  box.appendChild(div); box.scrollTop=box.scrollHeight;
}

async function sendSitMessage() {
  const inp=document.getElementById('sit-input'); const text=inp.value.trim(); if(!text)return;
  inp.value=''; const box=document.getElementById('sit-chat-box'); addSitMsg('user',text,box);
  try {
    const fd=new FormData(); fd.append('user_id',userId); fd.append('text',text); fd.append('level',currentLevel); fd.append('situation',currentSituation); fd.append('native_language',userNativeLang); fd.append('target_language',userTargetLang);
    const data=await(await fetch('/api/web-club/text',{method:'POST',body:fd})).json();
    addSitMsg('ai',data.ai_text,box); if(data.audio_url)new Audio(data.audio_url).play().catch(()=>{});
  } catch(e){addSitMsg('ai','Connection error.',box);}
}

async function startSitRecording(e) {
  e.preventDefault(); sitAudioChunks=[];
  try {
    const stream=await navigator.mediaDevices.getUserMedia({audio:true}); sitStreamRef=stream;
    let opts={}; if(MediaRecorder.isTypeSupported('audio/webm;codecs=opus'))opts={mimeType:'audio/webm;codecs=opus'};
    sitMediaRecorder=new MediaRecorder(stream,opts);
    sitMediaRecorder.ondataavailable=ev=>{if(ev.data?.size>0)sitAudioChunks.push(ev.data);};
    sitMediaRecorder.onstop=async()=>{
      const blob=new Blob(sitAudioChunks,{type:sitMediaRecorder.mimeType});
      const box=document.getElementById('sit-chat-box'); addSitMsg('user','🎙️ ...',box);
      const fd=new FormData(); fd.append('user_id',userId); fd.append('file',blob,'voice'); fd.append('level',currentLevel); fd.append('situation',currentSituation); fd.append('native_language',userNativeLang); fd.append('target_language',userTargetLang);
      try{const data=await(await fetch('/api/web-club/voice',{method:'POST',body:fd})).json(); if(box.lastChild)box.removeChild(box.lastChild); addSitMsg('user',data.user_text||'🎤',box); addSitMsg('ai',data.ai_text,box); if(data.audio_url)new Audio(data.audio_url).play().catch(()=>{});}catch(e){addSitMsg('ai','Error.',box);}
    };
    sitMediaRecorder.start();
    document.getElementById('sit-mic-btn').querySelector('.material-symbols-outlined').style.color='#ef4444';
  } catch(e){alert('Нужен HTTPS и разрешения');}
}
function stopSitRecording(e) {
  e.preventDefault();
  document.getElementById('sit-mic-btn').querySelector('.material-symbols-outlined').style.color='';
  if(sitMediaRecorder?.state!=='inactive')sitMediaRecorder.stop();
  sitStreamRef?.getTracks().forEach(t=>t.stop()); sitStreamRef=null;
}

// ── ПРОФИЛЬ ──
async function loadProfile() {
  const c=document.getElementById('profile-content');
  c.innerHTML='<p class="text-center py-8 text-outline">Загрузка...</p>';
  try {
    const p=await(await fetch(`/api/profile/${userId}`)).json();
    const xpInLevel=p.xp%XP_PER_LEVEL, xpPct=Math.min(100,Math.round(xpInLevel/XP_PER_LEVEL*100));
    let catHtml='';
    try {
      const cats=await(await fetch(`/api/stats/categories/${userId}`)).json();
      const labels={lesson:{icon:'📖',name:'Уроки'},grammar:{icon:'✍️',name:'Грамматика'},vocabulary:{icon:'💬',name:'Лексика'},practice:{icon:'🎯',name:'Практика'},vocab_cards:{icon:'🃏',name:'Карточки'},words:{icon:'📒',name:'Блокнот'}};
      catHtml=Object.entries(labels).map(([k,{icon,name}])=>{
        const s=cats[k]||{completed:0,total:0};
        const pct=s.total>0?Math.min(100,Math.round(s.completed/s.total*100)):0;
        const label=s.total===0?'нет':s.completed+' / '+s.total;
        return `<div class="mb-3"><div class="flex justify-between text-xs text-on-surface-variant font-label mb-1"><span>${icon} ${name}</span><span>${label}</span></div><div class="h-1.5 w-full bg-surface-container-high rounded-full overflow-hidden"><div class="h-full bg-primary-container rounded-full" style="width:${pct}%"></div></div></div>`;
      }).join('');
    } catch(e){}
    c.innerHTML=`
      <div class="bg-gradient-to-br from-primary to-primary-container rounded-2xl p-6 text-white text-center mb-4">
        <div class="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-2"><span class="material-symbols-outlined filled text-3xl">school</span></div>
        <div class="font-headline font-extrabold text-xl">${p.name||'Ученик'}</div>
        ${p.username?`<div class="text-white/70 text-sm">@${p.username}</div>`:''}
      </div>
      <div class="grid grid-cols-2 gap-3 mb-4">
        <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 text-center"><div class="font-headline font-extrabold text-2xl text-secondary-container">${p.streak}</div><div class="text-xs text-outline font-label mt-1">🔥 Дней подряд</div></div>
        <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 text-center"><div class="font-headline font-extrabold text-2xl text-amber-500">${p.xp}</div><div class="text-xs text-outline font-label mt-1">⭐ Всего XP</div></div>
        <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 text-center"><div class="font-headline font-extrabold text-2xl text-primary-container">${p.lessons_done}</div><div class="text-xs text-outline font-label mt-1">📖 Уроков</div></div>
        <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 text-center"><div class="font-headline font-extrabold text-2xl text-tertiary-container">${p.tasks_done}</div><div class="text-xs text-outline font-label mt-1">🎯 Заданий</div></div>
      </div>
      <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 mb-4">
        <div class="flex justify-between text-xs text-on-surface-variant font-label mb-2"><span class="font-bold">Прогресс XP</span><span>${p.xp} XP</span></div>
        <div class="h-2 w-full bg-surface-container-high rounded-full overflow-hidden"><div class="h-full bg-primary-container rounded-full transition-all" style="width:${xpPct}%"></div></div>
      </div>
      ${catHtml?`<div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 mb-4"><p class="font-label text-xs text-outline uppercase tracking-wider mb-3">Прогресс по разделам</p>${catHtml}</div>`:''}
      <button onclick="showLangSettings()" class="w-full py-3 bg-surface-container text-on-surface-variant font-label font-bold text-sm rounded-xl hover:bg-surface-container-high transition-colors mb-3">
        ⚙️ Настройки языка
      </button>
      ${isAdmin ? `<a href="/admin" target="_blank" style="display:flex;align-items:center;justify-content:center;gap:8px;width:100%;padding:12px;margin-bottom:12px;background:linear-gradient(135deg,#4f46e5,#7c3aed);color:#fff;font-size:13px;font-weight:700;border-radius:12px;text-decoration:none;box-sizing:border-box">
        <span class="material-symbols-outlined filled" style="font-size:18px">admin_panel_settings</span> Панель администратора
      </a>` : ''}
      <div id="account-links-section"></div>
      <button onclick="logout()" class="w-full py-3 bg-red-50 text-red-600 border border-red-200 font-label font-bold text-sm rounded-xl hover:bg-red-100 transition-colors mt-3">
        Выйти из аккаунта
      </button>`;
    await loadAccountLinks();
  } catch(e){ c.innerHTML='<p class="text-error text-center py-8">Ошибка загрузки</p>'; }
}

async function loadAccountLinks() {
  try {
    const status = await (await fetch('/api/auth/status/' + userId)).json();
    const el = document.getElementById('account-links-section');
    if (!el) return;
    const hasEmail = status.email && status.email_verified;
    const hasTg    = !!status.telegram_id;
    let html = '<div style="border:1px solid #e0e3e5;border-radius:16px;padding:16px;margin-bottom:12px">';
    html += '<p style="font-size:11px;color:#737686;text-transform:uppercase;letter-spacing:.05em;margin-bottom:12px">Аккаунты</p>';

    if (hasEmail) {
      html += '<div style="display:flex;align-items:center;gap:8px;padding:8px 0;border-bottom:1px solid #e0e3e5">';
      html += '<span style="font-size:20px">✉️</span>';
      html += '<div><div style="font-size:13px;font-weight:600">' + status.email + '</div>';
      html += '<div style="font-size:11px;color:#16a34a">✓ Подтверждён</div></div></div>';
    } else {
      html += '<div style="padding:8px 0;border-bottom:1px solid #e0e3e5">';
      html += '<div style="display:flex;align-items:center;gap:8px;margin-bottom:8px"><span style="font-size:20px">✉️</span><span style="font-size:13px;color:#737686">Email не привязан</span></div>';
      html += '<div id="link-email-form">';
      html += '<input id="link-email-input" type="email" placeholder="Email" style="width:100%;border:1px solid #c3c6d7;border-radius:10px;padding:8px 12px;font-size:13px;margin-bottom:8px;box-sizing:border-box"/>';
      html += '<input id="link-email-password" type="password" placeholder="Придумайте пароль" style="width:100%;border:1px solid #c3c6d7;border-radius:10px;padding:8px 12px;font-size:13px;margin-bottom:8px;box-sizing:border-box"/>';
      html += '<button onclick="linkEmailAccount()" style="width:100%;padding:10px;background:#4f46e5;color:#fff;border:none;border-radius:10px;font-size:13px;font-weight:600;cursor:pointer">Привязать email</button>';
      html += '<p id="link-email-error" style="color:#ba1a1a;font-size:12px;margin-top:4px;display:none"></p></div>';
      html += '<div id="link-email-verify" style="display:none">';
      html += '<p style="font-size:12px;color:#434655;margin-bottom:8px">Код отправлен на <strong id="link-email-display"></strong></p>';
      html += '<input id="link-verify-code" type="text" maxlength="6" placeholder="000000" style="width:100%;border:1px solid #c3c6d7;border-radius:10px;padding:8px 12px;font-size:20px;text-align:center;letter-spacing:8px;margin-bottom:8px;box-sizing:border-box"/>';
      html += '<button onclick="verifyLinkCode()" style="width:100%;padding:10px;background:#7c3aed;color:#fff;border:none;border-radius:10px;font-size:13px;font-weight:600;cursor:pointer">Подтвердить</button>';
      html += '<p id="link-verify-error" style="color:#ba1a1a;font-size:12px;margin-top:4px;display:none"></p></div></div>';
    }

    if (hasTg) {
      const tgName = status.telegram_name || status.telegram_username || 'Telegram';
      html += '<div style="display:flex;align-items:center;gap:8px;padding-top:8px">';
      html += '<span style="font-size:20px">✈️</span>';
      html += '<div><div style="font-size:13px;font-weight:600">' + tgName + '</div>';
      html += '<div style="font-size:11px;color:#16a34a">✓ Привязан</div></div></div>';
    } else {
      html += '<div style="padding-top:8px">';
      html += '<div style="display:flex;align-items:center;gap:8px;margin-bottom:8px"><span style="font-size:20px">✈️</span><span style="font-size:13px;color:#737686">Telegram не привязан</span></div>';
      html += '<p style="font-size:12px;color:#737686">Войдите через Telegram для привязки</p></div>';
    }

    html += '</div>';
    el.innerHTML = html;
  } catch(e) { console.error('loadAccountLinks error:', e); }
}


// ── НАСТРОЙКИ ЯЗЫКА ──
function showLangSettings() {
  lsTgt = userTargetLang;
  lsNtv = userNativeLang;
  const html=`
    <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 mb-4">
      <h3 class="font-headline font-bold text-on-surface mb-3">Язык изучения</h3>
      <div class="grid grid-cols-2 gap-2">
        ${[['en','🇬🇧','Английский']].map(([l,f,n])=>`<button onclick="setLangTarget('${l}')" data-tgt="${l}" class="ls-tgt p-3 border-2 ${userTargetLang===l?'border-primary-container bg-surface-container-low':'border-surface-variant'} rounded-xl text-center text-sm font-label hover:border-primary transition-colors"><div class="text-2xl">${f}</div><div class="font-bold text-on-surface">${n}</div></button>`).join('')}
      </div>
    </div>
    <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 mb-4">
      <h3 class="font-headline font-bold text-on-surface mb-3">Родной язык</h3>
      <div class="grid grid-cols-2 gap-2">
        ${[['ru','🇷🇺','Русский'],['en','🇬🇧','Английский'],['de','🇩🇪','Немецкий'],['fr','🇫🇷','Французский']].map(([l,f,n])=>`<button onclick="setLangNative('${l}')" data-ntv="${l}" class="ls-ntv p-3 border-2 ${userNativeLang===l?'border-primary-container bg-surface-container-low':'border-surface-variant'} rounded-xl text-center text-sm font-label hover:border-primary transition-colors"><div class="text-2xl">${f}</div><div class="font-bold text-on-surface">${n}</div></button>`).join('')}
      </div>
    </div>
    <p id="ls-status" class="text-xs text-center font-label mb-2"></p>
    <button onclick="saveLangSettings()" class="w-full py-3 bg-tertiary-container text-on-tertiary font-label font-bold rounded-xl hover:opacity-90 mb-2">Сохранить</button>
    <button onclick="loadProfile()" class="w-full py-2 text-sm text-outline hover:text-on-surface transition-colors">← Назад</button>`;
  document.getElementById('profile-content').innerHTML=html;
}

let lsTgt='', lsNtv='';
function setLangTarget(l){ lsTgt=l; document.querySelectorAll('.ls-tgt').forEach(b=>{const a=b.dataset.tgt===l;b.classList.toggle('border-primary-container',a);b.classList.toggle('bg-surface-container-low',a);b.classList.toggle('border-surface-variant',!a);}); }
function setLangNative(l){ lsNtv=l; document.querySelectorAll('.ls-ntv').forEach(b=>{const a=b.dataset.ntv===l;b.classList.toggle('border-primary-container',a);b.classList.toggle('bg-surface-container-low',a);b.classList.toggle('border-surface-variant',!a);}); }
async function saveLangSettings() {
  if(!lsTgt||!lsNtv){document.getElementById('ls-status').textContent='Выберите оба языка';return;}
  if(lsTgt===lsNtv){document.getElementById('ls-status').textContent='⚠️ Языки не могут совпадать';return;}
  try {
    await fetch('/api/user/languages',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),native_language:lsNtv,target_language:lsTgt})});
    userNativeLang=lsNtv; userTargetLang=lsTgt;
    applyTranslations();
    document.getElementById('ls-status').textContent='✅ Сохранено!';
    setTimeout(loadProfile,1000);
  } catch(e){document.getElementById('ls-status').textContent='Ошибка';}
}

// ── ОНБОРДИНГ ──
function obSelectTarget(lang) {
  obTarget=lang;
  document.querySelectorAll('.ob-lang').forEach(b=>{
    b.style.outline = b.dataset.lang===lang ? '3px solid #4f65ef' : '';
  });
  setTimeout(()=>{
    document.getElementById('ob-step-0').style.display='none';
    document.getElementById('ob-native-grid').innerHTML = Object.keys(LANG_NATIVE_NAMES)
      .filter(l=>l!==lang)
      .map(l=>`<button onclick="obSelectNative('${l}')" style="background:#fff;border:1px solid rgba(195,198,215,0.4);border-radius:16px;padding:14px;text-align:center;cursor:pointer;transition:transform 0.15s" onmouseenter="this.style.transform='scale(1.03)'" onmouseleave="this.style.transform=''"><div style="font-size:28px;margin-bottom:4px">${LANG_FLAGS[l]}</div><div style="font-size:13px;font-weight:700;color:#191c1e">${LANG_NATIVE_NAMES[l]}</div></button>`)
      .join('');
    document.getElementById('ob-step-1').style.display='block';
  },200);
}
function obSelectNative(lang) {
  obNative=lang;
  setTimeout(()=>{
    document.getElementById('ob-step-1').style.display='none';
    document.getElementById('ob-step-2').style.display='block';
  },200);
}
function obSelectLevel(level) {
  obLevel=level;
  document.getElementById('ob-step-2').style.display='none';
  document.getElementById('ob-ready-msg').textContent=`Язык: ${obTarget.toUpperCase()}, уровень ${level}`;
  document.getElementById('ob-step-3').style.display='block';
}
async function finishOnboarding() {
  try {
    await fetch('/api/onboarding/complete',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),level:obLevel,goal:'general',native_language:obNative,target_language:obTarget})});
    userNativeLang=obNative; userTargetLang=obTarget; currentLevel=obLevel;
    applyTranslations();
    await loadUserData();
    navTo('main');
  } catch(e){navTo('main');}
}

// ── POPUP (перевод слов) ──
function makeClickable(text) {
  return text.replace(/([A-Za-zÀ-ÿА-яёЁ]{2,})/g, w=>`<span class="clickable-word" data-word="${w.replace(/&/g,'&amp;').replace(/</g,'&lt;')}">${w}</span>`);
}
document.addEventListener('click', e=>{
  const span=e.target.closest('.clickable-word'); if(!span)return;
  handleWordTap(span.dataset.word, span.closest('div')?.textContent||'');
});
async function handleWordTap(word, ctx) {
  popupWord=word; popupContext=ctx;
  document.getElementById('popup-word').textContent=word;
  document.getElementById('popup-transcription').textContent='';
  document.getElementById('popup-translation').textContent='⏳ Перевод...';
  document.getElementById('popup-example').textContent='';
  document.getElementById('popup-status').textContent='';
  document.getElementById('popup-retry-btn').style.display='none';
  document.getElementById('popup-add-btn').disabled=false;
  document.getElementById('popup-add-btn').textContent='+ В мой словарь';
  showWordPopup();
  try {
    const data=await(await fetch('/api/dictionary/translate',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),word,context_sentence:ctx.substring(0,300),native_language:userNativeLang,target_language:userTargetLang})})).json();
    if(data.status==='success'){
      document.getElementById('popup-transcription').textContent=data.transcription||'';
      document.getElementById('popup-translation').textContent=data.translation||'—';
      document.getElementById('popup-example').textContent=data.context_example?`"${data.context_example}"`:'';}
    else {
      document.getElementById('popup-translation').textContent=data.message||'Ошибка';
      document.getElementById('popup-retry-btn').style.display='block';
    }
  } catch(e){
    document.getElementById('popup-translation').textContent='Ошибка соединения';
    document.getElementById('popup-retry-btn').style.display='block';
  }
}
function retryTranslation() { handleWordTap(popupWord, popupContext); }
function showWordPopup() {
  document.getElementById('word-popup-overlay').classList.remove('hidden');
  document.getElementById('word-popup').classList.remove('hidden-popup');
}
function hideWordPopup() {
  document.getElementById('word-popup-overlay').classList.add('hidden');
  document.getElementById('word-popup').classList.add('hidden-popup');
}
async function addWordToDict() {
  if(!popupWord)return;
  const btn=document.getElementById('popup-add-btn'); btn.disabled=true; btn.textContent='Сохранение...';
  try {
    const data=await(await fetch('/api/dictionary/quick_add',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),word:popupWord,context_sentence:popupContext.substring(0,300)})})).json();
    if(data.status==='success'){document.getElementById('popup-status').textContent='✅ Добавлено!';btn.textContent='✓ В словаре';}
    else{document.getElementById('popup-status').textContent=data.message||'Ошибка';btn.disabled=false;btn.textContent='+ В мой словарь';}
  } catch(e){document.getElementById('popup-status').textContent='Ошибка';btn.disabled=false;btn.textContent='+ В мой словарь';}
}

// ── TOAST ──
function showToast(msg, type='success') {
  const t=document.createElement('div');
  t.className=`fixed bottom-24 md:bottom-6 left-1/2 -translate-x-1/2 ${type==='success'?'bg-tertiary-container text-on-tertiary':'bg-on-surface text-surface'} px-4 py-2 rounded-xl text-sm font-label font-bold shadow-lg z-50 whitespace-nowrap`;
  t.textContent=msg; document.body.appendChild(t); setTimeout(()=>t.remove(),2800);
}

// ── СТАРТ ──
window.onload = async () => {
  // Авто-логин по tg_id из URL (бот передаёт ?tg_id=123456)
  const params = new URLSearchParams(window.location.search);
  const tgIdFromUrl = params.get('tg_id');
  if (tgIdFromUrl && !localStorage.getItem('t2l_user_id')) {
    try {
      const res = await fetch('/api/auth/telegram/autologin', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({telegram_id: parseInt(tgIdFromUrl)})
      });
      if (res.ok) {
        const data = await res.json();
        userId = data.user_id;
        localStorage.setItem('t2l_user_id', userId);
        if (data.name) localStorage.setItem('t2l_name', data.name);
        window.history.replaceState({}, '', window.location.pathname);
        await initApp();
        return;
      }
    } catch(e) {}
  }

  const savedId = localStorage.getItem('t2l_user_id');
  if (savedId && parseInt(savedId) > 0) {
    userId = parseInt(savedId);
    userEmail = localStorage.getItem('t2l_email') || '';
    await initApp();
  }
};
