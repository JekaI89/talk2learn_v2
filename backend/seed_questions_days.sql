-- Практика к уроку id=57 "Дни недели и месяцы" (A1)
-- Добавляет вопросы только если их ещё нет
-- Запуск: psql $DATABASE_URL -f seed_questions_days.sql

DO $$
BEGIN
  IF (SELECT COUNT(*) FROM questions WHERE lesson_id = 57) = 0 THEN

    INSERT INTO questions (lesson_id, level, task_type, question_text, option_1, option_2, option_3, correct_option, order_num) VALUES
      (57,'A1','multiple_choice',
       'Which day comes after Tuesday?',
       'Monday','Thursday','Wednesday', 3, 1),

      (57,'A1','multiple_choice',
       'What is the 6th month of the year?',
       'July','May','June', 3, 2),

      (57,'A1','multiple_choice',
       'Which preposition do we use with days? ___ Monday',
       'in','at','on', 3, 3),

      (57,'A1','multiple_choice',
       'Which preposition do we use with months? ___ July',
       'on','in','at', 2, 4),

      (57,'A1','multiple_choice',
       'What are "weekdays"?',
       'Saturday and Sunday','Monday to Friday','All 7 days', 2, 5),

      (57,'A1','multiple_choice',
       'How do you say "Среда" in English?',
       'Tuesday','Thursday','Wednesday', 3, 6),

      (57,'A1','multiple_choice',
       'Which month comes after March?',
       'February','May','April', 3, 7),

      (57,'A1','multiple_choice',
       'Days and months in English are written with a...',
       'small letter','capital letter','number', 2, 8),

      (57,'A1','multiple_choice',
       'What is the last month of the year?',
       'November','January','December', 3, 9),

      (57,'A1','multiple_choice',
       'My birthday is ___ December. Choose the right preposition.',
       'on','in','at', 2, 10);

    RAISE NOTICE 'Добавлено 10 вопросов к уроку 57 (Дни недели и месяцы)';
  ELSE
    RAISE NOTICE 'Вопросы к уроку 57 уже существуют — пропускаем';
  END IF;
END $$;
