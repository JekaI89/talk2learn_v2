-- Questions for A1 lessons ids 61-117 (5 per lesson)
-- Idempotent: skips if questions already exist for a lesson

-- 61: Артикли: a, an, the
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=61)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(61,'A1','multiple_choice','Which article is correct: "___ umbrella"?','an','a','the',1,1),
(61,'A1','multiple_choice','Which article is correct: "___ book"?','a','an','the',1,2),
(61,'A1','multiple_choice','Which article is correct: "___ sun rises in the east."','The','A','An',1,3),
(61,'A1','multiple_choice','Which article is correct: "She is ___ honest person."','an','a','the',1,4),
(61,'A1','multiple_choice','Which article is correct: "I want ___ coffee, please."','a','an','the',1,5);
END IF; END $$;

-- 62: Числа от 20 до 1000
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=62)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(62,'A1','multiple_choice','How do you say 35 in English?','thirty-five','three-five','thirty five',1,1),
(62,'A1','multiple_choice','How do you say 100 in English?','a hundred','one-hundred','ten zero',1,2),
(62,'A1','multiple_choice','How do you say 500 in English?','five hundred','five-hundred','fifty hundred',1,3),
(62,'A1','multiple_choice','How do you say 48 in English?','forty-eight','four-eight','fourteen-eight',1,4),
(62,'A1','multiple_choice','How do you say 1000 in English?','a thousand','ten hundred','one-thousand',1,5);
END IF; END $$;

-- 63: Время: который час?
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=63)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(63,'What time is it? (3:00)','It is three o''clock','It is three hours','It is at three','option_1','multiple_choice',1),
(63,'What time is it? (7:30)','It is half past seven','It is seven thirty past','It is half seven o''clock','option_1','multiple_choice',2),
(63,'A1','multiple_choice','What time is it? (4:15)','It is quarter past four','It is four and fifteen','It is quarter to four',1,3),
(63,'A1','multiple_choice','What time is it? (9:45)','It is quarter to ten','It is quarter past nine','It is nine forty five past',1,4),
(63,'A1','multiple_choice','How do you ask the time?','What time is it?','What is the hour?','How much is the time?',1,5);
END IF; END $$;

-- 64: Еда и напитки
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=64)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(64,'A1','multiple_choice','Which word means "хлеб"?','bread','milk','egg',1,1),
(64,'A1','multiple_choice','Which word means "вода"?','water','juice','tea',1,2),
(64,'A1','multiple_choice','Which word means "яблоко"?','apple','orange','banana',1,3),
(64,'A1','multiple_choice','Which word means "мясо"?','meat','fish','cheese',1,4),
(64,'A1','multiple_choice','Which word means "сок"?','juice','coffee','soup',1,5);
END IF; END $$;

-- 65: Части тела
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=65)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(65,'A1','multiple_choice','Which word means "рука"?','hand','leg','foot',1,1),
(65,'A1','multiple_choice','Which word means "глаза"?','eyes','ears','nose',1,2),
(65,'A1','multiple_choice','Which word means "нога"?','leg','arm','back',1,3),
(65,'A1','multiple_choice','Which word means "рот"?','mouth','head','neck',1,4),
(65,'A1','multiple_choice','Which word means "плечо"?','shoulder','knee','elbow',1,5);
END IF; END $$;

-- 66: Погода
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=66)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(66,'A1','multiple_choice','Which word means "солнечно"?','sunny','cloudy','rainy',1,1),
(66,'A1','multiple_choice','Which word means "дождь"?','rain','snow','wind',1,2),
(66,'A1','multiple_choice','How do you say "Сегодня холодно"?','It is cold today','Today is coldly','The weather cold',1,3),
(66,'A1','multiple_choice','Which word means "ветрено"?','windy','foggy','stormy',1,4),
(66,'A1','multiple_choice','How do you ask about weather?','What is the weather like?','How is weather doing?','What weather is today like?',1,5);
END IF; END $$;

-- 67: Дом и комнаты
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=67)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(67,'A1','multiple_choice','Which word means "кухня"?','kitchen','bedroom','bathroom',1,1),
(67,'A1','multiple_choice','Which word means "спальня"?','bedroom','living room','kitchen',1,2),
(67,'A1','multiple_choice','Which word means "окно"?','window','door','wall',1,3),
(67,'A1','multiple_choice','Which word means "диван"?','sofa','table','chair',1,4),
(67,'A1','multiple_choice','Which word means "гостиная"?','living room','dining room','bedroom',1,5);
END IF; END $$;

-- 68: Профессии
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=68)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(68,'A1','multiple_choice','Which word means "учитель"?','teacher','doctor','driver',1,1),
(68,'A1','multiple_choice','Which word means "врач"?','doctor','nurse','engineer',1,2),
(68,'A1','multiple_choice','Which word means "повар"?','cook','waiter','baker',1,3),
(68,'A1','multiple_choice','Which word means "полицейский"?','police officer','firefighter','soldier',1,4),
(68,'A1','multiple_choice','Which word means "водитель"?','driver','pilot','sailor',1,5);
END IF; END $$;

-- 69: Транспорт
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=69)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(69,'A1','multiple_choice','Which word means "автобус"?','bus','train','tram',1,1),
(69,'A1','multiple_choice','Which word means "самолёт"?','plane','ship','bus',1,2),
(69,'A1','multiple_choice','Which word means "велосипед"?','bicycle','motorcycle','scooter',1,3),
(69,'A1','multiple_choice','How do you say "Я еду на метро"?','I take the metro','I go with metro','I drive the metro',1,4),
(69,'A1','multiple_choice','Which word means "такси"?','taxi','bus','tram',1,5);
END IF; END $$;

-- 70: В магазине: покупки
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=70)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(70,'A1','multiple_choice','How do you say "Сколько это стоит?"','How much is it?','What is the price of it?','How many does it cost?',1,1),
(70,'A1','multiple_choice','How do you say "Я хочу купить..."','I would like to buy...','I want buying...','I like to bought...',1,2),
(70,'A1','multiple_choice','Which word means "дёшево"?','cheap','expensive','free',1,3),
(70,'A1','multiple_choice','Which word means "касса"?','cashier','shelf','basket',1,4),
(70,'A1','multiple_choice','How do you say "У вас есть...?"','Do you have...?','Have you got any...?','Is there a...?',1,5);
END IF; END $$;

-- 71: Семья и друзья
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=71)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(71,'A1','multiple_choice','Which word means "тётя"?','aunt','uncle','cousin',1,1),
(71,'A1','multiple_choice','Which word means "племянник"?','nephew','niece','grandson',1,2),
(71,'A1','multiple_choice','How do you say "Это мой лучший друг"?','He is my best friend','He is my good friend','He is mine best friend',1,3),
(71,'A1','multiple_choice','Which word means "дедушка"?','grandfather','grandmother','father',1,4),
(71,'A1','multiple_choice','Which word means "двоюродный брат"?','cousin','brother','nephew',1,5);
END IF; END $$;

-- 72: Хобби и свободное время
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=72)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(72,'A1','multiple_choice','How do you say "Я люблю читать"?','I like reading','I like to read books','I enjoy the reading',1,1),
(72,'A1','multiple_choice','Which word means "рисовать"?','draw','paint','colour',1,2),
(72,'A1','multiple_choice','Which word means "плавание"?','swimming','running','cycling',1,3),
(72,'A1','multiple_choice','How do you say "В свободное время я играю в футбол"?','In my free time I play football','In free time I playing football','In my free time I am play football',1,4),
(72,'A1','multiple_choice','Which word means "готовить (еду)"?','cook','bake','fry',1,5);
END IF; END $$;

-- 73: Одежда
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=73)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(73,'A1','multiple_choice','Which word means "рубашка"?','shirt','skirt','shorts',1,1),
(73,'A1','multiple_choice','Which word means "пальто"?','coat','jacket','vest',1,2),
(73,'A1','multiple_choice','How do you say "Я ношу джинсы"?','I wear jeans','I am wearing a jeans','I put on jeans',1,3),
(73,'A1','multiple_choice','Which word means "кроссовки"?','trainers','boots','sandals',1,4),
(73,'A1','multiple_choice','Which word means "платье"?','dress','skirt','blouse',1,5);
END IF; END $$;

-- 74: В городе: направления
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=74)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(74,'A1','multiple_choice','How do you say "Повернуть налево"?','Turn left','Go left','Take the left',1,1),
(74,'A1','multiple_choice','How do you say "Идите прямо"?','Go straight ahead','Walk the straight','Move forward please',1,2),
(74,'A1','multiple_choice','Which phrase means "Где находится...?"','Where is...?','What is the place of...?','How to find...?',1,3),
(74,'A1','multiple_choice','How do you say "Повернуть направо"?','Turn right','Go right way','Take right road',1,4),
(74,'A1','multiple_choice','Which word means "перекрёсток"?','crossroads','corner','roundabout',1,5);
END IF; END $$;

-- 75: Ежедневная рутина
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=75)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(75,'A1','multiple_choice','How do you say "Я просыпаюсь в 7 утра"?','I wake up at 7 a.m.','I wake at 7 in morning','I woke up at 7 a.m.',1,1),
(75,'A1','multiple_choice','Which phrase means "чистить зубы"?','brush my teeth','wash my teeth','clean my teeth',1,2),
(75,'A1','multiple_choice','How do you say "Я иду в школу"?','I go to school','I am going school','I walk at school',1,3),
(75,'A1','multiple_choice','Which phrase means "ложиться спать"?','go to bed','go to sleep early','put to bed',1,4),
(75,'A1','multiple_choice','How do you say "Я завтракаю"?','I have breakfast','I eat the breakfast','I make a breakfast',1,5);
END IF; END $$;

-- 76: Здоровье и самочувствие
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=76)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(76,'A1','multiple_choice','How do you say "У меня болит голова"?','I have a headache','My head is hurting','I have headache',1,1),
(76,'How do you say "Я плохо себя чувствую"?','I feel ill','I am feeling bad','I don''t feel well doing','option_1','multiple_choice',2),
(76,'A1','multiple_choice','Which word means "температура (жар)"?','fever','cold','flu',1,3),
(76,'A1','multiple_choice','How do you say "Мне нужно к врачу"?','I need to see a doctor','I must go doctor','I should visit the medicine',1,4),
(76,'A1','multiple_choice','Which word means "кашель"?','cough','sneeze','sore throat',1,5);
END IF; END $$;

-- 77: В кафе и ресторане
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=77)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(77,'A1','multiple_choice','How do you say "Можно меню?"',Can I have a menu, please?,Give me a menu please,I want to see menu,1,1),
(77,'A1','multiple_choice','How do you say "Я хочу заказать..."','I would like to order...','I want ordering...','Can I order me...',1,2),
(77,'A1','multiple_choice','Which phrase means "Счёт, пожалуйста"?',The bill, please,I want pay now,Check for me please,1,3),
(77,'A1','multiple_choice','Which word means "официант"?','waiter','cashier','manager',1,4),
(77,'A1','multiple_choice','How do you say "Это было вкусно"?','It was delicious','It is very tasty','That were good',1,5);
END IF; END $$;

-- 78: Past Simple: was / were
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=78)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(78,'A1','multiple_choice','Choose the correct form: "She ___ at home yesterday."','was','were','is',1,1),
(78,'A1','multiple_choice','Choose the correct form: "They ___ happy."','were','was','are',1,2),
(78,'A1','multiple_choice','Choose the correct form: "I ___ very tired."','was','were','am',1,3),
(78,'A1','multiple_choice','Choose the correct negative: "He ___ not at school."','was','were','is',1,4),
(78,'A1','multiple_choice','Choose the question form: "___ you at home?"','Were','Was','Are',1,5);
END IF; END $$;

-- 79: Be going to — планы
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=79)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(79,'A1','multiple_choice','Choose the correct form: "I ___ going to travel next summer."','am','is','are',1,1),
(79,'A1','multiple_choice','Choose the correct form: "She ___ going to call you."','is','am','are',1,2),
(79,'A1','multiple_choice','How do you say "Мы планируем посетить Лондон"?','We are going to visit London','We going visit London','We will going to London',1,3),
(79,'A1','multiple_choice','Choose the question form: "___ he going to play?"','Is','Are','Am',1,4),
(79,'A1','multiple_choice','Choose the negative: "They ___ not going to come."','are','is','am',1,5);
END IF; END $$;

-- 80: Прилагательные (описание)
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=80)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(80,'A1','multiple_choice','Which word means "красивый"?','beautiful','ugly','strange',1,1),
(80,'A1','multiple_choice','Which word means "высокий"?','tall','short','slim',1,2),
(80,'A1','multiple_choice','Which word means "умный"?','intelligent','kind','brave',1,3),
(80,'A1','multiple_choice','Where does an adjective go in English?','Before the noun','After the noun','At the end of the sentence',1,4),
(80,'A1','multiple_choice','Which word means "старый"?','old','young','new',1,5);
END IF; END $$;

-- 81: There is / There are
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=81)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(81,'A1','multiple_choice','Choose correct: "___ a cat on the roof."','There is','There are','There has',1,1),
(81,'A1','multiple_choice','Choose correct: "___ two books on the table."','There are','There is','There has',1,2),
(81,'A1','multiple_choice','Choose the question: "___ a problem?"','Is there','Are there','Has there',1,3),
(81,'Choose the negative: "There ___ any milk."','isn''t','aren''t','hasn''t','option_1','multiple_choice',4),
(81,'A1','multiple_choice','Choose correct: "___ many students in the class."','There are','There is','It is',1,5);
END IF; END $$;

-- 82: Путешествия
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=82)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(82,'A1','multiple_choice','Which word means "паспорт"?','passport','ticket','visa',1,1),
(82,'A1','multiple_choice','Which word means "чемодан"?','suitcase','backpack','bag',1,2),
(82,'A1','multiple_choice','How do you say "Я хочу забронировать номер"?','I would like to book a room','I want reserve a room','I need booking a room',1,3),
(82,'A1','multiple_choice','Which word means "аэропорт"?','airport','station','port',1,4),
(82,'A1','multiple_choice','Which word means "путешественник"?','traveller','tourist','visitor',1,5);
END IF; END $$;

-- 83: Работа и профессии
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=83)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(83,'A1','multiple_choice','How do you say "Где вы работаете?"','Where do you work?','Where are you working at?','What is your work place?',1,1),
(83,'A1','multiple_choice','Which word means "офис"?','office','factory','shop',1,2),
(83,'A1','multiple_choice','Which word means "зарплата"?','salary','bonus','tax',1,3),
(83,'A1','multiple_choice','How do you say "Я работаю в банке"?','I work in a bank','I am working at bank','I work at the bank office',1,4),
(83,'A1','multiple_choice','Which word means "коллега"?','colleague','boss','employee',1,5);
END IF; END $$;

-- 84: Праздники и традиции
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=84)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(84,'A1','multiple_choice','How do you say "С Новым годом!"','Happy New Year!','Good New Year!','Nice New Year!',1,1),
(84,'A1','multiple_choice','Which word means "подарок"?','gift','card','decoration',1,2),
(84,'A1','multiple_choice','How do you say "С днём рождения!"','Happy Birthday!','Good Birthday!','Nice Birthday!',1,3),
(84,'A1','multiple_choice','Which word means "праздновать"?','celebrate','decorate','invite',1,4),
(84,'A1','multiple_choice','Which word means "вечеринка"?','party','festival','ceremony',1,5);
END IF; END $$;

-- 85: Сравнения (Comparatives)
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=85)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(85,'A1','multiple_choice','Choose the comparative: "big"','bigger','more big','biger',1,1),
(85,'A1','multiple_choice','Choose the superlative: "tall"','the tallest','most tall','the most tall',1,2),
(85,'A1','multiple_choice','Choose the comparative: "interesting"','more interesting','interestinger','most interesting',1,3),
(85,'A1','multiple_choice','Choose correct: "She is ___ than her brother."','taller','more tall','tallest',1,4),
(85,'A1','multiple_choice','Choose the superlative: "good"','the best','the most good','the goodest',1,5);
END IF; END $$;

-- 86: Can / Can't
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=86)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(86,'A1','multiple_choice','Choose correct: "She ___ speak English well."','can','cans','is can',1,1),
(86,'Choose correct: "He ___ swim — he never learned."','can''t','doesn''t can','isn''t can','option_1','multiple_choice',2),
(86,'A1','multiple_choice','How do you say "Ты умеешь играть на гитаре?"','Can you play the guitar?','Do you can play guitar?','Are you able playing guitar?',1,3),
(86,'A1','multiple_choice','Choose correct: "I ___ help you with that."','can','could to','am able',1,4),
(86,'Which is the negative form of "can"?','can''t / cannot','don''t can','am not can','option_1','multiple_choice',5);
END IF; END $$;

-- 87: Предлоги места и времени
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=87)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(87,'A1','multiple_choice','Choose correct: "The book is ___ the table."','on','in','at',1,1),
(87,'A1','multiple_choice','Choose correct: "She lives ___ London."','in','on','at',1,2),
(87,'A1','multiple_choice','Choose correct: "I wake up ___ 7 o''clock."','at','in','on',1,3),
(87,'A1','multiple_choice','Choose correct: "I was born ___ Monday."','on','in','at',1,4),
(87,'A1','multiple_choice','Choose correct: "The cat is ___ the box."','inside','on','at',1,5);
END IF; END $$;

-- 88: This / That / These / Those
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=88)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(88,'A1','multiple_choice','Which is used for one object that is NEAR?','this','that','these',1,1),
(88,'A1','multiple_choice','Which is used for one object that is FAR?','that','this','those',1,2),
(88,'A1','multiple_choice','Which is used for MANY objects that are NEAR?','these','those','this',1,3),
(88,'A1','multiple_choice','Choose correct: "___ are my friends over there."','Those','These','That',1,4),
(88,'A1','multiple_choice','Choose correct: "___ is my pen here."','This','That','These',1,5);
END IF; END $$;

-- 89: Люблю / Не люблю
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=89)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(89,'A1','multiple_choice','How do you say "Я люблю музыку"?','I love music','I am loving music','I like the music very',1,1),
(89,'How do you say "Мне не нравятся фильмы ужасов"?','I don''t like horror films','I am not liking horror films','I dislike the horror films','option_1','multiple_choice',2),
(89,'A1','multiple_choice','Which phrase means strong preference?','I love','I like','I enjoy',1,3),
(89,'How do you say "Мне всё равно"?','I don''t mind','I don''t care about it','It is same for me','option_1','multiple_choice',4),
(89,'A1','multiple_choice','How do you say "Я обожаю шоколад"?','I adore chocolate','I love very much chocolate','I extremely like chocolate',1,5);
END IF; END $$;

-- 90: Present Simple — повторение
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=90)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(90,'A1','multiple_choice','Choose correct: "She ___ English every day."','studies','study','is studying',1,1),
(90,'A1','multiple_choice','Choose correct: "They ___ to school on Mondays."','go','goes','going',1,2),
(90,'Choose the negative: "He ___ like coffee."','doesn''t','don''t','isn''t','option_1','multiple_choice',3),
(90,'A1','multiple_choice','Choose the question: "___ you speak French?"','Do','Does','Are',1,4),
(90,'A1','multiple_choice','Choose correct: "She ___ a cat."','has','have','is having',1,5);
END IF; END $$;

-- 91: Большое повторение A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=91)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(91,'A1','multiple_choice','Choose correct: "I ___ a student."','am','is','are',1,1),
(91,'A1','multiple_choice','Choose correct: "There ___ three cats in the garden."','are','is','has',1,2),
(91,'A1','multiple_choice','Choose correct: "She can ___ very fast."','run','runs','running',1,3),
(91,'A1','multiple_choice','Choose correct article: "___ elephant is big."','An','A','The',1,4),
(91,'A1','multiple_choice','Choose correct: "They ___ going to travel tomorrow."','are','is','am',1,5);
END IF; END $$;

-- 92: Притяжательные местоимения
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=92)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(92,'A1','multiple_choice','Which is the possessive pronoun for "I"?','my','me','mine',1,1),
(92,'A1','multiple_choice','Which is the possessive pronoun for "she"?','her','she','hers',1,2),
(92,'A1','multiple_choice','Which is the possessive pronoun for "they"?','their','them','theirs',1,3),
(92,'A1','multiple_choice','Choose correct: "___ name is Anna."','Her','She','Hers',1,4),
(92,'A1','multiple_choice','Choose correct: "This is ___ book." (I)','my','me','mine',1,5);
END IF; END $$;

-- 93: Some / Any
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=93)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(93,'A1','multiple_choice','Choose correct: "I have ___ milk."','some','any','a',1,1),
(93,'A1','multiple_choice','Choose correct: "Do you have ___ questions?"','any','some','a',1,2),
(93,'A1','multiple_choice','Choose correct: "There isn''t ___ coffee left."','any','some','no',1,3),
(93,'A1','multiple_choice','Choose correct: "Would you like ___ tea?"','some','any','a',1,4),
(93,'A1','multiple_choice','Choose correct: "I don''t have ___ money."','any','some','the',1,5);
END IF; END $$;

-- 94: Much / Many / A lot of
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=94)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(94,'A1','multiple_choice','Choose correct: "How ___ water do you drink?"','much','many','lots',1,1),
(94,'A1','multiple_choice','Choose correct: "How ___ people are there?"','many','much','lot',1,2),
(94,'A1','multiple_choice','Choose correct: "She has ___ friends."','a lot of','much','many a',1,3),
(94,'A1','multiple_choice','Choose correct: "There isn''t ___ time left."','much','many','a lot',1,4),
(94,'A1','multiple_choice','Which word is used with COUNTABLE nouns?','many','much','less',1,5);
END IF; END $$;

-- 95: Объектные местоимения
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=95)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(95,'A1','multiple_choice','What is the object pronoun for "I"?','me','my','mine',1,1),
(95,'A1','multiple_choice','What is the object pronoun for "he"?','him','his','he',1,2),
(95,'A1','multiple_choice','What is the object pronoun for "they"?','them','their','theirs',1,3),
(95,'A1','multiple_choice','Choose correct: "Give ___ the book." (she)','her','she','hers',1,4),
(95,'A1','multiple_choice','Choose correct: "I can help ___." (you)','you','your','yours',1,5);
END IF; END $$;

-- 96: Итоговое повторение A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=96)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(96,'A1','multiple_choice','Choose correct: "She ___ to school every day."','goes','go','is going',1,1),
(96,'A1','multiple_choice','Choose correct: "___ you like coffee?"','Do','Does','Are',1,2),
(96,'A1','multiple_choice','Choose the superlative: "fast"','the fastest','more fast','most fastest',1,3),
(96,'A1','multiple_choice','Choose correct: "There ___ a lot of people."','are','is','were',1,4),
(96,'A1','multiple_choice','Choose correct: "I ___ born in 1995."','was','were','am',1,5);
END IF; END $$;

-- 97: Модальные глаголы: Can, Should, Must
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=97)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(97,'A1','multiple_choice','Which modal verb expresses obligation?','must','can','should',1,1),
(97,'A1','multiple_choice','Which modal verb gives advice?','should','must','can',1,2),
(97,'A1','multiple_choice','Choose correct: "You ___ see a doctor."','should','must to','can to',1,3),
(97,'A1','multiple_choice','Choose correct: "Students ___ wear uniforms." (obligation)','must','should','can',1,4),
(97,'A1','multiple_choice','Choose correct: "___ I open the window?"','Can','Should','Must',1,5);
END IF; END $$;

-- 98: Наречия частотности
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=98)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(98,'A1','multiple_choice','Which adverb means "всегда"?','always','never','sometimes',1,1),
(98,'A1','multiple_choice','Which adverb means "никогда"?','never','always','usually',1,2),
(98,'A1','multiple_choice','Where does the adverb of frequency go?','Before the main verb','After the main verb','At the end',1,3),
(98,'A1','multiple_choice','Choose correct: "She ___ drinks coffee."','always','is always','always is',1,4),
(98,'A1','multiple_choice','Which adverb means "иногда"?','sometimes','rarely','often',1,5);
END IF; END $$;

-- 99: Числа и цены (углубление)
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=99)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(99,'A1','multiple_choice','How do you say "£5.99"?','five pounds ninety-nine','five point nine nine pounds','five and ninety-nine',1,1),
(99,'A1','multiple_choice','How do you say "½"?','a half','one two','zero five',1,2),
(99,'A1','multiple_choice','How do you ask the price?','How much does it cost?','What is the cost of price?','How many it cost?',1,3),
(99,'A1','multiple_choice','How do you say "¼"?','a quarter','one fourth','zero twenty five',1,4),
(99,'A1','multiple_choice','How do you say "$20.50"?','twenty dollars fifty','twenty point fifty dollars','twenty and fifty cents dollars',1,5);
END IF; END $$;

-- 100: Подготовка к итоговому тесту A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=100)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(100,'A1','multiple_choice','Choose correct: "He ___ at work right now."','is','are','am',1,1),
(100,'A1','multiple_choice','Choose correct article: "___ orange."','an','a','the',1,2),
(100,'A1','multiple_choice','Choose correct: "They ___ watching TV yesterday."','were','was','are',1,3),
(100,'A1','multiple_choice','Choose correct: "She ___ a car." (has/have)','has','have','is having',1,4),
(100,'A1','multiple_choice','Choose correct: "Can you ___ English?"','speak','speaks','speaking',1,5);
END IF; END $$;

-- 101: Переход к уровню A2
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=101)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(101,'A1','multiple_choice','Which tense describes completed past actions?','Past Simple','Present Simple','Past Continuous',1,1),
(101,'A1','multiple_choice','At A2 level, which grammar is introduced?','Comparatives and conditionals','Only present tenses','Only articles',1,2),
(101,'A1','multiple_choice','Choose correct: "I ___ to Paris last year."','went','go','have gone',1,3),
(101,'A1','multiple_choice','Choose the comparative: "expensive"','more expensive','expensiver','most expensive',1,4),
(101,'A1','multiple_choice','Choose correct: "She ___ been to London." (Present Perfect)','has','have','had',1,5);
END IF; END $$;

-- 102: Погода — углубление
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=102)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(102,'A1','multiple_choice','Which word means "гроза"?','thunderstorm','heavy rain','strong wind',1,1),
(102,'A1','multiple_choice','Which word means "туман"?','fog','mist','cloud',1,2),
(102,'A1','multiple_choice','How do you say "температура минус 5"?','minus five degrees','five below','negative five temperature',1,3),
(102,'A1','multiple_choice','Which word means "влажный"?','humid','wet','damp',1,4),
(102,'A1','multiple_choice','How do you say "Ожидается дождь"?','Rain is expected','It will be raining maybe','Rain is coming soon',1,5);
END IF; END $$;

-- 103: Время суток и расписание
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=103)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(103,'A1','multiple_choice','Which phrase means "утром"?','in the morning','at morning','on the morning',1,1),
(103,'A1','multiple_choice','Which phrase means "вечером"?','in the evening','at evening','on evening',1,2),
(103,'A1','multiple_choice','How do you say "в полдень"?','at noon','in noon','on the noon',1,3),
(103,'A1','multiple_choice','How do you say "в полночь"?','at midnight','in the midnight','on midnight',1,4),
(103,'A1','multiple_choice','Which word means "расписание"?','schedule','timetable','calendar',1,5);
END IF; END $$;

-- 104: Еда и предпочтения
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=104)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(104,'A1','multiple_choice','How do you say "Я предпочитаю рыбу мясу"?','I prefer fish to meat','I prefer fish than meat','I like more fish than meat',1,1),
(104,'A1','multiple_choice','Which word means "острый (о еде)"?','spicy','sour','bitter',1,2),
(104,'A1','multiple_choice','Which word means "сладкий"?','sweet','salty','spicy',1,3),
(104,'How do you say "Я вегетарианец"?','I am a vegetarian','I don''t eat meat','I eat only vegetables','option_1','multiple_choice',4),
(104,'A1','multiple_choice','Which word means "блюдо (в меню)"?','dish','plate','food',1,5);
END IF; END $$;

-- 105: Семья — описание
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=105)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(105,'A1','multiple_choice','How do you say "Мой отец высокий и добрый"?','My father is tall and kind','My father is tall and kindly','My father are tall and kind',1,1),
(105,'A1','multiple_choice','Which word means "единственный ребёнок"?','only child','single child','one child',1,2),
(105,'A1','multiple_choice','How do you describe a family with many children?','large family','big family','great family',1,3),
(105,'A1','multiple_choice','Which word means "близкий (о родственниках)"?','close','near','tight',1,4),
(105,'A1','multiple_choice','How do you say "Моя мама работает медсестрой"?','My mum works as a nurse','My mum is working like nurse','My mum works a nurse',1,5);
END IF; END $$;

-- 106: Заключительный обзор A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=106)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(106,'A1','multiple_choice','Choose correct: "I ___ to the cinema last weekend."','went','go','have gone',1,1),
(106,'A1','multiple_choice','Choose correct: "___ there any eggs?"','Are','Is','Has',1,2),
(106,'A1','multiple_choice','Choose correct: "She ___ her homework every evening."','does','do','is doing',1,3),
(106,'A1','multiple_choice','Choose the comparative: "bad"','worse','more bad','badder',1,4),
(106,'Choose correct: "You ___ be quiet in the library."','must','can''t','should to','option_1','multiple_choice',5);
END IF; END $$;

-- 107: Внешность и характер
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=107)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(107,'A1','multiple_choice','Which word means "вьющиеся волосы"?','curly hair','wavy hair','straight hair',1,1),
(107,'A1','multiple_choice','Which word means "щедрый"?','generous','kind','honest',1,2),
(107,'A1','multiple_choice','How do you describe someone who is "весёлый"?','cheerful','happy','joyful',1,3),
(107,'A1','multiple_choice','Which word means "лысый"?','bald','bold','bare',1,4),
(107,'A1','multiple_choice','Which word means "надёжный"?','reliable','honest','loyal',1,5);
END IF; END $$;

-- 108: Дом и интерьер
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=108)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(108,'A1','multiple_choice','Which word means "занавески"?','curtains','blinds','shutters',1,1),
(108,'A1','multiple_choice','Which word means "ковёр"?','carpet','rug','mat',1,2),
(108,'A1','multiple_choice','How do you say "переехать в новый дом"?','move into a new house','move to new home','change to new house',1,3),
(108,'A1','multiple_choice','Which word means "чердак"?','attic','basement','cellar',1,4),
(108,'A1','multiple_choice','Which word means "подвал"?','basement','attic','garage',1,5);
END IF; END $$;

-- 109: Покупки — углубление
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=109)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(109,'A1','multiple_choice','How do you say "Могу я примерить это?"','Can I try this on?','Can I try this?','May I try it?',1,1),
(109,'A1','multiple_choice','Which word means "скидка"?','discount','sale','offer',1,2),
(109,'A1','multiple_choice','How do you say "Это слишком дорого"?','It is too expensive','It is very costly','That costs too many',1,3),
(109,'A1','multiple_choice','Which word means "квитанция"?','receipt','invoice','bill',1,4),
(109,'A1','multiple_choice','How do you say "Есть ли у вас это в другом размере?"','Do you have this in another size?','Have you this in other size?','Is there another size of this?',1,5);
END IF; END $$;

-- 110: Транспорт — углубление
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=110)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(110,'A1','multiple_choice','How do you say "Где ближайшая остановка автобуса?"','Where is the nearest bus stop?','Where is the bus stop near?','What is the closest bus stop?',1,1),
(110,'A1','multiple_choice','Which word means "пробка (на дороге)"?','traffic jam','road block','car queue',1,2),
(110,'A1','multiple_choice','How do you say "Купить билет в одну сторону"?','buy a single ticket','buy a one-way ticket','buy a single way ticket',1,3),
(110,'A1','multiple_choice','Which word means "пересадка"?','transfer','change','connection',1,4),
(110,'A1','multiple_choice','How do you say "Это поезд до Лондона?"','Is this the train to London?','Is this train for London?','Does this train go London?',1,5);
END IF; END $$;

-- 111: Завершение уровня A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=111)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(111,'A1','multiple_choice','Which level comes after A1?','A2','B1','A0',1,1),
(111,'A1','multiple_choice','Choose correct: "She ___ lived here for 3 years." (Present Perfect)','has','have','had',1,2),
(111,'A1','multiple_choice','Choose correct: "I ___ my keys." (Past Simple)','lost','lose','have lost',1,3),
(111,'A1','multiple_choice','Choose correct comparative: "This film is ___ than that one." (boring)','more boring','boringer','most boring',1,4),
(111,'A1','multiple_choice','Choose correct: "You ___ eat more vegetables."','should','must to','can to',1,5);
END IF; END $$;

-- 112: Природа и животные
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=112)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(112,'A1','multiple_choice','Which word means "лес"?','forest','jungle','wood',1,1),
(112,'A1','multiple_choice','Which word means "река"?','river','lake','stream',1,2),
(112,'A1','multiple_choice','Which word means "лев"?','lion','tiger','leopard',1,3),
(112,'A1','multiple_choice','Which word means "орёл"?','eagle','hawk','owl',1,4),
(112,'A1','multiple_choice','Which word means "бабочка"?','butterfly','dragonfly','beetle',1,5);
END IF; END $$;

-- 113: Цвета и формы
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=113)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(113,'A1','multiple_choice','Which word means "квадрат"?','square','circle','triangle',1,1),
(113,'A1','multiple_choice','Which word means "фиолетовый"?','purple','pink','orange',1,2),
(113,'A1','multiple_choice','Which word means "прямоугольник"?','rectangle','square','oval',1,3),
(113,'A1','multiple_choice','Which word means "серый"?','grey','brown','beige',1,4),
(113,'A1','multiple_choice','Which word means "треугольник"?','triangle','diamond','star',1,5);
END IF; END $$;

-- 114: Письмо и email
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=114)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(114,'A1','multiple_choice','How do you start a formal letter?',Dear Sir/Madam,,Hello there,,Hey,,1,1),
(114,'A1','multiple_choice','How do you end a formal letter?',Yours sincerely,,Best wishes,,Goodbye,,1,2),
(114,'A1','multiple_choice','Which word means "тема письма"?','subject','title','topic',1,3),
(114,'A1','multiple_choice','How do you say "Прикрепляю файл"?','I am attaching a file','I am adding a file','I put the file here',1,4),
(114,'A1','multiple_choice','Which phrase opens an informal email to a friend?',Hi [name],,Dear [name],,Hello Mr/Ms [name],,1,5);
END IF; END $$;

-- 115: Праздники и подарки
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=115)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(115,'A1','multiple_choice','How do you say "С Рождеством!"','Merry Christmas!','Happy Christmas!','Good Christmas!',1,1),
(115,'A1','multiple_choice','Which word means "украшение"?','decoration','ornament','design',1,2),
(115,'A1','multiple_choice','How do you say "Я дарю тебе подарок"?','I am giving you a present','I give you a gift now','I am gifting to you',1,3),
(115,'A1','multiple_choice','Which word means "открытка"?','card','note','letter',1,4),
(115,'A1','multiple_choice','How do you say "Поздравляю!"','Congratulations!','Celebrations!','Happy wishes!',1,5);
END IF; END $$;

-- 116: Ты молодец! Итог A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=116)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(116,'A1','multiple_choice','What does A1 level mean?','Beginner level of English','Elementary English','Pre-intermediate English',1,1),
(116,'A1','multiple_choice','Choose correct: "She ___ English every day." (habit)','studies','is studying','studied',1,2),
(116,'A1','multiple_choice','Choose correct article: "___ best book I read."','The','A','An',1,3),
(116,'A1','multiple_choice','Choose correct: "There ___ some water in the bottle."','is','are','has',1,4),
(116,'A1','multiple_choice','Choose correct: "They ___ playing when I arrived."','were','was','are',1,5);
END IF; END $$;

-- 117: Итоговый урок — Завершение A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=117)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(117,'A1','multiple_choice','Choose correct: "I ___ my friend yesterday."','met','meet','have met',1,1),
(117,'A1','multiple_choice','Choose correct: "She ___ to music every evening."','listens','listen','is listen',1,2),
(117,'A1','multiple_choice','Choose the superlative: "good"','the best','the most good','the goodest',1,3),
(117,'A1','multiple_choice','Choose correct: "___ you ever been to London?"','Have','Has','Did',1,4),
(117,'A1','multiple_choice','Choose correct: "They ___ very happy about the news."','were','was','are',1,5);
END IF; END $$;
