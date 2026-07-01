-- Questions for A1 lessons ids 61-117 (5 per lesson)
-- Format: (lesson_id, level, task_type, question_text, option_1, option_2, option_3, correct_option, order_num)
-- correct_option: 1=option_1, 2=option_2, 3=option_3

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=61)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(61,'A1','multiple_choice','Which article is correct: "___ umbrella"?','an','a','the',1,1),
(61,'A1','multiple_choice','Which article is correct: "___ book"?','a','an','the',1,2),
(61,'A1','multiple_choice','Which article is correct: "___ sun rises in the east."','The','A','An',1,3),
(61,'A1','multiple_choice','Which article is correct: "She is ___ honest person."','an','a','the',1,4),
(61,'A1','multiple_choice','Which article is correct: "I want ___ coffee, please."','a','an','the',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=62)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(62,'A1','multiple_choice','How do you say 35 in English?','thirty-five','three-five','thirty five',1,1),
(62,'A1','multiple_choice','How do you say 100 in English?','a hundred','one-hundred','ten zero',1,2),
(62,'A1','multiple_choice','How do you say 500 in English?','five hundred','five-hundred','fifty hundred',1,3),
(62,'A1','multiple_choice','How do you say 48 in English?','forty-eight','four-eight','fourteen-eight',1,4),
(62,'A1','multiple_choice','How do you say 1000 in English?','a thousand','ten hundred','one-thousand',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=63)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(63,'A1','multiple_choice','What time is it? (3:00)','It is three oclock','It is three hours','It is at three',1,1),
(63,'A1','multiple_choice','What time is it? (7:30)','It is half past seven','It is seven thirty past','It is half seven oclock',1,2),
(63,'A1','multiple_choice','What time is it? (4:15)','It is quarter past four','It is four and fifteen','It is quarter to four',1,3),
(63,'A1','multiple_choice','What time is it? (9:45)','It is quarter to ten','It is quarter past nine','It is nine forty-five',1,4),
(63,'A1','multiple_choice','How do you ask the time?','What time is it?','What is the hour?','How much is the time?',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=64)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(64,'A1','multiple_choice','Which word means bread in Russian?','bread','milk','egg',1,1),
(64,'A1','multiple_choice','Which word means water?','water','juice','tea',1,2),
(64,'A1','multiple_choice','Which word means apple?','apple','orange','banana',1,3),
(64,'A1','multiple_choice','Which word means meat?','meat','fish','cheese',1,4),
(64,'A1','multiple_choice','Which word means juice?','juice','coffee','soup',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=65)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(65,'A1','multiple_choice','Which word means hand?','hand','leg','foot',1,1),
(65,'A1','multiple_choice','Which word means eyes?','eyes','ears','nose',1,2),
(65,'A1','multiple_choice','Which word means leg?','leg','arm','back',1,3),
(65,'A1','multiple_choice','Which word means mouth?','mouth','head','neck',1,4),
(65,'A1','multiple_choice','Which word means shoulder?','shoulder','knee','elbow',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=66)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(66,'A1','multiple_choice','Which word means sunny?','sunny','cloudy','rainy',1,1),
(66,'A1','multiple_choice','Which word means rain?','rain','snow','wind',1,2),
(66,'A1','multiple_choice','How do you say It is cold today in English?','It is cold today','Today is coldly','The weather cold',1,3),
(66,'A1','multiple_choice','Which word means windy?','windy','foggy','stormy',1,4),
(66,'A1','multiple_choice','How do you ask about weather?','What is the weather like?','How is weather doing?','What weather today?',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=67)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(67,'A1','multiple_choice','Which word means kitchen?','kitchen','bedroom','bathroom',1,1),
(67,'A1','multiple_choice','Which word means bedroom?','bedroom','living room','kitchen',1,2),
(67,'A1','multiple_choice','Which word means window?','window','door','wall',1,3),
(67,'A1','multiple_choice','Which word means sofa?','sofa','table','chair',1,4),
(67,'A1','multiple_choice','Which word means living room?','living room','dining room','bedroom',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=68)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(68,'A1','multiple_choice','Which word means teacher?','teacher','doctor','driver',1,1),
(68,'A1','multiple_choice','Which word means doctor?','doctor','nurse','engineer',1,2),
(68,'A1','multiple_choice','Which word means cook?','cook','waiter','baker',1,3),
(68,'A1','multiple_choice','Which word means police officer?','police officer','firefighter','soldier',1,4),
(68,'A1','multiple_choice','Which word means driver?','driver','pilot','sailor',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=69)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(69,'A1','multiple_choice','Which word means bus?','bus','train','tram',1,1),
(69,'A1','multiple_choice','Which word means plane?','plane','ship','car',1,2),
(69,'A1','multiple_choice','Which word means bicycle?','bicycle','motorcycle','scooter',1,3),
(69,'A1','multiple_choice','How do you say I take the metro?','I take the metro','I go with metro','I drive the metro',1,4),
(69,'A1','multiple_choice','Which word means taxi?','taxi','bus','tram',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=70)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(70,'A1','multiple_choice','How do you ask the price in English?','How much is it?','What is the price?','How many does it cost?',1,1),
(70,'A1','multiple_choice','How do you say I would like to buy in English?','I would like to buy...','I want buying...','I like to buy...',1,2),
(70,'A1','multiple_choice','Which word means cheap?','cheap','expensive','free',1,3),
(70,'A1','multiple_choice','Which word means cashier?','cashier','shelf','basket',1,4),
(70,'A1','multiple_choice','How do you ask if a shop has something?','Do you have...?','Have you got...?','Is there a...?',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=71)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(71,'A1','multiple_choice','Which word means aunt?','aunt','uncle','cousin',1,1),
(71,'A1','multiple_choice','Which word means nephew?','nephew','niece','grandson',1,2),
(71,'A1','multiple_choice','How do you say He is my best friend?','He is my best friend','He is my good friend','He is best friend',1,3),
(71,'A1','multiple_choice','Which word means grandfather?','grandfather','grandmother','father',1,4),
(71,'A1','multiple_choice','Which word means cousin?','cousin','brother','nephew',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=72)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(72,'A1','multiple_choice','How do you say I like reading?','I like reading','I like to read many','I enjoy the reading',1,1),
(72,'A1','multiple_choice','Which word means to draw?','draw','paint','colour',1,2),
(72,'A1','multiple_choice','Which word means swimming?','swimming','running','cycling',1,3),
(72,'A1','multiple_choice','How do you say In my free time I play football?','In my free time I play football','In free time I playing football','Free time I play football',1,4),
(72,'A1','multiple_choice','Which word means to cook food?','cook','bake','fry',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=73)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(73,'A1','multiple_choice','Which word means shirt?','shirt','skirt','shorts',1,1),
(73,'A1','multiple_choice','Which word means coat?','coat','jacket','vest',1,2),
(73,'A1','multiple_choice','How do you say I wear jeans?','I wear jeans','I am wearing a jeans','I put on jeans',1,3),
(73,'A1','multiple_choice','Which word means trainers?','trainers','boots','sandals',1,4),
(73,'A1','multiple_choice','Which word means dress?','dress','skirt','blouse',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=74)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(74,'A1','multiple_choice','How do you say Turn left?','Turn left','Go left','Take the left',1,1),
(74,'A1','multiple_choice','How do you say Go straight ahead?','Go straight ahead','Walk the straight','Move forward',1,2),
(74,'A1','multiple_choice','How do you ask where something is?','Where is...?','What is the place?','How to find...?',1,3),
(74,'A1','multiple_choice','How do you say Turn right?','Turn right','Go right way','Take right road',1,4),
(74,'A1','multiple_choice','Which word means crossroads?','crossroads','corner','roundabout',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=75)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(75,'A1','multiple_choice','How do you say I wake up at 7 a.m.?','I wake up at 7 a.m.','I wake at 7 in morning','I woke up at 7 a.m.',1,1),
(75,'A1','multiple_choice','How do you say brush my teeth?','brush my teeth','wash my teeth','clean my teeth',1,2),
(75,'A1','multiple_choice','How do you say I go to school?','I go to school','I am going school','I walk at school',1,3),
(75,'A1','multiple_choice','How do you say go to bed?','go to bed','go to sleep early','put to bed',1,4),
(75,'A1','multiple_choice','How do you say I have breakfast?','I have breakfast','I eat the breakfast','I make a breakfast',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=76)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(76,'A1','multiple_choice','How do you say I have a headache?','I have a headache','My head is hurting','I have headache bad',1,1),
(76,'A1','multiple_choice','How do you say I feel ill?','I feel ill','I am feeling bad','I do not feel well now',1,2),
(76,'A1','multiple_choice','Which word means fever?','fever','cold','flu',1,3),
(76,'A1','multiple_choice','How do you say I need to see a doctor?','I need to see a doctor','I must go doctor','I should visit medicine',1,4),
(76,'A1','multiple_choice','Which word means cough?','cough','sneeze','sore throat',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=77)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(77,'A1','multiple_choice','How do you ask for the menu?','Can I have a menu, please?','Give me a menu please','I want to see menu',1,1),
(77,'A1','multiple_choice','How do you start ordering food?','I would like to order...','I want ordering...','Can I order me...',1,2),
(77,'A1','multiple_choice','How do you ask for the bill?','The bill, please','I want pay now','Check for me please',1,3),
(77,'A1','multiple_choice','Which word means waiter?','waiter','cashier','manager',1,4),
(77,'A1','multiple_choice','How do you say It was delicious?','It was delicious','It is very tasty','That were good',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=78)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(78,'A1','multiple_choice','Choose the correct form: She ___ at home yesterday.','was','were','is',1,1),
(78,'A1','multiple_choice','Choose the correct form: They ___ happy.','were','was','are',1,2),
(78,'A1','multiple_choice','Choose the correct form: I ___ very tired.','was','were','am',1,3),
(78,'A1','multiple_choice','Choose the correct form: He ___ not at school.','was','were','is',1,4),
(78,'A1','multiple_choice','Choose the question form: ___ you at home?','Were','Was','Are',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=79)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(79,'A1','multiple_choice','Choose the correct form: I ___ going to travel next summer.','am','is','are',1,1),
(79,'A1','multiple_choice','Choose the correct form: She ___ going to call you.','is','am','are',1,2),
(79,'A1','multiple_choice','How do you say We are going to visit London?','We are going to visit London','We going visit London','We will going to London',1,3),
(79,'A1','multiple_choice','Choose the question form: ___ he going to play?','Is','Are','Am',1,4),
(79,'A1','multiple_choice','Choose the negative: They ___ not going to come.','are','is','am',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=80)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(80,'A1','multiple_choice','Which word means beautiful?','beautiful','ugly','strange',1,1),
(80,'A1','multiple_choice','Which word means tall?','tall','short','slim',1,2),
(80,'A1','multiple_choice','Which word means intelligent?','intelligent','kind','brave',1,3),
(80,'A1','multiple_choice','Where does an adjective go in English?','Before the noun','After the noun','At the end',1,4),
(80,'A1','multiple_choice','Which word means old?','old','young','new',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=81)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(81,'A1','multiple_choice','Choose correct: ___ a cat on the roof.','There is','There are','There has',1,1),
(81,'A1','multiple_choice','Choose correct: ___ two books on the table.','There are','There is','There has',1,2),
(81,'A1','multiple_choice','Choose the question: ___ a problem?','Is there','Are there','Has there',1,3),
(81,'A1','multiple_choice','Choose the negative: There ___ any milk.','is not','are not','has not',1,4),
(81,'A1','multiple_choice','Choose correct: ___ many students in the class.','There are','There is','It is',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=82)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(82,'A1','multiple_choice','Which word means passport?','passport','ticket','visa',1,1),
(82,'A1','multiple_choice','Which word means suitcase?','suitcase','backpack','bag',1,2),
(82,'A1','multiple_choice','How do you say I would like to book a room?','I would like to book a room','I want reserve a room','I need booking a room',1,3),
(82,'A1','multiple_choice','Which word means airport?','airport','station','port',1,4),
(82,'A1','multiple_choice','Which word means traveller?','traveller','tourist','visitor',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=83)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(83,'A1','multiple_choice','How do you ask Where do you work?','Where do you work?','Where are you working?','What is your work place?',1,1),
(83,'A1','multiple_choice','Which word means office?','office','factory','shop',1,2),
(83,'A1','multiple_choice','Which word means salary?','salary','bonus','tax',1,3),
(83,'A1','multiple_choice','How do you say I work in a bank?','I work in a bank','I am working at bank','I work at bank office',1,4),
(83,'A1','multiple_choice','Which word means colleague?','colleague','boss','employee',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=84)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(84,'A1','multiple_choice','How do you say Happy New Year in English?','Happy New Year!','Good New Year!','Nice New Year!',1,1),
(84,'A1','multiple_choice','Which word means gift?','gift','card','decoration',1,2),
(84,'A1','multiple_choice','How do you say Happy Birthday in English?','Happy Birthday!','Good Birthday!','Nice Birthday!',1,3),
(84,'A1','multiple_choice','Which word means to celebrate?','celebrate','decorate','invite',1,4),
(84,'A1','multiple_choice','Which word means party?','party','festival','ceremony',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=85)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(85,'A1','multiple_choice','Choose the comparative form of big.','bigger','more big','biger',1,1),
(85,'A1','multiple_choice','Choose the superlative form of tall.','the tallest','most tall','the most tall',1,2),
(85,'A1','multiple_choice','Choose the comparative form of interesting.','more interesting','interestinger','most interesting',1,3),
(85,'A1','multiple_choice','Choose correct: She is ___ than her brother. (tall)','taller','more tall','tallest',1,4),
(85,'A1','multiple_choice','Choose the superlative form of good.','the best','the most good','the goodest',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=86)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(86,'A1','multiple_choice','Choose correct: She ___ speak English well.','can','cans','is can',1,1),
(86,'A1','multiple_choice','Choose correct: He ___ swim - he never learned.','cannot','does not can','is not can',1,2),
(86,'A1','multiple_choice','How do you ask Can you play the guitar?','Can you play the guitar?','Do you can play guitar?','Are you able playing guitar?',1,3),
(86,'A1','multiple_choice','Choose correct: I ___ help you with that.','can','could to','am able',1,4),
(86,'A1','multiple_choice','What is the negative form of can?','cannot','do not can','am not can',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=87)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(87,'A1','multiple_choice','Choose correct: The book is ___ the table.','on','in','at',1,1),
(87,'A1','multiple_choice','Choose correct: She lives ___ London.','in','on','at',1,2),
(87,'A1','multiple_choice','Choose correct: I wake up ___ 7 oclock.','at','in','on',1,3),
(87,'A1','multiple_choice','Choose correct: I was born ___ Monday.','on','in','at',1,4),
(87,'A1','multiple_choice','Choose correct: The cat is ___ the box. (inside)','inside','on','at',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=88)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(88,'A1','multiple_choice','Which is used for one object that is NEAR?','this','that','these',1,1),
(88,'A1','multiple_choice','Which is used for one object that is FAR?','that','this','those',1,2),
(88,'A1','multiple_choice','Which is used for MANY objects that are NEAR?','these','those','this',1,3),
(88,'A1','multiple_choice','Choose correct: ___ are my friends over there.','Those','These','That',1,4),
(88,'A1','multiple_choice','Choose correct: ___ is my pen here.','This','That','These',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=89)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(89,'A1','multiple_choice','How do you say I love music?','I love music','I am loving music','I like the music very',1,1),
(89,'A1','multiple_choice','How do you say I do not like horror films?','I do not like horror films','I am not liking horror films','I dislike the horror films',1,2),
(89,'A1','multiple_choice','Which phrase expresses the strongest preference?','I love','I like','I enjoy',1,3),
(89,'A1','multiple_choice','How do you say I do not mind?','I do not mind','I do not care','It is same for me',1,4),
(89,'A1','multiple_choice','How do you say I adore chocolate?','I adore chocolate','I love very much chocolate','I extremely like chocolate',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=90)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(90,'A1','multiple_choice','Choose correct: She ___ English every day.','studies','study','is studying',1,1),
(90,'A1','multiple_choice','Choose correct: They ___ to school on Mondays.','go','goes','going',1,2),
(90,'A1','multiple_choice','Choose the negative: He ___ like coffee.','does not','do not','is not',1,3),
(90,'A1','multiple_choice','Choose the question: ___ you speak French?','Do','Does','Are',1,4),
(90,'A1','multiple_choice','Choose correct: She ___ a cat.','has','have','is having',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=91)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(91,'A1','multiple_choice','Choose correct: I ___ a student.','am','is','are',1,1),
(91,'A1','multiple_choice','Choose correct: There ___ three cats in the garden.','are','is','has',1,2),
(91,'A1','multiple_choice','Choose correct: She can ___ very fast.','run','runs','running',1,3),
(91,'A1','multiple_choice','Choose correct article: ___ elephant is big.','An','A','The',1,4),
(91,'A1','multiple_choice','Choose correct: They ___ going to travel tomorrow.','are','is','am',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=92)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(92,'A1','multiple_choice','Which is the possessive pronoun for I?','my','me','mine',1,1),
(92,'A1','multiple_choice','Which is the possessive pronoun for she?','her','she','hers',1,2),
(92,'A1','multiple_choice','Which is the possessive pronoun for they?','their','them','theirs',1,3),
(92,'A1','multiple_choice','Choose correct: ___ name is Anna. (she)','Her','She','Hers',1,4),
(92,'A1','multiple_choice','Choose correct: This is ___ book. (I)','my','me','mine',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=93)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(93,'A1','multiple_choice','Choose correct: I have ___ milk.','some','any','a',1,1),
(93,'A1','multiple_choice','Choose correct: Do you have ___ questions?','any','some','a',1,2),
(93,'A1','multiple_choice','Choose correct: There is not ___ coffee left.','any','some','no',1,3),
(93,'A1','multiple_choice','Choose correct: Would you like ___ tea?','some','any','a',1,4),
(93,'A1','multiple_choice','Choose correct: I do not have ___ money.','any','some','the',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=94)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(94,'A1','multiple_choice','Choose correct: How ___ water do you drink?','much','many','lots',1,1),
(94,'A1','multiple_choice','Choose correct: How ___ people are there?','many','much','lot',1,2),
(94,'A1','multiple_choice','Choose correct: She has ___ friends.','a lot of','much','many a',1,3),
(94,'A1','multiple_choice','Choose correct: There is not ___ time left.','much','many','a lot',1,4),
(94,'A1','multiple_choice','Which word is used with COUNTABLE nouns?','many','much','less',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=95)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(95,'A1','multiple_choice','What is the object pronoun for I?','me','my','mine',1,1),
(95,'A1','multiple_choice','What is the object pronoun for he?','him','his','he',1,2),
(95,'A1','multiple_choice','What is the object pronoun for they?','them','their','theirs',1,3),
(95,'A1','multiple_choice','Choose correct: Give ___ the book. (she)','her','she','hers',1,4),
(95,'A1','multiple_choice','Choose correct: I can help ___. (you)','you','your','yours',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=96)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(96,'A1','multiple_choice','Choose correct: She ___ to school every day.','goes','go','is going',1,1),
(96,'A1','multiple_choice','Choose correct: ___ you like coffee?','Do','Does','Are',1,2),
(96,'A1','multiple_choice','Choose the superlative of fast.','the fastest','more fast','most fastest',1,3),
(96,'A1','multiple_choice','Choose correct: There ___ a lot of people.','are','is','were',1,4),
(96,'A1','multiple_choice','Choose correct: I ___ born in 1995.','was','were','am',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=97)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(97,'A1','multiple_choice','Which modal verb expresses strong obligation?','must','can','should',1,1),
(97,'A1','multiple_choice','Which modal verb gives advice?','should','must','can',1,2),
(97,'A1','multiple_choice','Choose correct: You ___ see a doctor.','should','must to','can to',1,3),
(97,'A1','multiple_choice','Choose correct: Students ___ wear uniforms. (obligation)','must','should','can',1,4),
(97,'A1','multiple_choice','Choose correct: ___ I open the window?','Can','Should','Must',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=98)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(98,'A1','multiple_choice','Which adverb means always?','always','never','sometimes',1,1),
(98,'A1','multiple_choice','Which adverb means never?','never','always','usually',1,2),
(98,'A1','multiple_choice','Where does the adverb of frequency go in a sentence?','Before the main verb','After the main verb','At the end',1,3),
(98,'A1','multiple_choice','Choose correct: She ___ drinks coffee.','always','is always','always is',1,4),
(98,'A1','multiple_choice','Which adverb means sometimes?','sometimes','rarely','often',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=99)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(99,'A1','multiple_choice','How do you say 5.99 pounds?','five pounds ninety-nine','five point nine nine','five and ninety-nine',1,1),
(99,'A1','multiple_choice','How do you say one half?','a half','one two','zero five',1,2),
(99,'A1','multiple_choice','How do you ask the price?','How much does it cost?','What is the cost price?','How many it cost?',1,3),
(99,'A1','multiple_choice','How do you say one quarter?','a quarter','one fourth','zero twenty-five',1,4),
(99,'A1','multiple_choice','How do you say 20 dollars 50 cents?','twenty dollars fifty','twenty point fifty','twenty and fifty dollars',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=100)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(100,'A1','multiple_choice','Choose correct: He ___ at work right now.','is','are','am',1,1),
(100,'A1','multiple_choice','Choose correct article before orange.','an','a','the',1,2),
(100,'A1','multiple_choice','Choose correct: They ___ watching TV yesterday.','were','was','are',1,3),
(100,'A1','multiple_choice','Choose correct: She ___ a car.','has','have','is having',1,4),
(100,'A1','multiple_choice','Choose correct: Can you ___ English?','speak','speaks','speaking',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=101)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(101,'A1','multiple_choice','Which tense describes completed past actions?','Past Simple','Present Simple','Past Continuous',1,1),
(101,'A1','multiple_choice','Choose correct: I ___ to Paris last year.','went','go','have gone',1,2),
(101,'A1','multiple_choice','Choose the comparative of expensive.','more expensive','expensiver','most expensive',1,3),
(101,'A1','multiple_choice','Which level comes after A1?','A2','B1','A0',1,4),
(101,'A1','multiple_choice','Choose correct: She ___ been to London.','has','have','had',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=102)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(102,'A1','multiple_choice','Which word means thunderstorm?','thunderstorm','heavy rain','strong wind',1,1),
(102,'A1','multiple_choice','Which word means fog?','fog','mist','cloud',1,2),
(102,'A1','multiple_choice','How do you say minus five degrees?','minus five degrees','five below','negative five',1,3),
(102,'A1','multiple_choice','Which word means humid?','humid','wet','damp',1,4),
(102,'A1','multiple_choice','How do you say rain is expected?','Rain is expected','It will be raining','Rain is coming soon',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=103)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(103,'A1','multiple_choice','How do you say in the morning?','in the morning','at morning','on the morning',1,1),
(103,'A1','multiple_choice','How do you say in the evening?','in the evening','at evening','on evening',1,2),
(103,'A1','multiple_choice','How do you say at noon?','at noon','in noon','on the noon',1,3),
(103,'A1','multiple_choice','How do you say at midnight?','at midnight','in the midnight','on midnight',1,4),
(103,'A1','multiple_choice','Which word means schedule?','schedule','timetable','calendar',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=104)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(104,'A1','multiple_choice','How do you say I prefer fish to meat?','I prefer fish to meat','I prefer fish than meat','I like more fish than meat',1,1),
(104,'A1','multiple_choice','Which word means spicy?','spicy','sour','bitter',1,2),
(104,'A1','multiple_choice','Which word means sweet?','sweet','salty','spicy',1,3),
(104,'A1','multiple_choice','How do you say I am a vegetarian?','I am a vegetarian','I do not eat meat','I eat only vegetables',1,4),
(104,'A1','multiple_choice','Which word means dish on a menu?','dish','plate','food',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=105)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(105,'A1','multiple_choice','How do you say My father is tall and kind?','My father is tall and kind','My father is tall and kindly','My father are tall and kind',1,1),
(105,'A1','multiple_choice','Which phrase means only child?','only child','single child','one child',1,2),
(105,'A1','multiple_choice','How do you describe a family with many children?','large family','big family','great family',1,3),
(105,'A1','multiple_choice','Which word means close as in close family?','close','near','tight',1,4),
(105,'A1','multiple_choice','How do you say My mum works as a nurse?','My mum works as a nurse','My mum is working like nurse','My mum works a nurse',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=106)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(106,'A1','multiple_choice','Choose correct: I ___ to the cinema last weekend.','went','go','have gone',1,1),
(106,'A1','multiple_choice','Choose correct: ___ there any eggs?','Are','Is','Has',1,2),
(106,'A1','multiple_choice','Choose correct: She ___ her homework every evening.','does','do','is doing',1,3),
(106,'A1','multiple_choice','Choose the comparative of bad.','worse','more bad','badder',1,4),
(106,'A1','multiple_choice','Choose correct: You ___ be quiet in the library.','must','cannot','should to',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=107)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(107,'A1','multiple_choice','Which word means curly hair?','curly hair','wavy hair','straight hair',1,1),
(107,'A1','multiple_choice','Which word means generous?','generous','kind','honest',1,2),
(107,'A1','multiple_choice','Which word means cheerful?','cheerful','happy','joyful',1,3),
(107,'A1','multiple_choice','Which word means bald?','bald','bold','bare',1,4),
(107,'A1','multiple_choice','Which word means reliable?','reliable','honest','loyal',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=108)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(108,'A1','multiple_choice','Which word means curtains?','curtains','blinds','shutters',1,1),
(108,'A1','multiple_choice','Which word means carpet?','carpet','rug','mat',1,2),
(108,'A1','multiple_choice','How do you say move into a new house?','move into a new house','move to new home','change to new house',1,3),
(108,'A1','multiple_choice','Which word means attic?','attic','basement','cellar',1,4),
(108,'A1','multiple_choice','Which word means basement?','basement','attic','garage',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=109)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(109,'A1','multiple_choice','How do you ask to try on clothes?','Can I try this on?','Can I try this?','May I try it?',1,1),
(109,'A1','multiple_choice','Which word means discount?','discount','sale','offer',1,2),
(109,'A1','multiple_choice','How do you say It is too expensive?','It is too expensive','It is very costly','That costs too many',1,3),
(109,'A1','multiple_choice','Which word means receipt?','receipt','invoice','bill',1,4),
(109,'A1','multiple_choice','How do you ask for another size?','Do you have this in another size?','Have you this in other size?','Is there another size?',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=110)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(110,'A1','multiple_choice','How do you ask where the nearest bus stop is?','Where is the nearest bus stop?','Where is the bus stop near?','What is the closest bus stop?',1,1),
(110,'A1','multiple_choice','Which word means traffic jam?','traffic jam','road block','car queue',1,2),
(110,'A1','multiple_choice','How do you say buy a single ticket?','buy a single ticket','buy a one-way ticket','buy a single way ticket',1,3),
(110,'A1','multiple_choice','Which word means transfer on public transport?','transfer','change','connection',1,4),
(110,'A1','multiple_choice','How do you ask if this is the train to London?','Is this the train to London?','Is this train for London?','Does this train go London?',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=111)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(111,'A1','multiple_choice','Which level comes after A1?','A2','B1','A0',1,1),
(111,'A1','multiple_choice','Choose correct: She ___ lived here for 3 years.','has','have','had',1,2),
(111,'A1','multiple_choice','Choose correct Past Simple: I ___ my keys.','lost','lose','have lost',1,3),
(111,'A1','multiple_choice','Choose comparative: This film is ___ than that one. (boring)','more boring','boringer','most boring',1,4),
(111,'A1','multiple_choice','Choose correct: You ___ eat more vegetables.','should','must to','can to',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=112)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(112,'A1','multiple_choice','Which word means forest?','forest','jungle','wood',1,1),
(112,'A1','multiple_choice','Which word means river?','river','lake','stream',1,2),
(112,'A1','multiple_choice','Which word means lion?','lion','tiger','leopard',1,3),
(112,'A1','multiple_choice','Which word means eagle?','eagle','hawk','owl',1,4),
(112,'A1','multiple_choice','Which word means butterfly?','butterfly','dragonfly','beetle',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=113)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(113,'A1','multiple_choice','Which word means square shape?','square','circle','triangle',1,1),
(113,'A1','multiple_choice','Which word means purple?','purple','pink','orange',1,2),
(113,'A1','multiple_choice','Which word means rectangle?','rectangle','square','oval',1,3),
(113,'A1','multiple_choice','Which word means grey?','grey','brown','beige',1,4),
(113,'A1','multiple_choice','Which word means triangle?','triangle','diamond','star',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=114)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(114,'A1','multiple_choice','How do you start a formal letter?','Dear Sir/Madam,','Hello there,','Hey,',1,1),
(114,'A1','multiple_choice','How do you end a formal letter?','Yours sincerely,','Best wishes,','Goodbye,',1,2),
(114,'A1','multiple_choice','Which word means the topic of an email?','subject','title','topic',1,3),
(114,'A1','multiple_choice','How do you say I am attaching a file?','I am attaching a file','I am adding a file','I put the file here',1,4),
(114,'A1','multiple_choice','How do you open an informal email to a friend?','Hi [name],','Dear [name],','Hello Mr [name],',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=115)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(115,'A1','multiple_choice','How do you say Merry Christmas?','Merry Christmas!','Happy Christmas!','Good Christmas!',1,1),
(115,'A1','multiple_choice','Which word means decoration?','decoration','ornament','design',1,2),
(115,'A1','multiple_choice','How do you say I am giving you a present?','I am giving you a present','I give you a gift now','I am gifting to you',1,3),
(115,'A1','multiple_choice','Which word means greeting card?','card','note','letter',1,4),
(115,'A1','multiple_choice','How do you say Congratulations?','Congratulations!','Celebrations!','Happy wishes!',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=116)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(116,'A1','multiple_choice','What does A1 level mean?','Beginner level of English','Elementary English','Pre-intermediate English',1,1),
(116,'A1','multiple_choice','Choose correct: She ___ English every day. (habit)','studies','is studying','studied',1,2),
(116,'A1','multiple_choice','Choose correct article: ___ best book I read.','The','A','An',1,3),
(116,'A1','multiple_choice','Choose correct: There ___ some water in the bottle.','is','are','has',1,4),
(116,'A1','multiple_choice','Choose correct: They ___ playing when I arrived.','were','was','are',1,5);
END IF; END $$;

DO $$ BEGIN
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=117)=0 THEN
INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(117,'A1','multiple_choice','Choose correct Past Simple: I ___ my friend yesterday.','met','meet','have met',1,1),
(117,'A1','multiple_choice','Choose correct: She ___ to music every evening.','listens','listen','is listen',1,2),
(117,'A1','multiple_choice','Choose the superlative of good.','the best','the most good','the goodest',1,3),
(117,'A1','multiple_choice','Choose correct: ___ you ever been to London?','Have','Has','Did',1,4),
(117,'A1','multiple_choice','Choose correct: They ___ very happy about the news.','were','was','are',1,5);
END IF; END $$;
