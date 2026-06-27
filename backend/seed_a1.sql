-- Seed: 10 уроков A1 + 30 вопросов
-- Идемпотентен: не вставляет если урок с таким title+level уже есть
-- Запуск в Render Shell:
--   psql $DATABASE_URL -f seed_a1.sql

DO $$
DECLARE
  lid INTEGER;
BEGIN

  -- 1. Алфавит и произношение
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Алфавит и произношение' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Алфавит и произношение',
'🔤 <b>The English Alphabet</b>

В английском языке 26 букв. Произносятся они иначе, чем пишутся.

<b>Гласные (Vowels):</b> A, E, I, O, U
<b>Согласные (Consonants):</b> все остальные 21 буква

<b>Полезные слова для запоминания букв:</b>
• A — Apple 🍎
• B — Book 📚
• C — Cat 🐱
• D — Dog 🐶
• E — Egg 🥚
• F — Fish 🐟

<b>Буквы, которые читаются неожиданно:</b>
• W читается как «дабл-ю»
• Y читается как «вай»
• G читается как «джи»
• H читается как «эйч»

💡 <b>Совет:</b> Учите алфавит песенкой — это самый быстрый способ!',
'lesson',1,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','How many letters are in the English alphabet?','24','26','28',2,1),
      (lid,'A1','multiple_choice','Which of these is a vowel?','B','C','E',3,2),
      (lid,'A1','multiple_choice','How do you say the letter W in English?','Ви','Дабл-ю','Ву',2,3);
    RAISE NOTICE 'Добавлен: Алфавит и произношение';
  ELSE RAISE NOTICE 'Пропущен: Алфавит и произношение';
  END IF;

  -- 2. Приветствия и прощания
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Приветствия и прощания' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Приветствия и прощания',
'👋 <b>Greetings & Goodbyes</b>

<b>Как поздороваться:</b>
• Hello! — Привет! / Здравствуйте!
• Hi! — Привет! (неформально)
• Good morning! — Доброе утро! (до 12:00)
• Good afternoon! — Добрый день! (12:00–18:00)
• Good evening! — Добрый вечер! (после 18:00)

<b>Как ответить:</b>
• How are you? — Как дела?
• I''m fine, thanks! — Я в порядке, спасибо!
• I''m great! — Отлично!
• Not bad. — Неплохо.

<b>Как попрощаться:</b>
• Goodbye! / Bye! — До свидания! / Пока!
• See you later! — До встречи!
• Good night! — Спокойной ночи!
• Take care! — Береги себя!

💡 <b>Совет:</b> «Good night» говорят только перед сном, не как приветствие вечером!',
'lesson',2,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','What do you say in the morning?','Good night!','Good morning!','Goodbye!',2,1),
      (lid,'A1','multiple_choice','How do you say Как дела? in English?','What is your name?','Where are you?','How are you?',3,2),
      (lid,'A1','multiple_choice','Which phrase means До встречи?','See you later!','Good evening!','Take care!',1,3);
    RAISE NOTICE 'Добавлен: Приветствия и прощания';
  ELSE RAISE NOTICE 'Пропущен: Приветствия и прощания';
  END IF;

  -- 3. Местоимения
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Местоимения: I, You, He, She' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Местоимения: I, You, He, She',
'🙋 <b>Personal Pronouns</b>

<b>Личные местоимения:</b>
• I — Я
• You — Ты / Вы
• He — Он
• She — Она
• It — Оно (для предметов и животных)
• We — Мы
• They — Они

<b>Примеры:</b>
• I am a student. — Я студент.
• She is my friend. — Она моя подруга.
• He is tall. — Он высокий.
• We are happy. — Мы счастливы.
• They are from Russia. — Они из России.

<b>Важно!</b>
• «I» всегда пишется с большой буквы.
• «You» используется и для одного человека, и для группы.
• «It» — для животных, когда пол неважен, и для предметов.

💡 <b>Совет:</b> Замените имена в предложениях на местоимения — это лучшая тренировка!',
'lesson',3,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','What is the pronoun for Она?','He','It','She',3,1),
      (lid,'A1','multiple_choice','Fill in: ___ am a student.','He','I','They',2,2),
      (lid,'A1','multiple_choice','Which pronoun do we use for objects?','She','He','It',3,3);
    RAISE NOTICE 'Добавлен: Местоимения';
  ELSE RAISE NOTICE 'Пропущен: Местоимения';
  END IF;

  -- 4. Глагол TO BE
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Глагол TO BE: am, is, are' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Глагол TO BE: am, is, are',
'✅ <b>The verb TO BE</b>

«To be» — самый важный глагол в английском. Означает «быть / являться».

<b>Формы глагола:</b>
• I <b>am</b> — Я есть
• You <b>are</b> — Ты есть
• He / She / It <b>is</b> — Он/Она/Оно есть
• We / They <b>are</b> — Мы/Они есть

<b>Утвердительные:</b>
• I am a teacher. — Я учитель.
• She is beautiful. — Она красивая.
• We are friends. — Мы друзья.

<b>Отрицательные (NOT):</b>
• I am not tired. — Я не устал.
• He is not here. — Его здесь нет.

<b>Вопросительные:</b>
• Are you happy? — Ты счастлив?
• Is she at home? — Она дома?

💡 <b>Совет:</b> Сокращения: I''m, you''re, he''s, she''s, it''s, we''re, they''re',
'lesson',4,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','Fill in: She ___ my sister.','am','are','is',3,1),
      (lid,'A1','multiple_choice','Which is correct?','I is happy.','I am happy.','I are happy.',2,2),
      (lid,'A1','multiple_choice','How do you make negative with TO BE?','Add DO NOT','Add NOT after to be','Change word order',2,3);
    RAISE NOTICE 'Добавлен: TO BE';
  ELSE RAISE NOTICE 'Пропущен: TO BE';
  END IF;

  -- 5. Числа 1-20
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Числа от 1 до 20' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Числа от 1 до 20',
'🔢 <b>Numbers 1–20</b>

<b>1–10:</b>
1-one, 2-two, 3-three, 4-four, 5-five
6-six, 7-seven, 8-eight, 9-nine, 10-ten

<b>11–20:</b>
11-eleven, 12-twelve, 13-thirteen, 14-fourteen, 15-fifteen
16-sixteen, 17-seventeen, 18-eighteen, 19-nineteen, 20-twenty

<b>Обратите внимание:</b>
• 11 и 12 — особые слова, не по правилу
• 13–19: добавляем -teen
• После 20: twenty-one, twenty-two...

<b>В жизни:</b>
• I have two cats. — У меня два кота.
• She is fifteen years old. — Ей пятнадцать лет.

💡 <b>Совет:</b> Не путайте 13 (thirteen) и 30 (thirty) — разница в ударении!',
'lesson',5,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','How do you write the number 15?','Fifty','Fifteen','Five',2,1),
      (lid,'A1','multiple_choice','What comes after eleven?','Thirteen','Twenty','Twelve',3,2),
      (lid,'A1','multiple_choice','How do you say 8 in English?','Eighty','Eight','Eighteen',2,3);
    RAISE NOTICE 'Добавлен: Числа 1-20';
  ELSE RAISE NOTICE 'Пропущен: Числа 1-20';
  END IF;

  -- 6. Цвета
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Цвета' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Цвета',
'🎨 <b>Colours</b>

<b>Основные цвета:</b>
• red — красный 🔴
• blue — синий 🔵
• yellow — жёлтый 🟡
• green — зелёный 🟢
• orange — оранжевый 🟠
• purple — фиолетовый 🟣
• pink — розовый 🩷
• white — белый ⚪
• black — чёрный ⚫
• grey — серый 🩶
• brown — коричневый 🟤

<b>Прилагательное стоит ПЕРЕД существительным:</b>
• a red car — красная машина
• a blue sky — голубое небо

<b>Вопрос о цвете:</b>
• What colour is it? — Какого это цвета?

💡 <b>Совет:</b> «color» (США) и «colour» (Британия) — оба варианта верны!',
'lesson',6,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','What colour is the sky usually?','Red','Blue','Green',2,1),
      (lid,'A1','multiple_choice','How do you say красный in English?','Pink','Orange','Red',3,2),
      (lid,'A1','multiple_choice','Where does an adjective go in English?','After the noun','Before the noun','At the end',2,3);
    RAISE NOTICE 'Добавлен: Цвета';
  ELSE RAISE NOTICE 'Пропущен: Цвета';
  END IF;

  -- 7. Дни и месяцы
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Дни недели и месяцы' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Дни недели и месяцы',
'📅 <b>Days & Months</b>

<b>Дни недели:</b>
• Monday — Понедельник
• Tuesday — Вторник
• Wednesday — Среда
• Thursday — Четверг
• Friday — Пятница
• Saturday — Суббота
• Sunday — Воскресенье

<b>Месяцы:</b>
January, February, March, April, May, June,
July, August, September, October, November, December

<b>Правила:</b>
• Дни и месяцы — всегда с БОЛЬШОЙ буквы
• Weekdays — будние (Mon–Fri), Weekend — выходные (Sat–Sun)

<b>Примеры:</b>
• Today is Monday. — Сегодня понедельник.
• My birthday is in July. — Мой день рождения в июле.

💡 <b>Совет:</b> «on» — с днями, «in» — с месяцами!',
'lesson',7,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','Which day comes after Tuesday?','Monday','Thursday','Wednesday',3,1),
      (lid,'A1','multiple_choice','What is the 6th month of the year?','July','May','June',3,2),
      (lid,'A1','multiple_choice','Which preposition with days? ___ Monday','in','at','on',3,3);
    RAISE NOTICE 'Добавлен: Дни и месяцы';
  ELSE RAISE NOTICE 'Пропущен: Дни и месяцы';
  END IF;

  -- 8. Семья
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Семья: members of the family' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Семья: members of the family',
'👨‍👩‍👧‍👦 <b>Family Members</b>

<b>Ближайшая семья:</b>
• mother / mum — мама
• father / dad — папа
• sister — сестра
• brother — брат
• son — сын
• daughter — дочь
• parents — родители
• children — дети

<b>Расширенная семья:</b>
• grandmother / grandma — бабушка
• grandfather / grandpa — дедушка
• aunt — тётя
• uncle — дядя
• cousin — двоюродный брат/сестра
• wife — жена
• husband — муж

<b>Примеры:</b>
• I have one sister and two brothers.
• My mother is a doctor.

💡 <b>Совет:</b> «Cousin» — это и брат, и сестра. Контекст подскажет пол!',
'lesson',8,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','What is мама in English?','Sister','Mother','Daughter',2,1),
      (lid,'A1','multiple_choice','How do you say дядя?','Uncle','Cousin','Brother',1,2),
      (lid,'A1','multiple_choice','Which word means двоюродный брат and сестра?','Sibling','Cousin','Relative',2,3);
    RAISE NOTICE 'Добавлен: Семья';
  ELSE RAISE NOTICE 'Пропущен: Семья';
  END IF;

  -- 9. Вопросительные слова
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Простые вопросы: What, Where, Who' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Простые вопросы: What, Where, Who',
'❓ <b>Question Words</b>

<b>Вопросительные слова:</b>
• What? — Что? / Какой?
• Where? — Где? / Куда?
• Who? — Кто?
• When? — Когда?
• How? — Как?
• Why? — Почему?
• How much? — Сколько? (неисчисляемое)
• How many? — Сколько? (исчисляемое)

<b>Примеры:</b>
• What is your name? — Как вас зовут?
• Where are you from? — Откуда вы?
• Who is she? — Кто она?
• When is your birthday? — Когда ваш день рождения?

<b>Ответы:</b>
• My name is Anna.
• I am from Russia.

💡 <b>Совет:</b> Вопросительное слово всегда в НАЧАЛЕ вопроса!',
'lesson',9,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','Which word asks about a place?','Who','What','Where',3,1),
      (lid,'A1','multiple_choice','What is your ___? — what fits?','From','Name','Are',2,2),
      (lid,'A1','multiple_choice','Which word means Кто?','When','Who','Why',2,3);
    RAISE NOTICE 'Добавлен: Вопросительные слова';
  ELSE RAISE NOTICE 'Пропущен: Вопросительные слова';
  END IF;

  -- 10. Present Simple
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Present Simple: повседневные действия' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Present Simple: повседневные действия',
'⏰ <b>Present Simple Tense</b>

Present Simple — для регулярных действий и фактов.

<b>Структура:</b>
• I / You / We / They + глагол
• He / She / It + глагол + <b>-s</b>

<b>Примеры:</b>
• I wake up at 7 AM. — Я просыпаюсь в 7 утра.
• She drinks coffee every morning.
• They play football on Sundays.

<b>Отрицание (don''t / doesn''t):</b>
• I don''t eat meat. — Я не ем мясо.
• He doesn''t like Mondays.

<b>Вопрос (Do / Does):</b>
• Do you speak English?
• Does she work here?

<b>Маркеры времени:</b>
every day, always, usually, often, sometimes, never

💡 <b>Совет:</b> he/she/it → добавляй -s: work→works, play→plays!',
'lesson',10,TRUE,'en');
    lid := lastval();
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','Fill in: She ___ coffee every day.','drink','drinks','drinking',2,1),
      (lid,'A1','multiple_choice','Which is the correct negative form?','I not like it.','I doesn''t like it.','I don''t like it.',3,2),
      (lid,'A1','multiple_choice','Which word is a time marker for Present Simple?','Yesterday','Now','Always',3,3);
    RAISE NOTICE 'Добавлен: Present Simple';
  ELSE RAISE NOTICE 'Пропущен: Present Simple';
  END IF;

END $$;
