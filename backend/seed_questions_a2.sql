-- Вопросы к урокам A2 (ids 118–187), по 5 вопросов на урок
-- Идемпотентный: добавляет только если вопросов нет
-- Запуск: psql $DATABASE_URL -f seed_questions_a2.sql

DO $$
BEGIN

-- ─── 118: Past Simple — Regular Verbs ───────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=118)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(118,'A2','multiple_choice','How do you form Past Simple of regular verbs?','Add -ing','Add -ed','Add -s',2,1),
(118,'A2','multiple_choice','What is the Past Simple of "play"?','plaied','playing','played',3,2),
(118,'A2','multiple_choice','What is the Past Simple of "study"?','studyed','studied','studid',2,3),
(118,'A2','multiple_choice','Fill in: She ___ to work yesterday. (walk)','walks','walking','walked',3,4),
(118,'A2','multiple_choice','Which verb forms Past Simple with "-ied"?','play','work','study',3,5);
END IF;

-- ─── 119: Past Simple — Irregular Verbs ────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=119)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(119,'A2','multiple_choice','What is the Past Simple of "go"?','goed','going','went',3,1),
(119,'A2','multiple_choice','What is the Past Simple of "see"?','seed','saw','seen',2,2),
(119,'A2','multiple_choice','What is the Past Simple of "eat"?','eated','eaten','ate',3,3),
(119,'A2','multiple_choice','What is the Past Simple of "buy"?','buyed','bought','buied',2,4),
(119,'A2','multiple_choice','Fill in: I ___ a good film last night. (see)','saw','seen','see',1,5);
END IF;

-- ─── 120: Past Simple — Questions & Negatives ───────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=120)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(120,'A2','multiple_choice','How do you make a question in Past Simple?','Did + subject + verb','Do + subject + verb + -ed','Was + subject + verb',1,1),
(120,'A2','multiple_choice','Which sentence is correct?','Did you went out?','Did you go out?','Did you gone out?',2,2),
(120,'A2','multiple_choice','How do you make a negative in Past Simple?','I not slept well.','I didn''t slept well.','I didn''t sleep well.',3,3),
(120,'A2','multiple_choice','Fill in: ___ she work yesterday?','Was','Does','Did',3,4),
(120,'A2','multiple_choice','Fill in: He ___ watch TV last night.','didn''t','don''t','wasn''t',1,5);
END IF;

-- ─── 121: will vs be going to ───────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=121)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(121,'A2','multiple_choice','Which is used for spontaneous decisions?','be going to','will','Present Continuous',2,1),
(121,'A2','multiple_choice','Which is used for plans and intentions?','will','be going to','Present Simple',2,2),
(121,'A2','multiple_choice','Fill in: Look at those clouds! It ___ rain.','will','is going to','rains',2,3),
(121,'A2','multiple_choice','Fill in: I''m hungry. I think I ___ make a sandwich.','am going to','will','make',2,4),
(121,'A2','multiple_choice','Fill in: She ___ visit her grandmother next Sunday. (plan)','will','is going to','visits',2,5);
END IF;

-- ─── 122: Present Continuous for Future ────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=122)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(122,'A2','multiple_choice','Present Continuous can describe...','habits','future arrangements','past actions',2,1),
(122,'A2','multiple_choice','Which sentence describes a future plan?','I meet my friend tomorrow.','I am meeting my friend tomorrow.','I met my friend tomorrow.',2,2),
(122,'A2','multiple_choice','Fill in: We ___ to Spain next week. (fly)','flew','fly','are flying',3,3),
(122,'A2','multiple_choice','Fill in: She ___ the doctor on Friday. (see)','saw','is seeing','sees',2,4),
(122,'A2','multiple_choice','Which word signals a future arrangement?','yesterday','always','tomorrow',3,5);
END IF;

-- ─── 123: Comparatives and Superlatives ────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=123)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(123,'A2','multiple_choice','What is the comparative of "big"?','biggest','more big','bigger',3,1),
(123,'A2','multiple_choice','What is the superlative of "good"?','the goodest','the most good','the best',3,2),
(123,'A2','multiple_choice','Fill in: This phone is ___ expensive than that one. (more/less)','more','most','the most',1,3),
(123,'A2','multiple_choice','Which is the correct superlative of "happy"?','the happyest','the most happy','the happiest',3,4),
(123,'A2','multiple_choice','Fill in: She is ___ student in the class. (smart — superlative)','smarter','the most smart','the smartest',3,5);
END IF;

-- ─── 124: Adverbs of Manner ─────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=124)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(124,'A2','multiple_choice','What is the adverb form of "slow"?','slowy','slowly','slowful',2,1),
(124,'A2','multiple_choice','What is the adverb form of "good"?','goodly','well','gooder',2,2),
(124,'A2','multiple_choice','What is the adverb form of "bad"?','badly','badful','bedly',1,3),
(124,'A2','multiple_choice','Fill in: She sings ___. (beautiful → adverb)','beautiful','beautifuly','beautifully',3,4),
(124,'A2','multiple_choice','Fill in: He drives ___. (careful → adverb)','careful','carefuly','carefully',3,5);
END IF;

-- ─── 125: A1 Review + A2 Entry Test ────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=125)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(125,'A2','multiple_choice','Fill in: She ___ my sister. (to be, present)','am','is','are',2,1),
(125,'A2','multiple_choice','What is the Past Simple of "drink"?','drinked','drank','drunk',2,2),
(125,'A2','multiple_choice','Which is correct? (comparative)','This bag is more big.','This bag is bigger.','This bag is most big.',2,3),
(125,'A2','multiple_choice','Fill in: I ___ to the gym yesterday. (go)','go','goes','went',3,4),
(125,'A2','multiple_choice','Which question is correct in Past Simple?','Did she worked late?','Did she work late?','Does she worked late?',2,5);
END IF;

-- ─── 126: Present Perfect — основы ─────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=126)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(126,'A2','multiple_choice','How do you form Present Perfect?','subject + did + verb','subject + have/has + Past Participle','subject + was + verb',2,1),
(126,'A2','multiple_choice','Fill in: I ___ visited Paris. (Present Perfect)','have','has','did',1,2),
(126,'A2','multiple_choice','Fill in: She ___ seen this film. (Present Perfect)','have','has','did',2,3),
(126,'A2','multiple_choice','Present Perfect is used to talk about...','actions at a specific past time','life experiences and recent results','future plans',2,4),
(126,'A2','multiple_choice','Fill in: They ___ just arrived. (Present Perfect)','did','has','have',3,5);
END IF;

-- ─── 127: Present Perfect vs Past Simple ───────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=127)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(127,'A2','multiple_choice','Which sentence uses Past Simple correctly?','I have gone to Paris last year.','I went to Paris last year.','I have went to Paris last year.',2,1),
(127,'A2','multiple_choice','Which sentence uses Present Perfect correctly?','I have been to Paris.','I been to Paris.','I was to Paris.',1,2),
(127,'A2','multiple_choice','Which word signals Past Simple?','ever','just','yesterday',3,3),
(127,'A2','multiple_choice','Which word signals Present Perfect?','last week','already','two days ago',2,4),
(127,'A2','multiple_choice','Fill in: I ___ him yesterday. (see — Past Simple)','have seen','seen','saw',3,5);
END IF;

-- ─── 128: have to / don't have to ──────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=128)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(128,'A2','multiple_choice','"have to" expresses...','ability','obligation / necessity','permission',2,1),
(128,'A2','multiple_choice','"don''t have to" means...','it is forbidden','it is not necessary','it is impossible',2,2),
(128,'A2','multiple_choice','Fill in: I ___ wake up early tomorrow. (obligation)','don''t have to','have to','had',2,3),
(128,'A2','multiple_choice','Fill in: You ___ pay — it''s free. (no obligation)','have to','must','don''t have to',3,4),
(128,'A2','multiple_choice','Which is correct?','She have to study.','She has to study.','She haves to study.',2,5);
END IF;

-- ─── 129: Making Suggestions ────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=129)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(129,'A2','multiple_choice','Which phrase makes a suggestion?','I want to go.','Let''s go to the cinema.','I went to the cinema.',2,1),
(129,'A2','multiple_choice','Fill in: ___ don''t we eat pizza tonight?','What','Why','How',2,2),
(129,'A2','multiple_choice','Fill in: ___ we go for a walk?','Will','Shall','Do',2,3),
(129,'A2','multiple_choice','Which means "Тебе стоит отдохнуть"?','You must rest.','You should rest.','You have to rest.',2,4),
(129,'A2','multiple_choice','Fill in: Let''s ___ a film tonight.','watching','watched','watch',3,5);
END IF;

-- ─── 130: Describing People ─────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=130)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(130,'A2','multiple_choice','Which word describes appearance?','friendly','curly hair','outgoing',2,1),
(130,'A2','multiple_choice','Which word describes personality?','slim','tall','outgoing',3,2),
(130,'A2','multiple_choice','Fill in: He is tall ___ short brown hair.','for','with','of',2,3),
(130,'A2','multiple_choice','What does "slim" mean?','худой','высокий','дружелюбный',1,4),
(130,'A2','multiple_choice','Which sentence describes a person correctly?','She has very friendly.','She is very friendly with long hair.','She very friendly.',2,5);
END IF;

-- ─── 131: Food & Restaurants ────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=131)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(131,'A2','multiple_choice','How do you order food politely?','I want the chicken.','Give me chicken.','I''d like the chicken, please.',3,1),
(131,'A2','multiple_choice','How do you ask for the bill?','Could I have the bill?','Where is my money?','I want to pay.',1,2),
(131,'A2','multiple_choice','Fill in: Could I ___ the menu, please?','want','have','take',2,3),
(131,'A2','multiple_choice','What does "I''d like" mean?','Мне нравится','Я хотел бы','Мне не нравится',2,4),
(131,'A2','multiple_choice','Which phrase is polite in a restaurant?','More water!','Can I have some water, please?','Give water.',2,5);
END IF;

-- ─── 132: Travel & Holidays ─────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=132)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(132,'A2','multiple_choice','Fill in: I''m going ___ holiday next month.','in','on','for',2,1),
(132,'A2','multiple_choice','Fill in: We ___ to Spain last summer. (fly — Past Simple)','flyed','flew','flown',2,2),
(132,'A2','multiple_choice','Fill in: I ___ in a nice hotel. (stay — Past Simple)','stayed','staid','have stayed',1,3),
(132,'A2','multiple_choice','What is "отпуск" in English?','trip','holiday','flight',2,4),
(132,'A2','multiple_choice','Fill in: She ___ a lot of photos on holiday. (take — Past Simple)','taked','took','takes',2,5);
END IF;

-- ─── 133: Work & Job Interview ──────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=133)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(133,'A2','multiple_choice','How do you talk about past work experience?','I work as a manager for 2 years.','I worked as a manager for 2 years.','I am working as a manager for 2 years.',2,1),
(133,'A2','multiple_choice','What is "ответственный" in English (personality)?','hardworking','responsible','outgoing',2,2),
(133,'A2','multiple_choice','Fill in: What experience ___ you have? (interview question)','are','do','did',2,3),
(133,'A2','multiple_choice','Fill in: I am ___ and punctual. (трудолюбивый)','responsible','hardworking','friendly',2,4),
(133,'A2','multiple_choice','What is "собеседование" in English?','job offer','interview','workplace',2,5);
END IF;

-- ─── 134: Health & At the Doctor's ─────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=134)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(134,'A2','multiple_choice','How do you say "У меня болит голова"?','My head is hurting.','I have a headache.','I have head pain.',2,1),
(134,'A2','multiple_choice','How do you say "У меня болит горло"?','My throat hurts.','I have throat.','My throat is bad.',1,2),
(134,'A2','multiple_choice','Fill in: I feel ___. (плохо себя чувствую)','sick','good','well',1,3),
(134,'A2','multiple_choice','What does "stomachache" mean?','головная боль','боль в животе','боль в спине',2,4),
(134,'A2','multiple_choice','The doctor says "What''s the matter?" This means...','Что случилось?','Ты здоров?','Что тебе нужно?',1,5);
END IF;

-- ─── 135: Technology & Gadgets ──────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=135)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(135,'A2','multiple_choice','What is "зарядное устройство" in English?','battery','app','charger',3,1),
(135,'A2','multiple_choice','Fill in: My phone ___ is low. (батарея)','charger','battery','laptop',2,2),
(135,'A2','multiple_choice','What is "приложение" in English?','internet','app','smartphone',2,3),
(135,'A2','multiple_choice','Fill in: I use this ___ every day. (приложение)','laptop','app','charger',2,4),
(135,'A2','multiple_choice','What is "социальные сети" in English?','internet','social media','gadgets',2,5);
END IF;

-- ─── 136: Environment & Nature ──────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=136)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(136,'A2','multiple_choice','What is "загрязнение" in English?','recycle','pollution','climate change',2,1),
(136,'A2','multiple_choice','Fill in: We should ___ paper and plastic.','pollute','recycle','plant',2,2),
(136,'A2','multiple_choice','What does "save energy" mean?','загрязнять природу','сажать деревья','экономить энергию',3,3),
(136,'A2','multiple_choice','What is "изменение климата" in English?','pollution','plastic','climate change',3,4),
(136,'A2','multiple_choice','Fill in: We should ___ trees to help the planet.','cut','plant','burn',2,5);
END IF;

-- ─── 137: Free Time & Invitations ───────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=137)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(137,'A2','multiple_choice','How do you invite someone politely?','Come to my party!','Would you like to come to my party?','You come to party.',2,1),
(137,'A2','multiple_choice','How do you decline an invitation politely?','No.','I''m afraid I can''t.','I don''t want.',2,2),
(137,'A2','multiple_choice','Fill in: ___ you like to go to the cinema? (invitation)','Do','Would','Will',2,3),
(137,'A2','multiple_choice','Fill in: I''m afraid I ___. (отказ от приглашения)','won''t','can''t','don''t',2,4),
(137,'A2','multiple_choice','What does "free time" mean?','рабочее время','свободное время','выходные',2,5);
END IF;

-- ─── 138: Past Continuous ───────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=138)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(138,'A2','multiple_choice','How do you form Past Continuous?','subject + was/were + verb-ing','subject + did + verb-ing','subject + have + verb-ing',1,1),
(138,'A2','multiple_choice','Fill in: I ___ TV when the phone rang.','watched','was watching','am watching',2,2),
(138,'A2','multiple_choice','Fill in: She ___ while he was reading.','cooked','is cooking','was cooking',3,3),
(138,'A2','multiple_choice','Past Continuous is used for...','completed past actions','actions in progress at a past moment','future plans',2,4),
(138,'A2','multiple_choice','Fill in: What ___ you doing at 8 PM yesterday?','did','are','were',3,5);
END IF;

-- ─── 139: Too & Enough ──────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=139)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(139,'A2','multiple_choice','"too" goes ___ the adjective.','after','before','without',2,1),
(139,'A2','multiple_choice','"enough" goes ___ the adjective.','before','after','inside',2,2),
(139,'A2','multiple_choice','Fill in: This shirt is ___ small. (слишком)','enough','too','so',2,3),
(139,'A2','multiple_choice','Fill in: This coffee is not hot ___. (достаточно)','too','enough','very',2,4),
(139,'A2','multiple_choice','Which sentence is correct?','It''s enough cold.','It''s too cold.','It''s cold too.',2,5);
END IF;

-- ─── 140: So & Such ─────────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=140)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(140,'A2','multiple_choice','"so" is used before...','a noun','an adjective / adverb','a verb',2,1),
(140,'A2','multiple_choice','"such" is used before...','an adjective alone','a noun phrase (adjective + noun)','a verb',2,2),
(140,'A2','multiple_choice','Fill in: She is ___ kind. (so/such)','such','so','very so',2,3),
(140,'A2','multiple_choice','Fill in: It was ___ a beautiful day.','so','such','too',2,4),
(140,'A2','multiple_choice','Which is correct?','It was so good film.','It was such a good film.','It was such good film.',2,5);
END IF;

-- ─── 141: Mid A2 Review ─────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=141)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(141,'A2','multiple_choice','Fill in: I ___ to London twice. (Present Perfect of "go")','went','have been','have went',2,1),
(141,'A2','multiple_choice','Which is correct? (Past Continuous)','I cooking when you called.','I was cooking when you called.','I cooked when you called.',2,2),
(141,'A2','multiple_choice','Fill in: This bag is ___ heavy to carry. (too/enough)','enough','such','too',3,3),
(141,'A2','multiple_choice','Fill in: ___ you like to go out tonight?','Do','Would','Will',2,4),
(141,'A2','multiple_choice','Fill in: She ___ have to come — it''s optional.','must','doesn''t','don''t',2,5);
END IF;

-- ─── 142: First Conditional ─────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=142)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(142,'A2','multiple_choice','First Conditional describes...','impossible situations','real / likely future situations','past habits',2,1),
(142,'A2','multiple_choice','Which is the correct First Conditional?','If it rains, I stayed home.','If it rains, I will stay home.','If it will rain, I stay home.',2,2),
(142,'A2','multiple_choice','Fill in: If I have time, I ___ call you.','would','will','am',2,3),
(142,'A2','multiple_choice','Fill in: If she studies hard, she ___ pass the exam.','would','will','passed',2,4),
(142,'A2','multiple_choice','Which part of a conditional uses Present Simple?','Both parts','The result clause','The if-clause',3,5);
END IF;

-- ─── 143: Used to ───────────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=143)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(143,'A2','multiple_choice','"used to" describes...','current habits','past habits that stopped','future plans',2,1),
(143,'A2','multiple_choice','Fill in: I ___ play football every day when I was a child.','use to','used to','was used to',2,2),
(143,'A2','multiple_choice','Fill in: She ___ live in a small village.','used to','use to','uses to',1,3),
(143,'A2','multiple_choice','How do you make a negative with "used to"?','I didn''t used to...','I used to not...','I didn''t use to...',3,4),
(143,'A2','multiple_choice','Fill in: He ___ be very shy. (past, now he''s confident)','used to','use to','is used to',1,5);
END IF;

-- ─── 144: Relative Clauses ──────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=144)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(144,'A2','multiple_choice','"who" in relative clauses refers to...','places','things','people',3,1),
(144,'A2','multiple_choice','"which" in relative clauses refers to...','people','things / animals','places',2,2),
(144,'A2','multiple_choice','Fill in: The man ___ lives next door is a doctor.','which','where','who',3,3),
(144,'A2','multiple_choice','Fill in: The book ___ I read was very interesting.','who','where','which',3,4),
(144,'A2','multiple_choice','Which sentence is correct?','This is the girl who helped me.','This is the girl which helped me.','This is the girl where helped me.',1,5);
END IF;

-- ─── 145: Passive Voice ─────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=145)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(145,'A2','multiple_choice','How do you form Passive Voice (Past Simple)?','subject + have + Past Participle','subject + was/were + Past Participle','subject + did + Past Participle',2,1),
(145,'A2','multiple_choice','Fill in: The book ___ written by Tolstoy.','has','was','did',2,2),
(145,'A2','multiple_choice','Fill in: English ___ spoken all over the world.','has','was','is',3,3),
(145,'A2','multiple_choice','Fill in: The car ___ repaired yesterday.','is','has been','was',3,4),
(145,'A2','multiple_choice','How do you turn "They built this house in 1900" into Passive?','This house built in 1900.','This house was built in 1900.','This house is built in 1900.',2,5);
END IF;

-- ─── 146: Phrasal Verbs 1 ───────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=146)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(146,'A2','multiple_choice','What does "get up" mean?','ложиться спать','вставать','уходить',2,1),
(146,'A2','multiple_choice','Fill in: Please ___ on the light — it''s dark.','take','turn','put',2,2),
(146,'A2','multiple_choice','What does "look for" mean?','смотреть на','искать','заботиться о',2,3),
(146,'A2','multiple_choice','Fill in: She ___ off her coat when she entered.','got','looked','took',3,4),
(146,'A2','multiple_choice','Fill in: I ___ up at 7 every morning. (get)','get','gets','getting',1,5);
END IF;

-- ─── 147: Movies, Music & Entertainment ────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=147)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(147,'A2','multiple_choice','Fill in: My favourite ___ is action. (жанр фильма)','actor','genre','director',2,1),
(147,'A2','multiple_choice','Fill in: I prefer ___ music. (рок)','classic','rock','pop',2,2),
(147,'A2','multiple_choice','How do you express opinion about a film?','The film was.','I thought the film was great.','Film great.',2,3),
(147,'A2','multiple_choice','Fill in: I watched a ___ film yesterday. (great)','great','greatly','greater',1,4),
(147,'A2','multiple_choice','What is "режиссёр" in English?','actor','director','producer',2,5);
END IF;

-- ─── 148: Education & School ────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=148)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(148,'A2','multiple_choice','What is "экзамен" in English?','homework','subject','exam',3,1),
(148,'A2','multiple_choice','Fill in: I ___ English and Maths. (study — Present Simple)','studied','study','studying',2,2),
(148,'A2','multiple_choice','What is "университет" in English?','school','college','university',3,3),
(148,'A2','multiple_choice','Fill in: I ___ hard last year. (study — Past Simple)','study','studying','studied',3,4),
(148,'A2','multiple_choice','What is "домашнее задание" in English?','subject','homework','teacher',2,5);
END IF;

-- ─── 149: Mid A2 Consolidation ──────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=149)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(149,'A2','multiple_choice','Fill in: If it ___ tomorrow, we will stay home. (rain)','rained','rains','will rain',2,1),
(149,'A2','multiple_choice','Fill in: The letter ___ sent yesterday. (Passive)','is','was','were',2,2),
(149,'A2','multiple_choice','Fill in: I ___ use to eat vegetables. (I don''t anymore)','used to','didn''t use to','didn''t used to',2,3),
(149,'A2','multiple_choice','Fill in: The woman ___ called you is my aunt. (Relative)','which','where','who',3,4),
(149,'A2','multiple_choice','Fill in: He ___ to be very quiet as a child. (used to)','used','use','uses',1,5);
END IF;

-- ─── 150: Online Shopping & Services ───────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=150)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(150,'A2','multiple_choice','Fill in: I ___ it online. (order — Past Simple)','order','orders','ordered',3,1),
(150,'A2','multiple_choice','Fill in: The package ___ yesterday. (arrive — Past Simple)','arrives','arrived','arriving',2,2),
(150,'A2','multiple_choice','How do you ask about returning an item?','Can I return it?','I want return.','Give me money back.',1,3),
(150,'A2','multiple_choice','Fill in: I ___ these shoes online. (buy — Past Simple)','buyed','bought','buy',2,4),
(150,'A2','multiple_choice','What is "вернуть товар" in English?','order','return it','deliver',2,5);
END IF;

-- ─── 151: News & Current Events ─────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=151)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(151,'A2','multiple_choice','Fill in: There ___ a big accident yesterday.','is','was','were',2,1),
(151,'A2','multiple_choice','Fill in: I ___ the news every morning. (read — Present Simple)','reading','reads','read',3,3),
(151,'A2','multiple_choice','What is "авария/несчастный случай" in English?','event','accident','headline',2,2),
(151,'A2','multiple_choice','Fill in: The president ___ the city last week. (visit)','visits','visited','visiting',2,4),
(151,'A2','multiple_choice','What is "заголовок новости" in English?','article','headline','report',2,5);
END IF;

-- ─── 152: Relationships & Friends ───────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=152)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(152,'A2','multiple_choice','What does "get on well" mean?','ссориться','хорошо ладить','расставаться',2,1),
(152,'A2','multiple_choice','What does "have an argument" mean?','помириться','познакомиться','поссориться',3,2),
(152,'A2','multiple_choice','Fill in: I ___ my best friend 5 years ago. (meet — Past Simple)','meet','met','have met',2,3),
(152,'A2','multiple_choice','Fill in: We always ___ on well. (get — Present Simple)','got','getting','get',3,4),
(152,'A2','multiple_choice','What does "best friend" mean?','знакомый','лучший друг','сосед',2,5);
END IF;

-- ─── 153: Sports & Fitness ──────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=153)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(153,'A2','multiple_choice','Which preposition is used with sports you play?','do','go','play',3,1),
(153,'A2','multiple_choice','Which preposition is used with gym/swimming?','play','go','do',2,2),
(153,'A2','multiple_choice','Fill in: I ___ to the gym three times a week.','play','do','go',3,3),
(153,'A2','multiple_choice','Fill in: I love ___ football. (play — gerund)','to play','playing','played',2,4),
(153,'A2','multiple_choice','How do you ask about exercise habits?','How much you exercise?','How often do you exercise?','How many you exercise?',2,5);
END IF;

-- ─── 154: Reported Speech ───────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=154)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(154,'A2','multiple_choice','He said: "I am tired." → Reported Speech:','He said he is tired.','He said that he was tired.','He told he was tired.',2,1),
(154,'A2','multiple_choice','She said: "I will come." → Reported Speech:','She said she will come.','She told she comes.','She said she would come.',3,2),
(154,'A2','multiple_choice','In Reported Speech, Present Simple usually becomes...','Future Simple','Past Simple','Present Perfect',2,3),
(154,'A2','multiple_choice','Fill in: She ___ me she would come. (tell — Past Simple)','said','told','speaks',2,4),
(154,'A2','multiple_choice','Fill in: He said he ___ happy. (was/is — Reported Speech)','is','will be','was',3,5);
END IF;

-- ─── 155: Phrasal Verbs 2 ───────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=155)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(155,'A2','multiple_choice','What does "give up" mean?','начинать','сдаваться / бросать','продолжать',2,1),
(155,'A2','multiple_choice','What does "look after" mean?','искать','заботиться о','смотреть на',2,2),
(155,'A2','multiple_choice','What does "run out of" mean?','бежать','заканчиваться (о запасах)','спешить',2,3),
(155,'A2','multiple_choice','Fill in: I want to ___ up smoking.','take','give','pick',2,4),
(155,'A2','multiple_choice','Fill in: Can you ___ after my dog while I''m away?','look','give','take',1,5);
END IF;

-- ─── 156: Money & Banking ───────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=156)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(156,'A2','multiple_choice','What is "снять деньги" in English?','deposit','withdraw','loan',2,1),
(156,'A2','multiple_choice','What is "банкомат" in English?','bank','ATM','account',2,2),
(156,'A2','multiple_choice','Fill in: I need to ___ some money from the ATM.','deposit','loan','withdraw',3,3),
(156,'A2','multiple_choice','What is "наличные" in English?','card','cash','change',2,4),
(156,'A2','multiple_choice','What is "сдача" in English?','cash','loan','change',3,5);
END IF;

-- ─── 157: A2 Level Consolidation ────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=157)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(157,'A2','multiple_choice','Fill in: I ___ give up bad habits. (obligation)','don''t have to','have to','must to',2,1),
(157,'A2','multiple_choice','Fill in: The meal ___ cooked by my mother. (Passive, Past)','is','has','was',3,2),
(157,'A2','multiple_choice','Fill in: He said he ___ tired. (Reported Speech)','is','was','has',2,3),
(157,'A2','multiple_choice','Fill in: If you ___ hard, you will succeed.','worked','work','works',2,4),
(157,'A2','multiple_choice','Fill in: I ___ to play chess when I was young. (used to)','used','use','am used',1,5);
END IF;

-- ─── 158: Housework & Daily Chores ─────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=158)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(158,'A2','multiple_choice','What does "do the washing-up" mean?','убирать комнату','мыть посуду','стирать',2,1),
(158,'A2','multiple_choice','What does "take out the rubbish" mean?','выносить мусор','убирать пыль','мыть пол',1,2),
(158,'A2','multiple_choice','Fill in: I ___ my bed every morning. (make — Present Simple)','makes','made','make',3,3),
(158,'A2','multiple_choice','What is "пылесосить" in English?','mop the floor','do the washing-up','vacuum the carpet',3,4),
(158,'A2','multiple_choice','Fill in: She ___ the floor every week. (clean)','cleaning','cleans','cleaned',2,5);
END IF;

-- ─── 159: Crime & Safety ────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=159)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(159,'A2','multiple_choice','What is "ограбление" in English?','accident','robbery','fire',2,1),
(159,'A2','multiple_choice','Fill in: Someone ___ my phone. (steal — Past Simple)','stealed','stolen','stole',3,2),
(159,'A2','multiple_choice','What do you say in an emergency?','Be careful.','Call the police!','Don''t worry.',2,3),
(159,'A2','multiple_choice','What is "полиция" in English?','ambulance','fire brigade','police',3,4),
(159,'A2','multiple_choice','Fill in: There ___ a robbery in our street last night.','is','were','was',3,5);
END IF;

-- ─── 160: Fashion & Style ───────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=160)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(160,'A2','multiple_choice','What does "This dress suits you" mean?','Это платье мне подходит тебе','Тебе идёт это платье','Это платье модное',2,2),
(160,'A2','multiple_choice','What is "в моде" in English?','in fashion','out of style','casual',1,1),
(160,'A2','multiple_choice','Fill in: I prefer ___ clothes. (повседневный)','formal','casual','elegant',2,3),
(160,'A2','multiple_choice','Fill in: I like wearing ___ and T-shirts. (джинсы)','shorts','jeans','trousers',2,4),
(160,'A2','multiple_choice','What is "вышедший из моды" in English?','in fashion','trendy','out of fashion',3,5);
END IF;

-- ─── 161: Dreams & Future Plans ─────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=161)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(161,'A2','multiple_choice','Fill in: I would ___ to travel the world.','like','love','want',1,1),
(161,'A2','multiple_choice','Fill in: I ___ to become a doctor. (hope)','hope','hopes','hoping',1,2),
(161,'A2','multiple_choice','Fill in: In the future I want to live ___. (за границей)','abroad','outside','foreign',1,3),
(161,'A2','multiple_choice','Which expresses a wish?','I went abroad.','I wish I could travel more.','I traveled abroad.',2,4),
(161,'A2','multiple_choice','Fill in: I ___ like to start my own business. (would/will)','will','would','should',2,5);
END IF;

-- ─── 162: Social Media & Communication ─────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=162)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(162,'A2','multiple_choice','What does "post a photo" mean?','удалить фото','опубликовать фото','сохранить фото',2,1),
(162,'A2','multiple_choice','Fill in: I ___ many bloggers on Instagram. (follow — Present Simple)','following','followed','follow',3,2),
(162,'A2','multiple_choice','Fill in: I check my phone too ___. (часто)','much','often','many',2,3),
(162,'A2','multiple_choice','What are advantages of social media?','Staying connected with people','Only wasting time','No benefits',1,4),
(162,'A2','multiple_choice','What is "подписчики" in English?','bloggers','followers','friends',2,5);
END IF;

-- ─── 163: Culture & Traditions ──────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=163)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(163,'A2','multiple_choice','Fill in: We ___ New Year with family. (celebrate — Present Simple)','celebrated','celebrating','celebrate',3,1),
(163,'A2','multiple_choice','How do you talk about traditions?','In my country we celebrate...','My country celebrate...','In my country celebrates...',1,2),
(163,'A2','multiple_choice','Fill in: People usually ___ gifts at Christmas. (give)','gives','giving','give',3,3),
(163,'A2','multiple_choice','What is "традиция" in English?','celebration','culture','tradition',3,4),
(163,'A2','multiple_choice','Fill in: ___ my country, we have many festivals.','At','In','On',2,5);
END IF;

-- ─── 164: Final A2 Review ───────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=164)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(164,'A2','multiple_choice','Fill in: The homework ___ done by all students. (Passive)','is','was','were',2,2),
(164,'A2','multiple_choice','Fill in: If she ___ earlier, she won''t be late. (leave)','left','leaves','leaving',2,1),
(164,'A2','multiple_choice','Fill in: I ___ use to watch cartoons as a child.','used to','use to','did used to',1,3),
(164,'A2','multiple_choice','Fill in: He said he ___ come later. (Reported Speech, will→)','will','would','should',2,4),
(164,'A2','multiple_choice','Fill in: She runs ___. (quick → adverb)','quick','quicker','quickly',3,5);
END IF;

-- ─── 165: Transportation Problems ───────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=165)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(165,'A2','multiple_choice','What does "the train is delayed" mean?','поезд опоздал','поезд отменён','поезд переполнен',1,1),
(165,'A2','multiple_choice','Fill in: I ___ the bus this morning. (пропустил)','lost','missed','left',2,2),
(165,'A2','multiple_choice','What does "my flight was cancelled" mean?','рейс задержан','рейс отменён','рейс переполнен',2,3),
(165,'A2','multiple_choice','Fill in: The traffic is ___. (ужасный)','delayed','terrible','cancelled',2,4),
(165,'A2','multiple_choice','Fill in: I ___ the wrong bus. (take — Past Simple)','taked','took','takes',2,5);
END IF;

-- ─── 166: Personality & Emotions ────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=166)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(166,'A2','multiple_choice','What does "excited" mean?','нервный','взволнованный (позитивно)','злой',2,1),
(166,'A2','multiple_choice','What does "disappointed" mean?','расстроенный/разочарованный','счастливый','удивлённый',1,2),
(166,'A2','multiple_choice','Fill in: I feel ___ before exams. (нервничающий)','proud','nervous','relaxed',2,3),
(166,'A2','multiple_choice','What does "proud" mean?','злой','гордый','обиженный',2,4),
(166,'A2','multiple_choice','Fill in: She felt ___ after winning the competition. (гордая)','nervous','angry','proud',3,5);
END IF;

-- ─── 167: Advertising & Consumer Society ────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=167)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(167,'A2','multiple_choice','Fill in: Advertisements ___ people. (влияют на)','influence','inform','ignore',1,1),
(167,'A2','multiple_choice','What is "реклама" in English?','product','advertisement','consumer',2,2),
(167,'A2','multiple_choice','Fill in: Do you ___ advertisements? (верить)','watch','believe','buy',2,3),
(167,'A2','multiple_choice','What is "потребитель" in English?','seller','consumer','producer',2,4),
(167,'A2','multiple_choice','Fill in: Companies spend a lot on ___. (advertising)','selling','advertising','making',2,5);
END IF;

-- ─── 168: Life Changes & Moving ─────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=168)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(168,'A2','multiple_choice','Fill in: Last year I ___ to another country. (move — Past Simple)','move','moved','moving',2,1),
(168,'A2','multiple_choice','Fill in: Everything ___. (change — Past Simple)','change','changes','changed',3,2),
(168,'A2','multiple_choice','What is "переехать" in English?','travel','move','leave',2,3),
(168,'A2','multiple_choice','Fill in: It was a big ___ for our family. (изменение)','travel','change','move',2,4),
(168,'A2','multiple_choice','Fill in: She ___ a new job and a new flat. (get — Past Simple)','get','gets','got',3,5);
END IF;

-- ─── 169: A2 Complete — Ready for B1 ───────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=169)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(169,'A2','multiple_choice','At A2 level you can...','only say basic words','communicate in most everyday situations','discuss complex topics freely',2,1),
(169,'A2','multiple_choice','Fill in: I have ___ A2. (complete — Present Perfect)','complete','completed','completing',2,2),
(169,'A2','multiple_choice','What level comes after A2?','A1','C1','B1',3,3),
(169,'A2','multiple_choice','To improve from A2 to B1 you should...','stop studying','keep speaking, listening and reading','only read grammar books',2,4),
(169,'A2','multiple_choice','Fill in: You ___ speak English in most daily situations now. (can/could)','could','can','will could',2,5);
END IF;

-- ─── 170: Mysteries & Strange Events ────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=170)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(170,'A2','multiple_choice','Fill in: I ___ something strange last night. (see — Past Simple)','see','seen','saw',3,1),
(170,'A2','multiple_choice','What does "mysterious" mean?','обычный','таинственный','страшный',2,2),
(170,'A2','multiple_choice','Fill in: There ___ a mysterious light in the sky. (was/were)','were','is','was',3,3),
(170,'A2','multiple_choice','Fill in: ___ happened? (What/How — asking about an event)','How','Where','What',3,4),
(170,'A2','multiple_choice','Fill in: Nobody ___ what happened. (know — Past Simple)','knows','know','knew',3,5);
END IF;

-- ─── 171: Success & Failure ─────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=171)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(171,'A2','multiple_choice','What does "succeed" mean?','провалиться','добиться успеха','сдаться',2,1),
(171,'A2','multiple_choice','Fill in: He ___ the exam but tried again. (fail — Past Simple)','failed','fails','failing',1,2),
(171,'A2','multiple_choice','What does "learn from failure" mean?','игнорировать ошибки','учиться на ошибках','избегать трудностей',2,3),
(171,'A2','multiple_choice','Fill in: She ___ in the end. (succeed — Past Simple)','succeed','succeeded','succeeds',2,4),
(171,'A2','multiple_choice','Fill in: Don''t give ___. Try again! (up/in)','in','away','up',3,5);
END IF;

-- ─── 172: Food Around the World ─────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=172)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(172,'A2','multiple_choice','What country is pizza originally from?','France','Spain','Italy',3,1),
(172,'A2','multiple_choice','What is "борщ" in English context?','Italian pasta','Russian borscht','Japanese sushi',2,2),
(172,'A2','multiple_choice','Fill in: I love ___ food from different countries. (try — gerund)','to trying','tried','trying',3,3),
(172,'A2','multiple_choice','Fill in: Sushi is a traditional ___ dish. (Japanese)','Chinese','Japanese','Korean',2,4),
(172,'A2','multiple_choice','Fill in: Can you ___ this dish for me? (describe — request)','described','describing','describe',3,5);
END IF;

-- ─── 173: Future Plans & Predictions ────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=173)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(173,'A2','multiple_choice','Fill in: I ___ probably get a new job next year. (will/would)','would','will','am going',2,1),
(173,'A2','multiple_choice','Fill in: I ___ to become a teacher. (hope)','am hoping to','hope to','hopes to',2,2),
(173,'A2','multiple_choice','Fill in: In 10 years I think I ___ live abroad.','would','will','am',2,3),
(173,'A2','multiple_choice','Which word introduces a prediction?','Yesterday','I think','Because',2,4),
(173,'A2','multiple_choice','Fill in: ___ the future, technology will change everything.','At','On','In',3,5);
END IF;

-- ─── 174: Mysteries 2 / Strange Events ──────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=174)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(174,'A2','multiple_choice','Fill in: The detective ___ the case. (solve — Past Simple)','solves','solved','solving',2,1),
(174,'A2','multiple_choice','What does "evidence" mean?','подозреваемый','улика / доказательство','свидетель',2,2),
(174,'A2','multiple_choice','Fill in: The police ___ for clues. (look — Past Simple)','looks','looked','looking',2,3),
(174,'A2','multiple_choice','What is "свидетель" in English?','suspect','detective','witness',3,4),
(174,'A2','multiple_choice','Fill in: Nobody ___ what really happened. (know — Past)','know','knows','knew',3,5);
END IF;

-- ─── 175: Success & Failure 2 ───────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=175)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(175,'A2','multiple_choice','Fill in: He ___ the exam but tried again.','failed','falling','fails',1,1),
(175,'A2','multiple_choice','What does "achievement" mean?','провал','достижение','цель',2,2),
(175,'A2','multiple_choice','Fill in: I ___ my goal last year. (achieve — Past Simple)','achieve','achieved','achieving',2,3),
(175,'A2','multiple_choice','Fill in: She worked ___ to succeed. (hard — adverb)','hardly','harder','hard',3,4),
(175,'A2','multiple_choice','What is "неудача" in English?','success','failure','challenge',2,5);
END IF;

-- ─── 176: Food Around the World 2 ───────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=176)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(176,'A2','multiple_choice','Fill in: I love ___ new dishes. (try — gerund)','to try','try','trying',3,1),
(176,'A2','multiple_choice','What is "специя" in English?','ingredient','spice','flavour',2,2),
(176,'A2','multiple_choice','Fill in: This soup has a strong ___. (вкус)','smell','flavour','colour',2,3),
(176,'A2','multiple_choice','What country is sushi from?','China','Japan','Korea',2,4),
(176,'A2','multiple_choice','Fill in: I ___ Mexican food for the first time last year. (try)','tried','try','tries',1,5);
END IF;

-- ─── 177: Future Plans & Predictions 2 ─────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=177)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(177,'A2','multiple_choice','Fill in: I ___ probably move to a bigger city. (will/would)','would','will','am going',2,1),
(177,'A2','multiple_choice','What does "prediction" mean?','план','прогноз / предсказание','цель',2,2),
(177,'A2','multiple_choice','Fill in: In the future, people ___ travel to Mars.','would','will','going to',2,3),
(177,'A2','multiple_choice','Fill in: I hope ___ speak English fluently one day.','to','for','at',1,4),
(177,'A2','multiple_choice','Fill in: She ___ probably become a doctor. (will/would)','would','will','is',2,5);
END IF;

-- ─── 178: Famous People & Biographies ───────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=178)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(178,'A2','multiple_choice','Fill in: He ___ born in South Africa. (was/were)','were','is','was',3,1),
(178,'A2','multiple_choice','Fill in: She ___ famous because of her music. (become — Past Simple)','becomes','became','becoming',2,2),
(178,'A2','multiple_choice','What is "биография" in English?','autobiography','biography','diary',2,3),
(178,'A2','multiple_choice','Fill in: He ___ the company in 1994. (found — Past Simple)','found','founded','finding',2,4),
(178,'A2','multiple_choice','Fill in: She ___ many awards during her career. (win — Past Simple)','wins','won','winning',2,5);
END IF;

-- ─── 179: Decisions & Choices ───────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=179)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(179,'A2','multiple_choice','Fill in: I ___ to learn English two years ago. (decide — Past Simple)','decide','decided','deciding',2,1),
(179,'A2','multiple_choice','What does "It was a difficult choice" mean?','Это был лёгкий выбор','Это был сложный выбор','Мне не пришлось выбирать',2,2),
(179,'A2','multiple_choice','Fill in: She had to ___ between two jobs.','chose','choose','choosing',2,3),
(179,'A2','multiple_choice','What is "принять решение" in English?','make a mistake','make a decision','take a choice',2,4),
(179,'A2','multiple_choice','Fill in: In the end I ___ the right decision. (make — Past Simple)','make','making','made',3,5);
END IF;

-- ─── 180: A2 Final Test Preparation ─────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=180)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(180,'A2','multiple_choice','Fill in: The letter ___ sent by email. (Passive, Past)','is','was','were',2,1),
(180,'A2','multiple_choice','Fill in: If she ___ early, she won''t miss the bus. (leave)','left','leaves','will leave',2,2),
(180,'A2','multiple_choice','Fill in: He said he ___ come. (Reported Speech, will→)','will','would','should',2,3),
(180,'A2','multiple_choice','Fill in: I ___ use to live in Moscow. (past habit)','used to','use to','did use to',1,4),
(180,'A2','multiple_choice','Fill in: She is the ___ student in the class. (smart — superlative)','smarter','most smart','smartest',3,5);
END IF;

-- ─── 181: A2 Graduation ─────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=181)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(181,'A2','multiple_choice','Completing A2 means you can...','only introduce yourself','communicate in most everyday situations','give academic lectures',2,1),
(181,'A2','multiple_choice','Fill in: I have ___ A2! (complete — Present Perfect)','complete','completed','completing',2,2),
(181,'A2','multiple_choice','What level comes after A2?','A3','B1','B2',2,3),
(181,'A2','multiple_choice','Fill in: You ___ communicate at work and while travelling now.','must','can','have to',2,4),
(181,'A2','multiple_choice','Fill in: Keep ___, listening and reading to reach B1. (speak — gerund)','to speak','spoke','speaking',3,5);
END IF;

-- ─── 182: AI & Future ────────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=182)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(182,'A2','multiple_choice','Fill in: AI ___ change our lives in the future. (will/would)','would','will','is going',2,1),
(182,'A2','multiple_choice','Fill in: Robots ___ do many jobs in the future.','would','will','can going to',2,2),
(182,'A2','multiple_choice','What does "artificial intelligence" mean?','настоящий разум','искусственный интеллект','умная машина',2,3),
(182,'A2','multiple_choice','Fill in: I think AI is very useful ___ dangerous. (но)','or','but','so',2,4),
(182,'A2','multiple_choice','Fill in: Technology ___ many things possible. (make — Present Simple)','makes','made','making',1,5);
END IF;

-- ─── 183: Mental Health & Emotions ──────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=183)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(183,'A2','multiple_choice','Fill in: I sometimes feel ___. (тревожный)','excited','anxious','proud',2,1),
(183,'A2','multiple_choice','What does "stressed" mean?','расслабленный','в стрессе','грустный',2,2),
(183,'A2','multiple_choice','Fill in: You ___ talk to someone if you feel sad. (совет)','must','should','have to',2,3),
(183,'A2','multiple_choice','What helps when you feel stressed?','работать больше','exercise and rest','ignore the problem',2,4),
(183,'A2','multiple_choice','Fill in: She feels ___ about the presentation tomorrow. (нервничает)','relaxed','nervous','proud',2,5);
END IF;

-- ─── 184: Global Issues ──────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=184)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(184,'A2','multiple_choice','What is "бедность" in English?','inequality','poverty','war',2,1),
(184,'A2','multiple_choice','Fill in: Climate change is a big ___. (проблема)','solution','idea','problem',3,2),
(184,'A2','multiple_choice','What is "неравенство" in English?','poverty','war','inequality',3,3),
(184,'A2','multiple_choice','Fill in: We ___ protect the environment. (должны)','can','should','would',2,4),
(184,'A2','multiple_choice','What is "образование для всех" in English?','education for all','school for rich','free university',1,5);
END IF;

-- ─── 185: Life Lessons & Wisdom ─────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=185)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(185,'A2','multiple_choice','Fill in: The ___ things in life are free. (лучший — superlative)','better','more best','best',3,1),
(185,'A2','multiple_choice','Fill in: I ___ that hard work always pays off. (believe — Present Simple)','believed','believing','believe',3,2),
(185,'A2','multiple_choice','Fill in: What would you tell your ___ self? (младший — young)','youngest','younger','young',2,3),
(185,'A2','multiple_choice','What does "the most important thing is..." mean?','самое трудное...','самое важное...','самое интересное...',2,4),
(185,'A2','multiple_choice','Fill in: I ___ a lot from that experience. (learn — Past Simple)','learn','learned','learning',2,5);
END IF;

-- ─── 186: A2 Final Test ──────────────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=186)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(186,'A2','multiple_choice','Fill in: English ___ spoken in many countries. (Passive)','was','is','were',2,1),
(186,'A2','multiple_choice','Fill in: If you ___ now, you''ll be late. (not leave)','don''t leave','didn''t leave','won''t leave',1,2),
(186,'A2','multiple_choice','Fill in: She said she ___ tired. (Reported, is→)','is','was','will be',2,3),
(186,'A2','multiple_choice','Fill in: I ___ use to have long hair. (past habit, now short)','used to','use to','am used to',1,4),
(186,'A2','multiple_choice','Fill in: The man ___ helped me was a teacher. (Relative)','which','where','who',3,5);
END IF;

-- ─── 187: A2 Graduation Final ───────────────────────────────────────
IF (SELECT COUNT(*) FROM questions WHERE lesson_id=187)=0 THEN
INSERT INTO questions(lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
(187,'A2','multiple_choice','Fill in: I ___ A2! (complete — Present Perfect)','complete','completing','have completed',3,1),
(187,'A2','multiple_choice','At A2 you can communicate...','только в школе','comfortably in most real situations','только с детьми',2,2),
(187,'A2','multiple_choice','Fill in: I can now live, work and ___ in English. (travel)','traveled','travelling','travel',3,3),
(187,'A2','multiple_choice','What is the next step after A2?','A1','B1','C1',2,4),
(187,'A2','multiple_choice','Fill in: Keep ___ every day to reach B1 faster. (practice — gerund)','to practice','practiced','practising',3,5);
END IF;

END $$;
