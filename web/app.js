// ── Состояние ──
let userId = 0, userEmail = '';
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
const LEVEL_GRADIENTS = {A1:'from-green-400 to-teal-500',A2:'from-blue-400 to-indigo-500',B1:'from-orange-400 to-amber-500',B2:'from-pink-400 to-rose-500',C1:'from-red-400 to-purple-500',C2:'from-zinc-600 to-gray-800'};
const TOPIC_ICONS = {'Animals':'🐾','Food':'🍽️','Transport':'🚀','Home':'🏠','Nature':'🌿','Emotions':'😊','Sports':'⚽','Technology':'💻'};
const AI_GREETINGS = {en:"Hello! How can I help you today? Feel free to type or use the microphone!",de:"Hallo! Wie kann ich Ihnen heute helfen?",fr:"Bonjour ! Comment puis-je vous aider ?",es:"¡Hola! ¿En qué puedo ayudarte?",it:"Ciao! Come posso aiutarti?",zh:"你好！今天我能帮你什么？",ru:"Привет! Чем могу помочь?"};
const SIT_GREETINGS = {shop:{en:"Welcome! How can I help you today?",ru:"Добро пожаловать! Чем могу помочь?"},restaurant:{en:"Good evening! Do you have a reservation?",ru:"Добрый вечер! У вас есть бронь?"},airport:{en:"Good morning! May I see your passport?",ru:"Доброе утро! Ваш паспорт, пожалуйста."},hotel:{en:"Welcome to our hotel! Do you have a reservation?",ru:"Добро пожаловать! Есть бронь?"},doctor:{en:"Hello! What brings you in today?",ru:"Здравствуйте! Что вас беспокоит?"},emergency:{en:"Emergency services, what is your emergency?",ru:"Служба спасения, что случилось?"}};
const SIT_HINTS = {shop:'🛒 Вы покупатель. Попросите найти товар.',restaurant:'🍽️ Вы гость. Закажите блюдо.',airport:'✈️ Вы пассажир. Пройдите регистрацию.',hotel:'🏨 Вы гость. Заселитесь.',doctor:'🏥 Вы пациент. Опишите симптомы.',emergency:'🚨 Срочно опишите ситуацию.'};

// ── AUTH ──
async function requestCode() {
  const email = document.getElementById('auth-email').value.trim();
  const err = document.getElementById('auth-error1');
  err.classList.add('hidden');
  if (!email || !email.includes('@')) { err.textContent='Введите корректный email'; err.classList.remove('hidden'); return; }
  try {
    const res = await fetch('/api/auth/email/request-code', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email})});
    const data = await res.json();
    if (!res.ok) { err.textContent=data.detail||'Ошибка'; err.classList.remove('hidden'); return; }
    document.getElementById('auth-email-display').textContent = email;
    document.getElementById('auth-email-step1').classList.add('hidden');
    document.getElementById('auth-email-step2').classList.remove('hidden');
  } catch(e) { err.textContent='Ошибка соединения'; err.classList.remove('hidden'); }
}

async function verifyCode() {
  const email = document.getElementById('auth-email').value.trim();
  const code = document.getElementById('auth-code').value.trim();
  const err = document.getElementById('auth-error2');
  err.classList.add('hidden');
  try {
    const res = await fetch('/api/auth/email/verify', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email,code})});
    const data = await res.json();
    if (!res.ok) { err.textContent=data.detail||'Неверный код'; err.classList.remove('hidden'); return; }
    userId = data.user_id;
    userEmail = email;
    localStorage.setItem('t2l_user_id', userId);
    localStorage.setItem('t2l_email', email);
    await initApp();
  } catch(e) { err.textContent='Ошибка соединения'; err.classList.remove('hidden'); }
}

async function onTelegramAuth(user) {
  try {
    const res = await fetch('/api/auth/telegram/verify', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(user)});
    const data = await res.json();
    if (!res.ok) { alert('Ошибка авторизации Telegram'); return; }
    userId = data.user_id;
    localStorage.setItem('t2l_user_id', userId);
    localStorage.setItem('t2l_name', data.name);
    await initApp();
  } catch(e) { alert('Ошибка соединения'); }
}

function logout() {
  localStorage.removeItem('t2l_user_id');
  localStorage.removeItem('t2l_email');
  localStorage.removeItem('t2l_name');
  userId = 0;
  document.getElementById('screen-app').classList.remove('active');
  document.getElementById('screen-app').classList.add('hidden');
  document.getElementById('screen-auth').classList.add('active');
}

// ── INIT ──
async function initApp() {
  document.getElementById('screen-auth').classList.remove('active');
  document.getElementById('screen-auth').style.display = 'none';
  document.getElementById('screen-app').classList.add('active');

  await loadUserData();

  try {
    const res = await fetch(`/api/user/languages/${userId}`);
    const langs = await res.json();
    userNativeLang = langs.native || 'ru';
    userTargetLang = langs.target || 'en';
  } catch(e) {}

  document.getElementById('club-level').textContent = currentLevel;
  initClubGreeting();

  try {
    const res = await fetch(`/api/onboarding/${userId}`);
    const data = await res.json();
    if (!data.onboarding_done) { showPage('onboarding'); return; }
  } catch(e) {}

  navTo('main');
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

    document.getElementById('sidebar-name').textContent = name;
    document.getElementById('sidebar-streak').textContent = streak;
    document.getElementById('sidebar-xp').textContent = xp;
    document.getElementById('sidebar-avatar').textContent = name[0].toUpperCase();
    document.getElementById('mobile-avatar').textContent = name[0].toUpperCase();
    document.getElementById('mobile-xp').textContent = `⭐ ${xp} XP`;
  } catch(e) {}
}

// ── NAVIGATION ──
function navTo(section) {
  document.querySelectorAll('.page').forEach(p => p.classList.add('hidden'));
  const page = document.getElementById('page-' + section);
  if (page) { page.classList.remove('hidden'); page.classList.add('flex'); }

  document.querySelectorAll('.nav-btn, .mob-nav').forEach(b => {
    const active = b.dataset.nav === section;
    b.classList.toggle('text-primary', active);
    b.classList.toggle('bg-surface-container-low', active && b.classList.contains('nav-btn'));
    b.classList.toggle('text-on-surface-variant', !active && b.classList.contains('nav-btn'));
    b.classList.toggle('text-outline', !active && b.classList.contains('mob-nav'));
  });

  if (section === 'dictionary') loadVocabTopics(null);
  if (section === 'notebook') loadNotebook();
  if (section === 'profile') loadProfile();
  if (section === 'club' && document.getElementById('chat-box').children.length === 0) initClubGreeting();
  document.getElementById('mobile-title').textContent = {main:'Главная',dictionary:'Словарь',notebook:'Блокнот',club:'Разговорный клуб',situations:'Ситуации',profile:'Профиль'}[section] || 'Talk2Learn';
}

function showPage(name) {
  document.querySelectorAll('.page').forEach(p => { p.classList.add('hidden'); p.classList.remove('flex'); });
  const page = document.getElementById('page-' + name);
  if (page) { page.classList.remove('hidden'); page.classList.add('flex'); }
}

// ── LESSONS ──
function startCategory(cat) {
  currentCategory = cat;
  renderLevelsGrid();
  showPage('levels');
}

function renderLevelsGrid() {
  document.getElementById('levels-grid').innerHTML = LEVELS.map(lvl => `
    <button onclick="selectLevel('${lvl}')" class="bg-gradient-to-br ${LEVEL_GRADIENTS[lvl]} rounded-2xl p-4 text-white text-left hover:scale-95 transition-transform shadow-sm">
      <span class="text-xs text-white/70 block">Уровень</span>
      <span class="font-headline font-extrabold text-2xl block">${lvl}</span>
    </button>`).join('');
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
  const iconMap = {grammar:'edit_note', vocabulary:'psychology', lesson:'menu_book'};
  const icon = iconMap[lesson.type] || 'menu_book';
  const p = lesson.progress || {};
  const total = p.total || 0, num = p.next_num || 1;
  const pct = total > 0 ? Math.round(((num-1)/total)*100) : 0;
  const progressHtml = total > 0 ? `<div class="mb-4"><div class="flex justify-between text-xs text-outline font-label mb-1"><span>Урок ${num} из ${total}</span><span>${pct}%</span></div><div class="h-1.5 w-full bg-surface-container-high rounded-full overflow-hidden"><div class="h-full bg-primary-container rounded-full transition-all" style="width:${pct}%"></div></div></div>` : '';
  document.getElementById('lesson-content').innerHTML = `
    ${progressHtml}
    <div class="flex items-center gap-2 mb-3"><span class="material-symbols-outlined filled text-primary-container">${icon}</span><span class="font-label text-xs text-outline uppercase tracking-wider">${lesson.type||'урок'} · ${currentLevel}</span></div>
    <h1 class="font-headline font-extrabold text-on-surface text-2xl mb-4 leading-tight">${lesson.title}</h1>
    <p class="font-label text-xs text-outline mb-2">💡 Нажмите на слово для перевода</p>
    <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 text-on-surface-variant leading-loose text-base font-body mb-6">${makeClickable(lesson.lesson_text||'')}</div>
    <button id="complete-btn" onclick="completeLesson('${lesson.type||'lesson'}',${lesson.id})"
      class="w-full py-3 rounded-xl bg-tertiary-container text-on-tertiary font-label font-bold uppercase tracking-wider text-sm hover:opacity-90 transition-opacity">
      ✅ Просмотрено · +5 XP
    </button>`;
}

function renderLevelComplete() {
  const idx = LEVELS.indexOf(currentLevel);
  const hasNext = idx < LEVELS.length - 1;
  document.getElementById('lesson-content').innerHTML = `
    <div class="text-center py-12">
      <div class="text-6xl mb-4">🎉</div>
      <h2 class="font-headline font-extrabold text-2xl text-on-surface mb-2">Уровень ${currentLevel} пройден!</h2>
      <p class="text-on-surface-variant mb-6">Вы прошли все материалы уровня. Отличная работа!</p>
      ${hasNext ? `<button onclick="currentLevel='${LEVELS[idx+1]}';loadNextLesson()" class="px-6 py-3 bg-primary-container text-on-primary font-label font-bold rounded-xl hover:opacity-90">Следующий: ${LEVELS[idx+1]} →</button>` : '<p class="text-tertiary-container font-bold">🏆 Вы прошли все уровни!</p>'}
      <br><button onclick="showPage('levels')" class="mt-3 text-sm text-outline hover:text-on-surface transition-colors">← К выбору уровня</button>
    </div>`;
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
async function loadVocabTopics(level) {
  document.querySelectorAll('.vocab-lvl').forEach(b => {
    const active = level===null ? b.dataset.lvl==='all' : b.dataset.lvl===level;
    b.className = `vocab-lvl px-3 py-1 rounded-full text-xs font-label font-bold transition-colors ${active?'bg-primary-container text-on-primary':'bg-surface-container text-on-surface-variant'}`;
  });
  const grid = document.getElementById('vocab-topics-grid');
  grid.innerHTML = '<p class="col-span-3 text-outline text-center py-8">Загрузка...</p>';
  try {
    const url = level ? `/api/vocab/topics?level=${level}` : '/api/vocab/topics';
    const topics = await (await fetch(url)).json();
    if (!topics.length) { grid.innerHTML='<p class="col-span-3 text-outline text-center py-8">Темы не добавлены</p>'; return; }
    const byTopic = {};
    topics.forEach(t=>{ if(!byTopic[t.topic])byTopic[t.topic]={count:0,levels:[]}; byTopic[t.topic].count+=parseInt(t.card_count); byTopic[t.topic].levels.push(t.level); });
    grid.innerHTML = Object.entries(byTopic).map(([topic,info])=>{
      const icon = TOPIC_ICONS[topic]||'📖';
      const g = LEVEL_GRADIENTS[info.levels[0]]||LEVEL_GRADIENTS['A1'];
      return `<button onclick="openVocabTopic('${topic.replace(/'/g,"\\'")}','${level||''}')"
        class="bg-gradient-to-br ${g} rounded-2xl p-4 text-white text-left hover:scale-95 transition-transform shadow-sm">
        <span class="text-3xl block mb-1">${icon}</span>
        <span class="font-headline font-extrabold text-sm block">${topic}</span>
        <span class="text-xs text-white/70">${info.count} слов</span>
      </button>`;
    }).join('');
  } catch(e) { grid.innerHTML='<p class="col-span-3 text-error text-center py-8">Ошибка</p>'; }
}

async function openVocabTopic(topic, level) {
  showPage('flashcards');
  document.getElementById('flashcard-content').innerHTML = '<div class="text-center py-12 text-outline"><span class="material-symbols-outlined animate-spin text-3xl">progress_activity</span></div>';
  try {
    const url = level ? `/api/vocab/cards?topic=${encodeURIComponent(topic)}&level=${level}` : `/api/vocab/cards?topic=${encodeURIComponent(topic)}`;
    const cards = await (await fetch(url)).json();
    if (!cards.length) { document.getElementById('flashcard-content').innerHTML='<p class="text-center py-8 text-outline">Карточки не найдены</p>'; return; }
    startFlashcards(cards);
  } catch(e) { document.getElementById('flashcard-content').innerHTML='<p class="text-error text-center py-8">Ошибка</p>'; }
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
  let emoji='📖'; try{emoji=String.fromCodePoint(parseInt(vfCard.emoji_code,16));}catch(e){}
  const pct = vfCards.length>0?Math.round(vfIdx/vfCards.length*100):0;
  document.getElementById('flashcard-content').innerHTML = `
    <div class="mb-3"><div class="flex justify-between text-xs text-outline font-label mb-1"><span>${vfIdx}/${vfCards.length}</span><span>${vfKnown.length} знаю · ${vfLearning.length} учу</span></div>
    <div class="h-1.5 w-full bg-surface-container-high rounded-full overflow-hidden"><div class="h-full bg-primary-container rounded-full transition-all" style="width:${pct}%"></div></div></div>
    <div id="vf-card" onclick="flipCard()" class="cursor-pointer bg-surface-container-lowest border-2 border-surface-variant rounded-3xl p-6 mb-4 text-center min-h-[240px] flex flex-col items-center justify-center card-enter transition-all">
      <div id="vf-emoji-bg" class="w-20 h-20 rounded-2xl flex items-center justify-center text-4xl mb-3" style="background:${gradMap[vfCard.level]||gradMap.A1}">${emoji}</div>
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
  const div = document.createElement('div');
  if (who==='ai') { div.className='bg-primary-container text-on-primary p-3 rounded-2xl rounded-tl-none max-w-[85%] text-sm shadow-sm'; div.innerHTML=makeClickable(text); }
  else { div.className='bg-surface-container text-on-surface p-3 rounded-2xl rounded-tr-none max-w-[85%] text-sm shadow-sm ml-auto'; div.textContent=text; }
  box.appendChild(div);
  box.scrollTop=box.scrollHeight;
}

async function sendClubMessage() {
  const inp=document.getElementById('chat-input'); const text=inp.value.trim(); if(!text)return;
  inp.value=''; const box=document.getElementById('chat-box');
  addChatMsg('user',text,box);
  try {
    const fd=new FormData(); fd.append('user_id',userId); fd.append('text',text); fd.append('level',currentLevel); fd.append('native_language',userNativeLang); fd.append('target_language',userTargetLang);
    const data=await (await fetch('/api/web-club/text',{method:'POST',body:fd})).json();
    addChatMsg('ai',data.ai_text,box);
    if(data.audio_url)new Audio(data.audio_url).play().catch(()=>{});
  } catch(e){addChatMsg('ai','Connection error.',box);}
}

async function startClubRecording(e) {
  e.preventDefault(); clubAudioChunks=[];
  try {
    const stream=await navigator.mediaDevices.getUserMedia({audio:true}); clubStreamRef=stream;
    let opts={}; if(MediaRecorder.isTypeSupported('audio/webm;codecs=opus'))opts={mimeType:'audio/webm;codecs=opus'};
    clubMediaRecorder=new MediaRecorder(stream,opts);
    clubMediaRecorder.ondataavailable=ev=>{if(ev.data?.size>0)clubAudioChunks.push(ev.data);};
    clubMediaRecorder.onstop=async()=>{
      const blob=new Blob(clubAudioChunks,{type:clubMediaRecorder.mimeType});
      const box=document.getElementById('chat-box'); addChatMsg('user','🎙️ ...',box);
      const fd=new FormData(); fd.append('user_id',userId); fd.append('file',blob,'voice'); fd.append('level',currentLevel); fd.append('native_language',userNativeLang); fd.append('target_language',userTargetLang);
      try{const data=await(await fetch('/api/web-club/voice',{method:'POST',body:fd})).json(); if(box.lastChild)box.removeChild(box.lastChild); addChatMsg('user',data.user_text||'🎤',box); addChatMsg('ai',data.ai_text,box); if(data.audio_url)new Audio(data.audio_url).play().catch(()=>{});}catch(e){addChatMsg('ai','Error.',box);}
    };
    clubMediaRecorder.start();
    document.getElementById('club-mic-btn').querySelector('.material-symbols-outlined').style.color='#ef4444';
  } catch(e){alert('Нужен HTTPS и разрешения для микрофона');}
}
function stopClubRecording(e) {
  e.preventDefault();
  document.getElementById('club-mic-btn').querySelector('.material-symbols-outlined').style.color='';
  if(clubMediaRecorder?.state!=='inactive')clubMediaRecorder.stop();
  clubStreamRef?.getTracks().forEach(t=>t.stop()); clubStreamRef=null;
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
      <button onclick="showLangSettings()" class="w-full py-3 bg-surface-container text-on-surface-variant font-label font-bold text-sm rounded-xl hover:bg-surface-container-high transition-colors">
        ⚙️ Настройки языка
      </button>`;
  } catch(e){ c.innerHTML='<p class="text-error text-center py-8">Ошибка загрузки</p>'; }
}

// ── НАСТРОЙКИ ЯЗЫКА ──
function showLangSettings() {
  const html=`
    <div class="bg-surface-container-lowest border border-surface-variant rounded-2xl p-4 mb-4">
      <h3 class="font-headline font-bold text-on-surface mb-3">Язык изучения</h3>
      <div class="grid grid-cols-2 gap-2">
        ${[['en','🇬🇧','Английский'],['de','🇩🇪','Немецкий'],['fr','🇫🇷','Французский'],['es','🇪🇸','Испанский'],['it','🇮🇹','Итальянский'],['zh','🇨🇳','Китайский']].map(([l,f,n])=>`<button onclick="setLangTarget('${l}')" data-tgt="${l}" class="ls-tgt p-3 border-2 ${userTargetLang===l?'border-primary-container bg-surface-container-low':'border-surface-variant'} rounded-xl text-center text-sm font-label hover:border-primary transition-colors"><div class="text-2xl">${f}</div><div class="font-bold text-on-surface">${n}</div></button>`).join('')}
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
    document.getElementById('ls-status').textContent='✅ Сохранено!';
    setTimeout(loadProfile,1000);
  } catch(e){document.getElementById('ls-status').textContent='Ошибка';}
}

// ── ОНБОРДИНГ ──
function obSelectTarget(lang) {
  obTarget=lang;
  document.querySelectorAll('.ob-lang').forEach(b=>{const a=b.dataset.lang===lang;b.classList.toggle('border-primary-container',a);b.classList.toggle('border-surface-variant',!a);});
  setTimeout(()=>{document.getElementById('ob-step-0').classList.add('hidden');document.getElementById('ob-step-1').classList.remove('hidden');document.querySelectorAll('.ob-native').forEach(b=>{b.classList.toggle('hidden',b.dataset.lang===lang);});},280);
}
function obSelectNative(lang) {
  obNative=lang;
  setTimeout(()=>{document.getElementById('ob-step-1').classList.add('hidden');document.getElementById('ob-step-2').classList.remove('hidden');},280);
}
function obSelectLevel(level) {
  obLevel=level;
  document.getElementById('ob-step-2').classList.add('hidden');
  document.getElementById('ob-ready-msg').textContent=`Язык: ${obTarget.toUpperCase()}, уровень ${level}`;
  document.getElementById('ob-step-3').classList.remove('hidden');
}
async function finishOnboarding() {
  try {
    await fetch('/api/onboarding/complete',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),level:obLevel,goal:'general',native_language:obNative,target_language:obTarget})});
    userNativeLang=obNative; userTargetLang=obTarget; currentLevel=obLevel;
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
  document.getElementById('popup-add-btn').disabled=false;
  document.getElementById('popup-add-btn').textContent='+ В мой словарь';
  showWordPopup();
  try {
    const data=await(await fetch('/api/dictionary/translate',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:parseInt(userId),word,context_sentence:ctx.substring(0,300),native_language:userNativeLang,target_language:userTargetLang})})).json();
    if(data.status==='success'){
      document.getElementById('popup-transcription').textContent=data.transcription||'';
      document.getElementById('popup-translation').textContent=data.translation||'—';
      document.getElementById('popup-example').textContent=data.context_example?`"${data.context_example}"`:'';}
    else document.getElementById('popup-translation').textContent=data.message||'Ошибка';
  } catch(e){document.getElementById('popup-translation').textContent='Ошибка соединения';}
}
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
window.onload = () => {
  const savedId = localStorage.getItem('t2l_user_id');
  if (savedId && parseInt(savedId) > 0) {
    userId = parseInt(savedId);
    userEmail = localStorage.getItem('t2l_email') || '';
    initApp();
  }
};
