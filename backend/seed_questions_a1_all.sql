-- Questions for A1 lessons ids 61-117 (5 per lesson)
-- Idempotent: skips if questions already exist for a lesson

-- 61: Артикли: a, an, the
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=61)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(61,'Which article is correct: "___ umbrella"?','an','a','the','option_1','multiple_choice',1),
(61,'Which article is correct: "___ book"?','a','an','the','option_1','multiple_choice',2),
(61,'Which article is correct: "___ sun rises in the east."','The','A','An','option_1','multiple_choice',3),
(61,'Which article is correct: "She is ___ honest person."','an','a','the','option_1','multiple_choice',4),
(61,'Which article is correct: "I want ___ coffee, please."','a','an','the','option_1','multiple_choice',5);
END IF; END $$;

-- 62: Числа от 20 до 1000
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=62)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(62,'How do you say 35 in English?','thirty-five','three-five','thirty five','option_1','multiple_choice',1),
(62,'How do you say 100 in English?','a hundred','one-hundred','ten zero','option_1','multiple_choice',2),
(62,'How do you say 500 in English?','five hundred','five-hundred','fifty hundred','option_1','multiple_choice',3),
(62,'How do you say 48 in English?','forty-eight','four-eight','fourteen-eight','option_1','multiple_choice',4),
(62,'How do you say 1000 in English?','a thousand','ten hundred','one-thousand','option_1','multiple_choice',5);
END IF; END $$;

-- 63: Время: который час?
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=63)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(63,'What time is it? (3:00)','It is three o''clock','It is three hours','It is at three','option_1','multiple_choice',1),
(63,'What time is it? (7:30)','It is half past seven','It is seven thirty past','It is half seven o''clock','option_1','multiple_choice',2),
(63,'What time is it? (4:15)','It is quarter past four','It is four and fifteen','It is quarter to four','option_1','multiple_choice',3),
(63,'What time is it? (9:45)','It is quarter to ten','It is quarter past nine','It is nine forty five past','option_1','multiple_choice',4),
(63,'How do you ask the time?','What time is it?','What is the hour?','How much is the time?','option_1','multiple_choice',5);
END IF; END $$;

-- 64: Еда и напитки
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=64)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(64,'Which word means "хлеб"?','bread','milk','egg','option_1','multiple_choice',1),
(64,'Which word means "вода"?','water','juice','tea','option_1','multiple_choice',2),
(64,'Which word means "яблоко"?','apple','orange','banana','option_1','multiple_choice',3),
(64,'Which word means "мясо"?','meat','fish','cheese','option_1','multiple_choice',4),
(64,'Which word means "сок"?','juice','coffee','soup','option_1','multiple_choice',5);
END IF; END $$;

-- 65: Части тела
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=65)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(65,'Which word means "рука"?','hand','leg','foot','option_1','multiple_choice',1),
(65,'Which word means "глаза"?','eyes','ears','nose','option_1','multiple_choice',2),
(65,'Which word means "нога"?','leg','arm','back','option_1','multiple_choice',3),
(65,'Which word means "рот"?','mouth','head','neck','option_1','multiple_choice',4),
(65,'Which word means "плечо"?','shoulder','knee','elbow','option_1','multiple_choice',5);
END IF; END $$;

-- 66: Погода
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=66)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(66,'Which word means "солнечно"?','sunny','cloudy','rainy','option_1','multiple_choice',1),
(66,'Which word means "дождь"?','rain','snow','wind','option_1','multiple_choice',2),
(66,'How do you say "Сегодня холодно"?','It is cold today','Today is coldly','The weather cold','option_1','multiple_choice',3),
(66,'Which word means "ветрено"?','windy','foggy','stormy','option_1','multiple_choice',4),
(66,'How do you ask about weather?','What is the weather like?','How is weather doing?','What weather is today like?','option_1','multiple_choice',5);
END IF; END $$;

-- 67: Дом и комнаты
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=67)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(67,'Which word means "кухня"?','kitchen','bedroom','bathroom','option_1','multiple_choice',1),
(67,'Which word means "спальня"?','bedroom','living room','kitchen','option_1','multiple_choice',2),
(67,'Which word means "окно"?','window','door','wall','option_1','multiple_choice',3),
(67,'Which word means "диван"?','sofa','table','chair','option_1','multiple_choice',4),
(67,'Which word means "гостиная"?','living room','dining room','bedroom','option_1','multiple_choice',5);
END IF; END $$;

-- 68: Профессии
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=68)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(68,'Which word means "учитель"?','teacher','doctor','driver','option_1','multiple_choice',1),
(68,'Which word means "врач"?','doctor','nurse','engineer','option_1','multiple_choice',2),
(68,'Which word means "повар"?','cook','waiter','baker','option_1','multiple_choice',3),
(68,'Which word means "полицейский"?','police officer','firefighter','soldier','option_1','multiple_choice',4),
(68,'Which word means "водитель"?','driver','pilot','sailor','option_1','multiple_choice',5);
END IF; END $$;

-- 69: Транспорт
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=69)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(69,'Which word means "автобус"?','bus','train','tram','option_1','multiple_choice',1),
(69,'Which word means "самолёт"?','plane','ship','bus','option_1','multiple_choice',2),
(69,'Which word means "велосипед"?','bicycle','motorcycle','scooter','option_1','multiple_choice',3),
(69,'How do you say "Я еду на метро"?','I take the metro','I go with metro','I drive the metro','option_1','multiple_choice',4),
(69,'Which word means "такси"?','taxi','bus','tram','option_1','multiple_choice',5);
END IF; END $$;

-- 70: В магазине: покупки
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=70)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(70,'How do you say "Сколько это стоит?"','How much is it?','What is the price of it?','How many does it cost?','option_1','multiple_choice',1),
(70,'How do you say "Я хочу купить..."','I would like to buy...','I want buying...','I like to bought...','option_1','multiple_choice',2),
(70,'Which word means "дёшево"?','cheap','expensive','free','option_1','multiple_choice',3),
(70,'Which word means "касса"?','cashier','shelf','basket','option_1','multiple_choice',4),
(70,'How do you say "У вас есть...?"','Do you have...?','Have you got any...?','Is there a...?','option_1','multiple_choice',5);
END IF; END $$;

-- 71: Семья и друзья
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=71)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(71,'Which word means "тётя"?','aunt','uncle','cousin','option_1','multiple_choice',1),
(71,'Which word means "племянник"?','nephew','niece','grandson','option_1','multiple_choice',2),
(71,'How do you say "Это мой лучший друг"?','He is my best friend','He is my good friend','He is mine best friend','option_1','multiple_choice',3),
(71,'Which word means "дедушка"?','grandfather','grandmother','father','option_1','multiple_choice',4),
(71,'Which word means "двоюродный брат"?','cousin','brother','nephew','option_1','multiple_choice',5);
END IF; END $$;

-- 72: Хобби и свободное время
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=72)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(72,'How do you say "Я люблю читать"?','I like reading','I like to read books','I enjoy the reading','option_1','multiple_choice',1),
(72,'Which word means "рисовать"?','draw','paint','colour','option_1','multiple_choice',2),
(72,'Which word means "плавание"?','swimming','running','cycling','option_1','multiple_choice',3),
(72,'How do you say "В свободное время я играю в футбол"?','In my free time I play football','In free time I playing football','In my free time I am play football','option_1','multiple_choice',4),
(72,'Which word means "готовить (еду)"?','cook','bake','fry','option_1','multiple_choice',5);
END IF; END $$;

-- 73: Одежда
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=73)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(73,'Which word means "рубашка"?','shirt','skirt','shorts','option_1','multiple_choice',1),
(73,'Which word means "пальто"?','coat','jacket','vest','option_1','multiple_choice',2),
(73,'How do you say "Я ношу джинсы"?','I wear jeans','I am wearing a jeans','I put on jeans','option_1','multiple_choice',3),
(73,'Which word means "кроссовки"?','trainers','boots','sandals','option_1','multiple_choice',4),
(73,'Which word means "платье"?','dress','skirt','blouse','option_1','multiple_choice',5);
END IF; END $$;

-- 74: В городе: направления
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=74)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(74,'How do you say "Повернуть налево"?','Turn left','Go left','Take the left','option_1','multiple_choice',1),
(74,'How do you say "Идите прямо"?','Go straight ahead','Walk the straight','Move forward please','option_1','multiple_choice',2),
(74,'Which phrase means "Где находится...?"','Where is...?','What is the place of...?','How to find...?','option_1','multiple_choice',3),
(74,'How do you say "Повернуть направо"?','Turn right','Go right way','Take right road','option_1','multiple_choice',4),
(74,'Which word means "перекрёсток"?','crossroads','corner','roundabout','option_1','multiple_choice',5);
END IF; END $$;

-- 75: Ежедневная рутина
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=75)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(75,'How do you say "Я просыпаюсь в 7 утра"?','I wake up at 7 a.m.','I wake at 7 in morning','I woke up at 7 a.m.','option_1','multiple_choice',1),
(75,'Which phrase means "чистить зубы"?','brush my teeth','wash my teeth','clean my teeth','option_1','multiple_choice',2),
(75,'How do you say "Я иду в школу"?','I go to school','I am going school','I walk at school','option_1','multiple_choice',3),
(75,'Which phrase means "ложиться спать"?','go to bed','go to sleep early','put to bed','option_1','multiple_choice',4),
(75,'How do you say "Я завтракаю"?','I have breakfast','I eat the breakfast','I make a breakfast','option_1','multiple_choice',5);
END IF; END $$;

-- 76: Здоровье и самочувствие
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=76)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(76,'How do you say "У меня болит голова"?','I have a headache','My head is hurting','I have headache','option_1','multiple_choice',1),
(76,'How do you say "Я плохо себя чувствую"?','I feel ill','I am feeling bad','I don''t feel well doing','option_1','multiple_choice',2),
(76,'Which word means "температура (жар)"?','fever','cold','flu','option_1','multiple_choice',3),
(76,'How do you say "Мне нужно к врачу"?','I need to see a doctor','I must go doctor','I should visit the medicine','option_1','multiple_choice',4),
(76,'Which word means "кашель"?','cough','sneeze','sore throat','option_1','multiple_choice',5);
END IF; END $$;

-- 77: В кафе и ресторане
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=77)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(77,'How do you say "Можно меню?"','Can I have a menu, please?','Give me a menu please','I want to see menu','option_1','multiple_choice',1),
(77,'How do you say "Я хочу заказать..."','I would like to order...','I want ordering...','Can I order me...','option_1','multiple_choice',2),
(77,'Which phrase means "Счёт, пожалуйста"?','The bill, please','I want pay now','Check for me please','option_1','multiple_choice',3),
(77,'Which word means "официант"?','waiter','cashier','manager','option_1','multiple_choice',4),
(77,'How do you say "Это было вкусно"?','It was delicious','It is very tasty','That were good','option_1','multiple_choice',5);
END IF; END $$;

-- 78: Past Simple: was / were
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=78)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(78,'Choose the correct form: "She ___ at home yesterday."','was','were','is','option_1','multiple_choice',1),
(78,'Choose the correct form: "They ___ happy."','were','was','are','option_1','multiple_choice',2),
(78,'Choose the correct form: "I ___ very tired."','was','were','am','option_1','multiple_choice',3),
(78,'Choose the correct negative: "He ___ not at school."','was','were','is','option_1','multiple_choice',4),
(78,'Choose the question form: "___ you at home?"','Were','Was','Are','option_1','multiple_choice',5);
END IF; END $$;

-- 79: Be going to — планы
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=79)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(79,'Choose the correct form: "I ___ going to travel next summer."','am','is','are','option_1','multiple_choice',1),
(79,'Choose the correct form: "She ___ going to call you."','is','am','are','option_1','multiple_choice',2),
(79,'How do you say "Мы планируем посетить Лондон"?','We are going to visit London','We going visit London','We will going to London','option_1','multiple_choice',3),
(79,'Choose the question form: "___ he going to play?"','Is','Are','Am','option_1','multiple_choice',4),
(79,'Choose the negative: "They ___ not going to come."','are','is','am','option_1','multiple_choice',5);
END IF; END $$;

-- 80: Прилагательные (описание)
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=80)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(80,'Which word means "красивый"?','beautiful','ugly','strange','option_1','multiple_choice',1),
(80,'Which word means "высокий"?','tall','short','slim','option_1','multiple_choice',2),
(80,'Which word means "умный"?','intelligent','kind','brave','option_1','multiple_choice',3),
(80,'Where does an adjective go in English?','Before the noun','After the noun','At the end of the sentence','option_1','multiple_choice',4),
(80,'Which word means "старый"?','old','young','new','option_1','multiple_choice',5);
END IF; END $$;

-- 81: There is / There are
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=81)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(81,'Choose correct: "___ a cat on the roof."','There is','There are','There has','option_1','multiple_choice',1),
(81,'Choose correct: "___ two books on the table."','There are','There is','There has','option_1','multiple_choice',2),
(81,'Choose the question: "___ a problem?"','Is there','Are there','Has there','option_1','multiple_choice',3),
(81,'Choose the negative: "There ___ any milk."','isn''t','aren''t','hasn''t','option_1','multiple_choice',4),
(81,'Choose correct: "___ many students in the class."','There are','There is','It is','option_1','multiple_choice',5);
END IF; END $$;

-- 82: Путешествия
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=82)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(82,'Which word means "паспорт"?','passport','ticket','visa','option_1','multiple_choice',1),
(82,'Which word means "чемодан"?','suitcase','backpack','bag','option_1','multiple_choice',2),
(82,'How do you say "Я хочу забронировать номер"?','I would like to book a room','I want reserve a room','I need booking a room','option_1','multiple_choice',3),
(82,'Which word means "аэропорт"?','airport','station','port','option_1','multiple_choice',4),
(82,'Which word means "путешественник"?','traveller','tourist','visitor','option_1','multiple_choice',5);
END IF; END $$;

-- 83: Работа и профессии
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=83)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(83,'How do you say "Где вы работаете?"','Where do you work?','Where are you working at?','What is your work place?','option_1','multiple_choice',1),
(83,'Which word means "офис"?','office','factory','shop','option_1','multiple_choice',2),
(83,'Which word means "зарплата"?','salary','bonus','tax','option_1','multiple_choice',3),
(83,'How do you say "Я работаю в банке"?','I work in a bank','I am working at bank','I work at the bank office','option_1','multiple_choice',4),
(83,'Which word means "коллега"?','colleague','boss','employee','option_1','multiple_choice',5);
END IF; END $$;

-- 84: Праздники и традиции
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=84)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(84,'How do you say "С Новым годом!"','Happy New Year!','Good New Year!','Nice New Year!','option_1','multiple_choice',1),
(84,'Which word means "подарок"?','gift','card','decoration','option_1','multiple_choice',2),
(84,'How do you say "С днём рождения!"','Happy Birthday!','Good Birthday!','Nice Birthday!','option_1','multiple_choice',3),
(84,'Which word means "праздновать"?','celebrate','decorate','invite','option_1','multiple_choice',4),
(84,'Which word means "вечеринка"?','party','festival','ceremony','option_1','multiple_choice',5);
END IF; END $$;

-- 85: Сравнения (Comparatives)
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=85)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(85,'Choose the comparative: "big"','bigger','more big','biger','option_1','multiple_choice',1),
(85,'Choose the superlative: "tall"','the tallest','most tall','the most tall','option_1','multiple_choice',2),
(85,'Choose the comparative: "interesting"','more interesting','interestinger','most interesting','option_1','multiple_choice',3),
(85,'Choose correct: "She is ___ than her brother."','taller','more tall','tallest','option_1','multiple_choice',4),
(85,'Choose the superlative: "good"','the best','the most good','the goodest','option_1','multiple_choice',5);
END IF; END $$;

-- 86: Can / Can't
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=86)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(86,'Choose correct: "She ___ speak English well."','can','cans','is can','option_1','multiple_choice',1),
(86,'Choose correct: "He ___ swim — he never learned."','can''t','doesn''t can','isn''t can','option_1','multiple_choice',2),
(86,'How do you say "Ты умеешь играть на гитаре?"','Can you play the guitar?','Do you can play guitar?','Are you able playing guitar?','option_1','multiple_choice',3),
(86,'Choose correct: "I ___ help you with that."','can','could to','am able','option_1','multiple_choice',4),
(86,'Which is the negative form of "can"?','can''t / cannot','don''t can','am not can','option_1','multiple_choice',5);
END IF; END $$;

-- 87: Предлоги места и времени
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=87)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(87,'Choose correct: "The book is ___ the table."','on','in','at','option_1','multiple_choice',1),
(87,'Choose correct: "She lives ___ London."','in','on','at','option_1','multiple_choice',2),
(87,'Choose correct: "I wake up ___ 7 o''clock."','at','in','on','option_1','multiple_choice',3),
(87,'Choose correct: "I was born ___ Monday."','on','in','at','option_1','multiple_choice',4),
(87,'Choose correct: "The cat is ___ the box."','inside','on','at','option_1','multiple_choice',5);
END IF; END $$;

-- 88: This / That / These / Those
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=88)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(88,'Which is used for one object that is NEAR?','this','that','these','option_1','multiple_choice',1),
(88,'Which is used for one object that is FAR?','that','this','those','option_1','multiple_choice',2),
(88,'Which is used for MANY objects that are NEAR?','these','those','this','option_1','multiple_choice',3),
(88,'Choose correct: "___ are my friends over there."','Those','These','That','option_1','multiple_choice',4),
(88,'Choose correct: "___ is my pen here."','This','That','These','option_1','multiple_choice',5);
END IF; END $$;

-- 89: Люблю / Не люблю
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=89)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(89,'How do you say "Я люблю музыку"?','I love music','I am loving music','I like the music very','option_1','multiple_choice',1),
(89,'How do you say "Мне не нравятся фильмы ужасов"?','I don''t like horror films','I am not liking horror films','I dislike the horror films','option_1','multiple_choice',2),
(89,'Which phrase means strong preference?','I love','I like','I enjoy','option_1','multiple_choice',3),
(89,'How do you say "Мне всё равно"?','I don''t mind','I don''t care about it','It is same for me','option_1','multiple_choice',4),
(89,'How do you say "Я обожаю шоколад"?','I adore chocolate','I love very much chocolate','I extremely like chocolate','option_1','multiple_choice',5);
END IF; END $$;

-- 90: Present Simple — повторение
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=90)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(90,'Choose correct: "She ___ English every day."','studies','study','is studying','option_1','multiple_choice',1),
(90,'Choose correct: "They ___ to school on Mondays."','go','goes','going','option_1','multiple_choice',2),
(90,'Choose the negative: "He ___ like coffee."','doesn''t','don''t','isn''t','option_1','multiple_choice',3),
(90,'Choose the question: "___ you speak French?"','Do','Does','Are','option_1','multiple_choice',4),
(90,'Choose correct: "She ___ a cat."','has','have','is having','option_1','multiple_choice',5);
END IF; END $$;

-- 91: Большое повторение A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=91)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(91,'Choose correct: "I ___ a student."','am','is','are','option_1','multiple_choice',1),
(91,'Choose correct: "There ___ three cats in the garden."','are','is','has','option_1','multiple_choice',2),
(91,'Choose correct: "She can ___ very fast."','run','runs','running','option_1','multiple_choice',3),
(91,'Choose correct article: "___ elephant is big."','An','A','The','option_1','multiple_choice',4),
(91,'Choose correct: "They ___ going to travel tomorrow."','are','is','am','option_1','multiple_choice',5);
END IF; END $$;

-- 92: Притяжательные местоимения
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=92)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(92,'Which is the possessive pronoun for "I"?','my','me','mine','option_1','multiple_choice',1),
(92,'Which is the possessive pronoun for "she"?','her','she','hers','option_1','multiple_choice',2),
(92,'Which is the possessive pronoun for "they"?','their','them','theirs','option_1','multiple_choice',3),
(92,'Choose correct: "___ name is Anna."','Her','She','Hers','option_1','multiple_choice',4),
(92,'Choose correct: "This is ___ book." (I)','my','me','mine','option_1','multiple_choice',5);
END IF; END $$;

-- 93: Some / Any
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=93)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(93,'Choose correct: "I have ___ milk."','some','any','a','option_1','multiple_choice',1),
(93,'Choose correct: "Do you have ___ questions?"','any','some','a','option_1','multiple_choice',2),
(93,'Choose correct: "There isn''t ___ coffee left."','any','some','no','option_1','multiple_choice',3),
(93,'Choose correct: "Would you like ___ tea?"','some','any','a','option_1','multiple_choice',4),
(93,'Choose correct: "I don''t have ___ money."','any','some','the','option_1','multiple_choice',5);
END IF; END $$;

-- 94: Much / Many / A lot of
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=94)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(94,'Choose correct: "How ___ water do you drink?"','much','many','lots','option_1','multiple_choice',1),
(94,'Choose correct: "How ___ people are there?"','many','much','lot','option_1','multiple_choice',2),
(94,'Choose correct: "She has ___ friends."','a lot of','much','many a','option_1','multiple_choice',3),
(94,'Choose correct: "There isn''t ___ time left."','much','many','a lot','option_1','multiple_choice',4),
(94,'Which word is used with COUNTABLE nouns?','many','much','less','option_1','multiple_choice',5);
END IF; END $$;

-- 95: Объектные местоимения
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=95)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(95,'What is the object pronoun for "I"?','me','my','mine','option_1','multiple_choice',1),
(95,'What is the object pronoun for "he"?','him','his','he','option_1','multiple_choice',2),
(95,'What is the object pronoun for "they"?','them','their','theirs','option_1','multiple_choice',3),
(95,'Choose correct: "Give ___ the book." (she)','her','she','hers','option_1','multiple_choice',4),
(95,'Choose correct: "I can help ___." (you)','you','your','yours','option_1','multiple_choice',5);
END IF; END $$;

-- 96: Итоговое повторение A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=96)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(96,'Choose correct: "She ___ to school every day."','goes','go','is going','option_1','multiple_choice',1),
(96,'Choose correct: "___ you like coffee?"','Do','Does','Are','option_1','multiple_choice',2),
(96,'Choose the superlative: "fast"','the fastest','more fast','most fastest','option_1','multiple_choice',3),
(96,'Choose correct: "There ___ a lot of people."','are','is','were','option_1','multiple_choice',4),
(96,'Choose correct: "I ___ born in 1995."','was','were','am','option_1','multiple_choice',5);
END IF; END $$;

-- 97: Модальные глаголы: Can, Should, Must
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=97)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(97,'Which modal verb expresses obligation?','must','can','should','option_1','multiple_choice',1),
(97,'Which modal verb gives advice?','should','must','can','option_1','multiple_choice',2),
(97,'Choose correct: "You ___ see a doctor."','should','must to','can to','option_1','multiple_choice',3),
(97,'Choose correct: "Students ___ wear uniforms." (obligation)','must','should','can','option_1','multiple_choice',4),
(97,'Choose correct: "___ I open the window?"','Can','Should','Must','option_1','multiple_choice',5);
END IF; END $$;

-- 98: Наречия частотности
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=98)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(98,'Which adverb means "всегда"?','always','never','sometimes','option_1','multiple_choice',1),
(98,'Which adverb means "никогда"?','never','always','usually','option_1','multiple_choice',2),
(98,'Where does the adverb of frequency go?','Before the main verb','After the main verb','At the end','option_1','multiple_choice',3),
(98,'Choose correct: "She ___ drinks coffee."','always','is always','always is','option_1','multiple_choice',4),
(98,'Which adverb means "иногда"?','sometimes','rarely','often','option_1','multiple_choice',5);
END IF; END $$;

-- 99: Числа и цены (углубление)
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=99)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(99,'How do you say "£5.99"?','five pounds ninety-nine','five point nine nine pounds','five and ninety-nine','option_1','multiple_choice',1),
(99,'How do you say "½"?','a half','one two','zero five','option_1','multiple_choice',2),
(99,'How do you ask the price?','How much does it cost?','What is the cost of price?','How many it cost?','option_1','multiple_choice',3),
(99,'How do you say "¼"?','a quarter','one fourth','zero twenty five','option_1','multiple_choice',4),
(99,'How do you say "$20.50"?','twenty dollars fifty','twenty point fifty dollars','twenty and fifty cents dollars','option_1','multiple_choice',5);
END IF; END $$;

-- 100: Подготовка к итоговому тесту A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=100)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(100,'Choose correct: "He ___ at work right now."','is','are','am','option_1','multiple_choice',1),
(100,'Choose correct article: "___ orange."','an','a','the','option_1','multiple_choice',2),
(100,'Choose correct: "They ___ watching TV yesterday."','were','was','are','option_1','multiple_choice',3),
(100,'Choose correct: "She ___ a car." (has/have)','has','have','is having','option_1','multiple_choice',4),
(100,'Choose correct: "Can you ___ English?"','speak','speaks','speaking','option_1','multiple_choice',5);
END IF; END $$;

-- 101: Переход к уровню A2
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=101)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(101,'Which tense describes completed past actions?','Past Simple','Present Simple','Past Continuous','option_1','multiple_choice',1),
(101,'At A2 level, which grammar is introduced?','Comparatives and conditionals','Only present tenses','Only articles','option_1','multiple_choice',2),
(101,'Choose correct: "I ___ to Paris last year."','went','go','have gone','option_1','multiple_choice',3),
(101,'Choose the comparative: "expensive"','more expensive','expensiver','most expensive','option_1','multiple_choice',4),
(101,'Choose correct: "She ___ been to London." (Present Perfect)','has','have','had','option_1','multiple_choice',5);
END IF; END $$;

-- 102: Погода — углубление
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=102)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(102,'Which word means "гроза"?','thunderstorm','heavy rain','strong wind','option_1','multiple_choice',1),
(102,'Which word means "туман"?','fog','mist','cloud','option_1','multiple_choice',2),
(102,'How do you say "температура минус 5"?','minus five degrees','five below','negative five temperature','option_1','multiple_choice',3),
(102,'Which word means "влажный"?','humid','wet','damp','option_1','multiple_choice',4),
(102,'How do you say "Ожидается дождь"?','Rain is expected','It will be raining maybe','Rain is coming soon','option_1','multiple_choice',5);
END IF; END $$;

-- 103: Время суток и расписание
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=103)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(103,'Which phrase means "утром"?','in the morning','at morning','on the morning','option_1','multiple_choice',1),
(103,'Which phrase means "вечером"?','in the evening','at evening','on evening','option_1','multiple_choice',2),
(103,'How do you say "в полдень"?','at noon','in noon','on the noon','option_1','multiple_choice',3),
(103,'How do you say "в полночь"?','at midnight','in the midnight','on midnight','option_1','multiple_choice',4),
(103,'Which word means "расписание"?','schedule','timetable','calendar','option_1','multiple_choice',5);
END IF; END $$;

-- 104: Еда и предпочтения
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=104)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(104,'How do you say "Я предпочитаю рыбу мясу"?','I prefer fish to meat','I prefer fish than meat','I like more fish than meat','option_1','multiple_choice',1),
(104,'Which word means "острый (о еде)"?','spicy','sour','bitter','option_1','multiple_choice',2),
(104,'Which word means "сладкий"?','sweet','salty','spicy','option_1','multiple_choice',3),
(104,'How do you say "Я вегетарианец"?','I am a vegetarian','I don''t eat meat','I eat only vegetables','option_1','multiple_choice',4),
(104,'Which word means "блюдо (в меню)"?','dish','plate','food','option_1','multiple_choice',5);
END IF; END $$;

-- 105: Семья — описание
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=105)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(105,'How do you say "Мой отец высокий и добрый"?','My father is tall and kind','My father is tall and kindly','My father are tall and kind','option_1','multiple_choice',1),
(105,'Which word means "единственный ребёнок"?','only child','single child','one child','option_1','multiple_choice',2),
(105,'How do you describe a family with many children?','large family','big family','great family','option_1','multiple_choice',3),
(105,'Which word means "близкий (о родственниках)"?','close','near','tight','option_1','multiple_choice',4),
(105,'How do you say "Моя мама работает медсестрой"?','My mum works as a nurse','My mum is working like nurse','My mum works a nurse','option_1','multiple_choice',5);
END IF; END $$;

-- 106: Заключительный обзор A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=106)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(106,'Choose correct: "I ___ to the cinema last weekend."','went','go','have gone','option_1','multiple_choice',1),
(106,'Choose correct: "___ there any eggs?"','Are','Is','Has','option_1','multiple_choice',2),
(106,'Choose correct: "She ___ her homework every evening."','does','do','is doing','option_1','multiple_choice',3),
(106,'Choose the comparative: "bad"','worse','more bad','badder','option_1','multiple_choice',4),
(106,'Choose correct: "You ___ be quiet in the library."','must','can''t','should to','option_1','multiple_choice',5);
END IF; END $$;

-- 107: Внешность и характер
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=107)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(107,'Which word means "вьющиеся волосы"?','curly hair','wavy hair','straight hair','option_1','multiple_choice',1),
(107,'Which word means "щедрый"?','generous','kind','honest','option_1','multiple_choice',2),
(107,'How do you describe someone who is "весёлый"?','cheerful','happy','joyful','option_1','multiple_choice',3),
(107,'Which word means "лысый"?','bald','bold','bare','option_1','multiple_choice',4),
(107,'Which word means "надёжный"?','reliable','honest','loyal','option_1','multiple_choice',5);
END IF; END $$;

-- 108: Дом и интерьер
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=108)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(108,'Which word means "занавески"?','curtains','blinds','shutters','option_1','multiple_choice',1),
(108,'Which word means "ковёр"?','carpet','rug','mat','option_1','multiple_choice',2),
(108,'How do you say "переехать в новый дом"?','move into a new house','move to new home','change to new house','option_1','multiple_choice',3),
(108,'Which word means "чердак"?','attic','basement','cellar','option_1','multiple_choice',4),
(108,'Which word means "подвал"?','basement','attic','garage','option_1','multiple_choice',5);
END IF; END $$;

-- 109: Покупки — углубление
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=109)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(109,'How do you say "Могу я примерить это?"','Can I try this on?','Can I try this?','May I try it?','option_1','multiple_choice',1),
(109,'Which word means "скидка"?','discount','sale','offer','option_1','multiple_choice',2),
(109,'How do you say "Это слишком дорого"?','It is too expensive','It is very costly','That costs too many','option_1','multiple_choice',3),
(109,'Which word means "квитанция"?','receipt','invoice','bill','option_1','multiple_choice',4),
(109,'How do you say "Есть ли у вас это в другом размере?"','Do you have this in another size?','Have you this in other size?','Is there another size of this?','option_1','multiple_choice',5);
END IF; END $$;

-- 110: Транспорт — углубление
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=110)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(110,'How do you say "Где ближайшая остановка автобуса?"','Where is the nearest bus stop?','Where is the bus stop near?','What is the closest bus stop?','option_1','multiple_choice',1),
(110,'Which word means "пробка (на дороге)"?','traffic jam','road block','car queue','option_1','multiple_choice',2),
(110,'How do you say "Купить билет в одну сторону"?','buy a single ticket','buy a one-way ticket','buy a single way ticket','option_1','multiple_choice',3),
(110,'Which word means "пересадка"?','transfer','change','connection','option_1','multiple_choice',4),
(110,'How do you say "Это поезд до Лондона?"','Is this the train to London?','Is this train for London?','Does this train go London?','option_1','multiple_choice',5);
END IF; END $$;

-- 111: Завершение уровня A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=111)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(111,'Which level comes after A1?','A2','B1','A0','option_1','multiple_choice',1),
(111,'Choose correct: "She ___ lived here for 3 years." (Present Perfect)','has','have','had','option_1','multiple_choice',2),
(111,'Choose correct: "I ___ my keys." (Past Simple)','lost','lose','have lost','option_1','multiple_choice',3),
(111,'Choose correct comparative: "This film is ___ than that one." (boring)','more boring','boringer','most boring','option_1','multiple_choice',4),
(111,'Choose correct: "You ___ eat more vegetables."','should','must to','can to','option_1','multiple_choice',5);
END IF; END $$;

-- 112: Природа и животные
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=112)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(112,'Which word means "лес"?','forest','jungle','wood','option_1','multiple_choice',1),
(112,'Which word means "река"?','river','lake','stream','option_1','multiple_choice',2),
(112,'Which word means "лев"?','lion','tiger','leopard','option_1','multiple_choice',3),
(112,'Which word means "орёл"?','eagle','hawk','owl','option_1','multiple_choice',4),
(112,'Which word means "бабочка"?','butterfly','dragonfly','beetle','option_1','multiple_choice',5);
END IF; END $$;

-- 113: Цвета и формы
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=113)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(113,'Which word means "квадрат"?','square','circle','triangle','option_1','multiple_choice',1),
(113,'Which word means "фиолетовый"?','purple','pink','orange','option_1','multiple_choice',2),
(113,'Which word means "прямоугольник"?','rectangle','square','oval','option_1','multiple_choice',3),
(113,'Which word means "серый"?','grey','brown','beige','option_1','multiple_choice',4),
(113,'Which word means "треугольник"?','triangle','diamond','star','option_1','multiple_choice',5);
END IF; END $$;

-- 114: Письмо и email
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=114)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(114,'How do you start a formal letter?','Dear Sir/Madam,','Hello there,','Hey,','option_1','multiple_choice',1),
(114,'How do you end a formal letter?','Yours sincerely,','Best wishes,','Goodbye,','option_1','multiple_choice',2),
(114,'Which word means "тема письма"?','subject','title','topic','option_1','multiple_choice',3),
(114,'How do you say "Прикрепляю файл"?','I am attaching a file','I am adding a file','I put the file here','option_1','multiple_choice',4),
(114,'Which phrase opens an informal email to a friend?','Hi [name],','Dear [name],','Hello Mr/Ms [name],','option_1','multiple_choice',5);
END IF; END $$;

-- 115: Праздники и подарки
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=115)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(115,'How do you say "С Рождеством!"','Merry Christmas!','Happy Christmas!','Good Christmas!','option_1','multiple_choice',1),
(115,'Which word means "украшение"?','decoration','ornament','design','option_1','multiple_choice',2),
(115,'How do you say "Я дарю тебе подарок"?','I am giving you a present','I give you a gift now','I am gifting to you','option_1','multiple_choice',3),
(115,'Which word means "открытка"?','card','note','letter','option_1','multiple_choice',4),
(115,'How do you say "Поздравляю!"','Congratulations!','Celebrations!','Happy wishes!','option_1','multiple_choice',5);
END IF; END $$;

-- 116: Ты молодец! Итог A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=116)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(116,'What does A1 level mean?','Beginner level of English','Elementary English','Pre-intermediate English','option_1','multiple_choice',1),
(116,'Choose correct: "She ___ English every day." (habit)','studies','is studying','studied','option_1','multiple_choice',2),
(116,'Choose correct article: "___ best book I read."','The','A','An','option_1','multiple_choice',3),
(116,'Choose correct: "There ___ some water in the bottle."','is','are','has','option_1','multiple_choice',4),
(116,'Choose correct: "They ___ playing when I arrived."','were','was','are','option_1','multiple_choice',5);
END IF; END $$;

-- 117: Итоговый урок — Завершение A1
DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=117)=0 THEN
INSERT INTO questions (lesson_id,question_text,option_1,option_2,option_3,correct_option,task_type,order_num) VALUES
(117,'Choose correct: "I ___ my friend yesterday."','met','meet','have met','option_1','multiple_choice',1),
(117,'Choose correct: "She ___ to music every evening."','listens','listen','is listen','option_1','multiple_choice',2),
(117,'Choose the superlative: "good"','the best','the most good','the goodest','option_1','multiple_choice',3),
(117,'Choose correct: "___ you ever been to London?"','Have','Has','Did','option_1','multiple_choice',4),
(117,'Choose correct: "They ___ very happy about the news."','were','was','are','option_1','multiple_choice',5);
END IF; END $$;
