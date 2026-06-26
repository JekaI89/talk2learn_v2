const UI_TRANSLATIONS = {
  ru: {
    nav_home:'Главная', nav_dictionary:'Словарь', nav_notebook:'Мой блокнот',
    nav_club:'Разговорный клуб', nav_situations:'Ситуации', nav_profile:'Профиль',
    nav_logout:'Выйти', nav_admin:'Админ-панель', mob_club:'Клуб',
    placeholder_club:'Напишите сообщение...',
    welcome_title:'Добро пожаловать! 👋', welcome_sub:'Выберите раздел для занятия',
  },
  en: {
    nav_home:'Home', nav_dictionary:'Dictionary', nav_notebook:'My Word Book',
    nav_club:'Speaking Club', nav_situations:'Situations', nav_profile:'Profile',
    nav_logout:'Logout', nav_admin:'Admin Panel', mob_club:'Club',
    placeholder_club:'Type a message...',
    welcome_title:'Welcome! 👋', welcome_sub:'Choose a section to study',
  },
  de: {
    nav_home:'Startseite', nav_dictionary:'Wörterbuch', nav_notebook:'Mein Vokabular',
    nav_club:'Sprechclub', nav_situations:'Situationen', nav_profile:'Profil',
    nav_logout:'Abmelden', nav_admin:'Admin-Panel', mob_club:'Club',
    placeholder_club:'Nachricht eingeben...',
    welcome_title:'Willkommen! 👋', welcome_sub:'Wähle einen Lernbereich',
  },
  fr: {
    nav_home:'Accueil', nav_dictionary:'Dictionnaire', nav_notebook:'Mon carnet',
    nav_club:'Club de parole', nav_situations:'Situations', nav_profile:'Profil',
    nav_logout:'Déconnexion', nav_admin:'Panneau admin', mob_club:'Club',
    placeholder_club:'Écrire un message...',
    welcome_title:'Bienvenue ! 👋', welcome_sub:'Choisissez une section',
  },
  es: {
    nav_home:'Inicio', nav_dictionary:'Diccionario', nav_notebook:'Mi libreta',
    nav_club:'Club de habla', nav_situations:'Situaciones', nav_profile:'Perfil',
    nav_logout:'Salir', nav_admin:'Panel admin', mob_club:'Club',
    placeholder_club:'Escribe un mensaje...',
    welcome_title:'¡Bienvenido! 👋', welcome_sub:'Elige una sección para estudiar',
  },
  it: {
    nav_home:'Home', nav_dictionary:'Dizionario', nav_notebook:'Il mio taccuino',
    nav_club:'Club di parola', nav_situations:'Situazioni', nav_profile:'Profilo',
    nav_logout:'Esci', nav_admin:'Pannello admin', mob_club:'Club',
    placeholder_club:'Scrivi un messaggio...',
    welcome_title:'Benvenuto! 👋', welcome_sub:'Scegli una sezione',
  },
  zh: {
    nav_home:'首页', nav_dictionary:'词汇', nav_notebook:'我的单词本',
    nav_club:'AI对话俱乐部', nav_situations:'情景对话', nav_profile:'我的资料',
    nav_logout:'退出', nav_admin:'管理面板', mob_club:'俱乐部',
    placeholder_club:'输入消息...',
    welcome_title:'欢迎！👋', welcome_sub:'选择学习模块',
  },
  ja: {
    nav_home:'ホーム', nav_dictionary:'辞書', nav_notebook:'単語帳',
    nav_club:'スピーキングクラブ', nav_situations:'シチュエーション', nav_profile:'プロフィール',
    nav_logout:'ログアウト', nav_admin:'管理パネル', mob_club:'クラブ',
    placeholder_club:'メッセージを入力...',
    welcome_title:'ようこそ！👋', welcome_sub:'学習セクションを選んでください',
  },
  pt: {
    nav_home:'Início', nav_dictionary:'Dicionário', nav_notebook:'Meu caderno',
    nav_club:'Clube de fala', nav_situations:'Situações', nav_profile:'Perfil',
    nav_logout:'Sair', nav_admin:'Painel admin', mob_club:'Clube',
    placeholder_club:'Escreva uma mensagem...',
    welcome_title:'Bem-vindo! 👋', welcome_sub:'Escolha uma seção para estudar',
  },
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
