-- A1 уроки 11–20 (идемпотентный, без перезаписи)
-- Запуск: psql $DATABASE_URL -f seed_a1_part2.sql

DO $$
DECLARE
  lid INTEGER;
BEGIN

  -- 11. Артикли
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Артикли: a, an, the' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Артикли: a, an, the',
'📌 <b>Articles: a, an, the</b>

Артикли — маленькие слова перед существительными. В русском их нет, но в английском они обязательны.

<b>Неопределённый артикль a / an:</b>
• a — перед согласными: <b>a</b> cat, <b>a</b> book, <b>a</b> dog
• an — перед гласными (a, e, i, o, u): <b>an</b> apple, <b>an</b> egg, <b>an</b> orange

Используй a/an когда говоришь о предмете впервые или об одном из многих:
• I have <b>a</b> car. — У меня есть машина (одна из многих).
• She is <b>an</b> engineer. — Она инженер.

<b>Определённый артикль the:</b>
Используй the когда собеседник знает, о чём ты говоришь:
• Pass me <b>the</b> salt. — Передай мне соль (ту, что на столе).
• <b>The</b> sun is hot. — Солнце горячее (единственное).

<b>Когда артикль не нужен:</b>
• Перед именами: <b>Anna</b> is my friend.
• Перед странами (обычно): I live in <b>Russia</b>.
• Перед едой/спортом в общем смысле: I like <b>coffee</b>. He plays <b>football</b>.

💡 Совет: Начинай слово с гласного звука — пиши an. Начинается на согласный — пиши a.','lesson',11,TRUE,'en');
    GET DIAGNOSTICS lid = ROW_COUNT;
    RAISE NOTICE 'Добавлен урок 11: Артикли a, an, the';
  ELSE RAISE NOTICE 'Пропущен: Артикли a, an, the';
  END IF;

  -- 12. Числа 20-1000
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Числа от 20 до 1000' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Числа от 20 до 1000',
'🔢 <b>Numbers 20–1000</b>

<b>Десятки:</b>
• 20 — twenty
• 30 — thirty
• 40 — forty
• 50 — fifty
• 60 — sixty
• 70 — seventy
• 80 — eighty
• 90 — ninety

<b>Составные числа (21–99):</b>
Десяток + единица через дефис:
• 21 — twenty-one
• 35 — thirty-five
• 47 — forty-seven
• 99 — ninety-nine

<b>Сотни:</b>
• 100 — one hundred
• 200 — two hundred
• 500 — five hundred
• 1000 — one thousand

<b>Составные с сотнями:</b>
• 101 — one hundred and one
• 250 — two hundred and fifty
• 999 — nine hundred and ninety-nine

<b>Примеры в речи:</b>
• My phone number is 495 — four nine five.
• The price is $35 — thirty-five dollars.
• She is 42 years old — forty-two years old.

💡 Совет: forty пишется без «u» (не fourty!). Это одна из самых частых ошибок.','lesson',12,TRUE,'en');
    RAISE NOTICE 'Добавлен урок 12: Числа 20-1000';
  ELSE RAISE NOTICE 'Пропущен: Числа 20-1000';
  END IF;

  -- 13. Время
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Время: который час?' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Время: который час?',
'🕐 <b>Telling the Time</b>

<b>Как спросить время:</b>
• What time is it? — Который час?
• What''s the time? — Сколько времени?

<b>Ответы — точный час:</b>
• It''s one o''clock. — 1:00
• It''s three o''clock. — 3:00
• It''s twelve o''clock. — 12:00

<b>Минуты:</b>
• It''s half past two. — 2:30 (половина третьего)
• It''s quarter past five. — 5:15 (четверть шестого)
• It''s quarter to eight. — 7:45 (без четверти восемь)
• It''s ten past six. — 6:10 (десять минут седьмого)
• It''s twenty to nine. — 8:40 (без двадцати девять)

<b>AM и PM:</b>
• 9:00 AM — утро (9 утра)
• 3:00 PM — день/вечер (15:00)
• at noon — в полдень
• at midnight — в полночь

<b>Полезные фразы:</b>
• I wake up at 7 AM. — Я просыпаюсь в 7 утра.
• The meeting is at 2 PM. — Встреча в 14:00.
• See you at half past three! — Увидимся в 3:30!

💡 Совет: В США используют 12-часовой формат с AM/PM. В Британии — оба варианта.','lesson',13,TRUE,'en');
    RAISE NOTICE 'Добавлен урок 13: Время';
  ELSE RAISE NOTICE 'Пропущен: Время';
  END IF;

  -- 14. Еда и напитки
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Еда и напитки' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Еда и напитки',
'🍽️ <b>Food & Drinks</b>

<b>Завтрак (Breakfast):</b>
• bread — хлеб 🍞
• butter — масло
• egg — яйцо 🥚
• milk — молоко 🥛
• coffee — кофе ☕
• tea — чай 🍵
• juice — сок 🧃

<b>Обед и ужин (Lunch & Dinner):</b>
• soup — суп 🍲
• salad — салат 🥗
• meat — мясо 🥩
• chicken — курица 🍗
• fish — рыба 🐟
• rice — рис 🍚
• pasta — паста 🍝
• vegetables — овощи 🥦

<b>Фрукты (Fruit):</b>
• apple — яблоко 🍎
• banana — банан 🍌
• orange — апельсин 🍊
• strawberry — клубника 🍓

<b>Полезные фразы:</b>
• I like pizza. — Мне нравится пицца.
• I don''t eat meat. — Я не ем мясо.
• Can I have a coffee, please? — Можно кофе, пожалуйста?
• I''m hungry! — Я голоден!
• I''m thirsty. — Я хочу пить.

💡 Совет: Слово «food» не имеет множественного числа. Нельзя сказать «foods» — только «food».','lesson',14,TRUE,'en');
    RAISE NOTICE 'Добавлен урок 14: Еда и напитки';
  ELSE RAISE NOTICE 'Пропущен: Еда и напитки';
  END IF;

  -- 15. Тело человека
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Части тела' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Части тела',
'🧍 <b>Parts of the Body</b>

<b>Голова (Head):</b>
• head — голова
• hair — волосы
• eye — глаз 👁️
• ear — ухо 👂
• nose — нос
• mouth — рот
• tooth / teeth — зуб / зубы
• face — лицо

<b>Тело (Body):</b>
• neck — шея
• shoulder — плечо
• arm — рука (от плеча до кисти)
• hand — кисть руки ✋
• finger — палец
• chest — грудь
• back — спина
• stomach — живот
• leg — нога (от бедра до стопы)
• knee — колено
• foot / feet — стопа / стопы

<b>Полезные фразы:</b>
• My head hurts. — У меня болит голова.
• I have a toothache. — У меня болит зуб.
• Show me your hands! — Покажи руки!
• My back is sore. — У меня болит спина.

💡 Совет: foot → feet, tooth → teeth — неправильное множественное число. Запомни эти исключения!','lesson',15,TRUE,'en');
    RAISE NOTICE 'Добавлен урок 15: Части тела';
  ELSE RAISE NOTICE 'Пропущен: Части тела';
  END IF;

  -- 16. Погода
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Погода' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Погода',
'🌤️ <b>Weather</b>

<b>Как спросить о погоде:</b>
• What''s the weather like today? — Какая сегодня погода?
• What''s the weather like in Moscow? — Какая погода в Москве?

<b>Описание погоды:</b>
• It''s sunny. — Солнечно. ☀️
• It''s cloudy. — Облачно. ☁️
• It''s raining. — Идёт дождь. 🌧️
• It''s snowing. — Идёт снег. ❄️
• It''s windy. — Ветрено. 🌬️
• It''s foggy. — Туманно. 🌫️
• It''s cold. — Холодно. 🥶
• It''s hot. — Жарко. 🥵
• It''s warm. — Тепло.
• It''s freezing! — Мороз!

<b>Температура:</b>
• It''s 25 degrees. — 25 градусов.
• It''s minus ten. — Минус десять.

<b>Сезоны (Seasons):</b>
• spring — весна 🌸
• summer — лето ☀️
• autumn / fall — осень 🍂
• winter — зима ❄️

<b>Полезные фразы:</b>
• Take an umbrella! — Возьми зонт!
• Dress warmly! — Одевайся тепло!
• I love summer! — Я люблю лето!

💡 Совет: Всегда используй «It''s» для описания погоды. Нельзя сказать просто «Is sunny» — только «It''s sunny».','lesson',16,TRUE,'en');
    RAISE NOTICE 'Добавлен урок 16: Погода';
  ELSE RAISE NOTICE 'Пропущен: Погода';
  END IF;

  -- 17. Дом
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Дом и комнаты' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Дом и комнаты',
'🏠 <b>Home & Rooms</b>

<b>Типы жилья:</b>
• house — дом (отдельный)
• flat / apartment — квартира
• room — комната

<b>Комнаты (Rooms):</b>
• living room — гостиная
• bedroom — спальня 🛏️
• kitchen — кухня 🍳
• bathroom — ванная комната 🛁
• toilet — туалет
• hall / hallway — прихожая, коридор
• balcony — балкон

<b>Мебель и предметы (Furniture):</b>
• sofa / couch — диван 🛋️
• table — стол
• chair — стул
• bed — кровать
• wardrobe — шкаф
• window — окно
• door — дверь
• lamp — лампа
• fridge — холодильник
• TV — телевизор 📺

<b>Полезные фразы:</b>
• I live in a flat. — Я живу в квартире.
• My room is on the second floor. — Моя комната на втором этаже.
• The kitchen is next to the bathroom. — Кухня рядом с ванной.
• Come in! — Войдите!

💡 Совет: В Британии говорят «flat», в Америке — «apartment». В Британии первый этаж — «ground floor», второй — «first floor».','lesson',17,TRUE,'en');
    RAISE NOTICE 'Добавлен урок 17: Дом и комнаты';
  ELSE RAISE NOTICE 'Пропущен: Дом и комнаты';
  END IF;

  -- 18. Профессии
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Профессии' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Профессии',
'👔 <b>Jobs & Professions</b>

<b>Распространённые профессии:</b>
• doctor — врач 👨‍⚕️
• nurse — медсестра / медбрат
• teacher — учитель 👨‍🏫
• student — студент
• engineer — инженер
• programmer — программист 💻
• manager — менеджер
• driver — водитель 🚗
• cook / chef — повар 🍳
• waiter — официант
• police officer — полицейский 👮
• firefighter — пожарный 🧑‍🚒
• builder — строитель
• farmer — фермер
• artist — художник 🎨
• singer — певец 🎤

<b>Как сказать о профессии:</b>
• I am a doctor. — Я врач.
• She is a teacher. — Она учительница.
• He works as an engineer. — Он работает инженером.
• What do you do? — Кем вы работаете?
• I work in a hospital. — Я работаю в больнице.

<b>Место работы:</b>
• office — офис
• school — школа
• hospital — больница
• shop / store — магазин
• factory — завод

💡 Совет: После «I am» и «She is» перед профессией ставится артикль a/an: «I am <b>a</b> teacher», «She is <b>an</b> engineer».','lesson',18,TRUE,'en');
    RAISE NOTICE 'Добавлен урок 18: Профессии';
  ELSE RAISE NOTICE 'Пропущен: Профессии';
  END IF;

  -- 19. Транспорт
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='Транспорт' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','Транспорт',
'🚌 <b>Transport</b>

<b>Виды транспорта:</b>
• car — машина 🚗
• bus — автобус 🚌
• train — поезд 🚂
• metro / subway — метро 🚇
• tram — трамвай
• taxi — такси 🚕
• plane — самолёт ✈️
• ship / boat — корабль / лодка 🚢
• bike / bicycle — велосипед 🚲
• motorcycle — мотоцикл
• on foot — пешком 🚶

<b>Глагол: как добираться — «by»:</b>
• by car — на машине
• by bus — на автобусе
• by train — на поезде
• by plane — на самолёте
• on foot — пешком (без «by»!)

<b>Полезные фразы:</b>
• How do you get to work? — Как вы добираетесь до работы?
• I go by metro. — Я езжу на метро.
• The bus stop is near here. — Остановка автобуса рядом.
• How long does it take? — Сколько времени это занимает?
• It takes 20 minutes. — Это занимает 20 минут.
• Where is the nearest station? — Где ближайшая станция?

💡 Совет: Говорят «on foot», а не «by foot» — это исключение! Запомни: пешком всегда on foot.','lesson',19,TRUE,'en');
    RAISE NOTICE 'Добавлен урок 19: Транспорт';
  ELSE RAISE NOTICE 'Пропущен: Транспорт';
  END IF;

  -- 20. Покупки
  IF NOT EXISTS (SELECT 1 FROM lessons WHERE title='В магазине: покупки' AND level='A1') THEN
    INSERT INTO lessons (level,title,lesson_text,content_type,order_num,is_active,language)
    VALUES ('A1','В магазине: покупки',
'🛍️ <b>Shopping</b>

<b>Виды магазинов:</b>
• supermarket — супермаркет
• shop / store — магазин
• bakery — булочная 🥖
• pharmacy — аптека 💊
• clothes shop — магазин одежды
• market — рынок

<b>Диалог в магазине:</b>
• Can I help you? — Могу я вам помочь?
• I''m just looking, thanks. — Я просто смотрю, спасибо.
• How much is this? — Сколько это стоит?
• It''s ten pounds / dollars. — Это стоит 10 фунтов / долларов.
• I''ll take it! — Я возьму это!
• Do you have this in a larger size? — Есть ли это в большем размере?
• Can I pay by card? — Можно оплатить картой?
• Cash or card? — Наличные или карта?

<b>Цены и деньги:</b>
• price — цена
• cheap — дёшево
• expensive — дорого
• discount / sale — скидка
• receipt — чек
• change — сдача

<b>Одежда (Clothes):</b>
• T-shirt — футболка
• jeans — джинсы
• dress — платье 👗
• shoes — туфли / ботинки 👟
• jacket — куртка

💡 Совет: «How much is it?» — для одного предмета. «How much are they?» — для нескольких (jeans, shoes и т.д.).','lesson',20,TRUE,'en');
    RAISE NOTICE 'Добавлен урок 20: Покупки';
  ELSE RAISE NOTICE 'Пропущен: Покупки';
  END IF;

END $$;
