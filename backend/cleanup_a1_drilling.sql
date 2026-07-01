-- Remove "🔁 Drilling Exercises" sections from A1 lesson_text
-- Safe to run multiple times (idempotent)
UPDATE lessons
SET lesson_text = TRIM(SPLIT_PART(lesson_text, '🔁', 1))
WHERE level = 'A1'
  AND lesson_text LIKE '%🔁%';

-- Verify result
SELECT id, title,
       CASE WHEN lesson_text LIKE '%🔁%' THEN 'STILL HAS DRILLING' ELSE 'OK' END as status
FROM lessons
WHERE level = 'A1' AND is_active = TRUE
ORDER BY id;
