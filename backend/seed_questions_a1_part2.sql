-- Вопросы к урокам A1 11–20 (ids 61–70)
-- Идемпотентный: добавляет вопросы только если их нет
-- Запуск: psql $DATABASE_URL -f seed_questions_a1_part2.sql

DO $$
DECLARE
  lid INTEGER;
BEGIN

  -- 11. Артикли (id=61)
  SELECT id INTO lid FROM lessons WHERE title='Артикли: a, an, the' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','Which article do you use before "apple"?','a','an','the',2,1),
      (lid,'A1','multiple_choice','Fill in: She is ___ engineer.','a','an','the',2,2),
      (lid,'A1','multiple_choice','Fill in: I have ___ car.','a','an','the',1,3),
      (lid,'A1','multiple_choice','When do we NOT use an article?','Before nouns','Before names','Before adjectives',2,4),
      (lid,'A1','multiple_choice','Fill in: ___ sun is very hot today.','A','An','The',3,5);
    RAISE NOTICE 'Добавлены вопросы: Артикли';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Артикли (id=%)', lid;
  END IF;

  -- 12. Числа 20-1000 (id=62)
  SELECT id INTO lid FROM lessons WHERE title='Числа от 20 до 1000' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','How do you write 40 in English?','Fourty','Forty','Foorty',2,1),
      (lid,'A1','multiple_choice','What is "seventy-five" in numbers?','57','75','750',2,2),
      (lid,'A1','multiple_choice','How do you say 100?','One thousands','Ten hundred','One hundred',3,3),
      (lid,'A1','multiple_choice','Fill in: The price is ___ dollars. (35)','thirty five','thirty-five','thirdy-five',2,4),
      (lid,'A1','multiple_choice','How do you say 250?','Two hundred and fifty','Two fifty hundred','Twenty fifty',1,5);
    RAISE NOTICE 'Добавлены вопросы: Числа 20-1000';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Числа 20-1000 (id=%)', lid;
  END IF;

  -- 13. Время (id=63)
  SELECT id INTO lid FROM lessons WHERE title='Время: который час?' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','How do you ask the time?','What is clock?','What time is it?','How time is?',2,1),
      (lid,'A1','multiple_choice','It''s 2:30. How do you say it?','Half to two','Quarter past two','Half past two',3,2),
      (lid,'A1','multiple_choice','It''s 7:45. How do you say it?','Quarter past seven','Quarter to eight','Half past seven',2,3),
      (lid,'A1','multiple_choice','9 AM means...','9 in the evening','9 at night','9 in the morning',3,4),
      (lid,'A1','multiple_choice','How do you say 5:15?','Quarter to five','Half past five','Quarter past five',3,5);
    RAISE NOTICE 'Добавлены вопросы: Время';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Время (id=%)', lid;
  END IF;

  -- 14. Еда и напитки (id=64)
  SELECT id INTO lid FROM lessons WHERE title='Еда и напитки' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','What is "молоко" in English?','Juice','Milk','Water',2,1),
      (lid,'A1','multiple_choice','Which word is a vegetable?','Apple','Chicken','Salad',3,2),
      (lid,'A1','multiple_choice','How do you say "Я голоден"?','I''m thirsty','I''m hungry','I''m tired',2,3),
      (lid,'A1','multiple_choice','Can you say "foods"?','Yes, always','No, food has no plural','Only in restaurants',2,4),
      (lid,'A1','multiple_choice','What meal is "завтрак"?','Lunch','Dinner','Breakfast',3,5);
    RAISE NOTICE 'Добавлены вопросы: Еда и напитки';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Еда и напитки (id=%)', lid;
  END IF;

  -- 15. Части тела (id=65)
  SELECT id INTO lid FROM lessons WHERE title='Части тела' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','What is the plural of "foot"?','Foots','Feet','Feets',2,1),
      (lid,'A1','multiple_choice','What is "колено" in English?','Elbow','Shoulder','Knee',3,2),
      (lid,'A1','multiple_choice','My head hurts. What does it mean?','У меня болит рука','У меня болит голова','У меня болит нога',2,3),
      (lid,'A1','multiple_choice','What is the plural of "tooth"?','Tooths','Teeths','Teeth',3,4),
      (lid,'A1','multiple_choice','What is "arm" in Russian?','Нога','Рука (от плеча до кисти)','Палец',2,5);
    RAISE NOTICE 'Добавлены вопросы: Части тела';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Части тела (id=%)', lid;
  END IF;

  -- 16. Погода (id=66)
  SELECT id INTO lid FROM lessons WHERE title='Погода' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','How do you say "Идёт дождь"?','It''s snowing','It''s raining','It''s windy',2,1),
      (lid,'A1','multiple_choice','What is "лето" in English?','Spring','Autumn','Summer',3,2),
      (lid,'A1','multiple_choice','Fill in: ___ sunny today.','Is','It''s','Its',2,3),
      (lid,'A1','multiple_choice','How do you ask about the weather?','How is weather?','What''s the weather like?','Is weather good?',2,4),
      (lid,'A1','multiple_choice','What does "It''s freezing" mean?','Очень жарко','Пасмурно','Очень холодно / мороз',3,5);
    RAISE NOTICE 'Добавлены вопросы: Погода';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Погода (id=%)', lid;
  END IF;

  -- 17. Дом и комнаты (id=67)
  SELECT id INTO lid FROM lessons WHERE title='Дом и комнаты' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','What is "кухня" in English?','Bedroom','Kitchen','Bathroom',2,1),
      (lid,'A1','multiple_choice','What is a "flat"?','A house','An apartment','A room',2,2),
      (lid,'A1','multiple_choice','What is "холодильник" in English?','Wardrobe','Lamp','Fridge',3,3),
      (lid,'A1','multiple_choice','In British English, ground floor is...','The second floor','The first floor','The basement',2,4),
      (lid,'A1','multiple_choice','What is "гостиная" in English?','Hallway','Bedroom','Living room',3,5);
    RAISE NOTICE 'Добавлены вопросы: Дом и комнаты';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Дом и комнаты (id=%)', lid;
  END IF;

  -- 18. Профессии (id=68)
  SELECT id INTO lid FROM lessons WHERE title='Профессии' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','Fill in: She is ___ engineer.','a','an','the',2,1),
      (lid,'A1','multiple_choice','What is "врач" in English?','Nurse','Teacher','Doctor',3,2),
      (lid,'A1','multiple_choice','How do you ask about someone''s job?','What are you?','What do you do?','Where is your job?',2,3),
      (lid,'A1','multiple_choice','What is "повар" in English?','Waiter','Cook','Driver',2,4),
      (lid,'A1','multiple_choice','He works ___ a hospital. Choose the right preposition.','on','at','in',3,5);
    RAISE NOTICE 'Добавлены вопросы: Профессии';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Профессии (id=%)', lid;
  END IF;

  -- 19. Транспорт (id=69)
  SELECT id INTO lid FROM lessons WHERE title='Транспорт' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','How do you say "на метро"?','by subway','in metro','on metro',1,1),
      (lid,'A1','multiple_choice','How do you say "пешком"?','by foot','on foot','with foot',2,2),
      (lid,'A1','multiple_choice','How do you ask "Как вы добираетесь до работы?"?','How do you go to work?','How do you get to work?','Where do you work?',2,3),
      (lid,'A1','multiple_choice','What is "самолёт" in English?','Ship','Train','Plane',3,4),
      (lid,'A1','multiple_choice','It takes 20 minutes means...','Это стоит 20 минут','Это занимает 20 минут','Это далеко на 20 минут',2,5);
    RAISE NOTICE 'Добавлены вопросы: Транспорт';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Транспорт (id=%)', lid;
  END IF;

  -- 20. Покупки (id=70)
  SELECT id INTO lid FROM lessons WHERE title='В магазине: покупки' AND level='A1';
  IF lid IS NOT NULL AND (SELECT COUNT(*) FROM questions WHERE lesson_id=lid) = 0 THEN
    INSERT INTO questions (lesson_id,level,task_type,question_text,option_1,option_2,option_3,correct_option,order_num) VALUES
      (lid,'A1','multiple_choice','How do you ask the price?','What is the cost it?','How much is this?','What price is it?',2,1),
      (lid,'A1','multiple_choice','What is "дёшево" in English?','Expensive','Cheap','Free',2,2),
      (lid,'A1','multiple_choice','How do you say "Можно оплатить картой?"?','Can I pay by card?','Can I card pay?','I want card pay.',1,3),
      (lid,'A1','multiple_choice','How do you say "Я просто смотрю"?','I''m just looking','I just see','I only watch',1,4),
      (lid,'A1','multiple_choice','How much ___ they? (jeans). Choose the right form.','is','are','be',2,5);
    RAISE NOTICE 'Добавлены вопросы: Покупки';
  ELSE RAISE NOTICE 'Пропущен или уже есть: Покупки (id=%)', lid;
  END IF;

END $$;
