-- Создаем ограничение на уникальность в таблице (не знаю почему, но параметр UNIQUE, указанный при создании таблицы не сработал)
ALTER TABLE musical_genres ADD CONSTRAINT unique_musical_genre_name UNIQUE(name);

-- Наполняем таблицу музыкальными жанрами
INSERT INTO musical_genres (name)
VALUES 
('hip-hop'),
('pop'),
('pop-soul'),
('estrada'),
('rap'),
('r&b'),
('lounge-jazz'),
('jazz-pop')
ON CONFLICT (name) DO NOTHING;

-- Создаем ограничение на уникальность в таблице (не знаю почему, но параметр UNIQUE, указанный при создании таблицы не сработал)
ALTER TABLE music_artist ADD CONSTRAINT unique_music_artist_name UNIQUE(name);

-- Наполняем таблицу музыкальными исполнителями
INSERT INTO music_artist (name)
VALUES
('Баста'),
('Егор Крид'),
('Валерий Меладзе'),
('Полина Гагарина')
ON CONFLICT (name) DO NOTHING;

-- Добавляем связь между жанрами и исполнителями
INSERT INTO artist_genres (artist_id, musical_genre_id)
SELECT ma.artist_id AS artist_id, mg.musical_genre_id AS musical_genre_id
FROM music_artist AS ma
CROSS JOIN musical_genres AS mg
WHERE 
    (ma.name = 'Баста' AND mg.name IN ('hip-hop', 'rap')) OR
    (ma.name = 'Егор Крид' AND mg.name IN ('pop', 'r&b')) OR
    (ma.name = 'Валерий Меладзе' AND mg.name IN ('estrada', 'pop')) OR
    (ma.name = 'Полина Гагарина' AND mg.name IN ('pop', 'pop-soul'))
ON CONFLICT DO NOTHING;

-- Наполняем таблицу музыкальными альбомами
INSERT INTO music_album (name, year)
VALUES 
('Баста 4', 2011),
('Что они знают?', 2015),
('Полет бумеранга', 2004),
('9', 2013),
('Звезда и Смерть Хоакина Мурьеты', 2016),
('50 оттенков Крида', 2017),
('Амелия', 2000),
('7', 2017),
('Город дорог', 2013),
('EGOR KRID #FRESHBLOOD', 2019),
('Было, но прошло', 2008),
('Basta!', 2018),
('История любви', 2013)
ON CONFLICT DO NOTHING;

-- Добавляем связь между альбомами и исполнителями
INSERT INTO artist_albums (artist_id, album_id)
SELECT ma.artist_id, mal.album_id
FROM music_artist AS ma
CROSS JOIN music_album AS mal
WHERE 
    (ma.name = 'Баста' AND mal.name IN ('Баста 4', 'Звезда и Смерть Хоакина Мурьеты', 'Город дорог', 'Basta!')) OR
    (ma.name = 'Егор Крид' AND mal.name IN ('Что они знают?', '50 оттенков Крида', 'EGOR KRID #FRESHBLOOD')) OR
    (ma.name = 'Валерий Меладзе' AND mal.name IN ('Полет бумеранга', 'Амелия', 'Было, но прошло', 'История любви')) OR
    (ma.name = 'Полина Гагарина' AND mal.name IN ('9', '7'))
ON CONFLICT DO NOTHING;

-- Наполняем таблицу музыкальными треками
INSERT INTO musical_tracks (name, duration, album_id)
VALUES 
('Я буду рядом', 240, 1),
('Самая самая', 210, 2),
('Самба белого мотылька', 280, 3),
('Кукушка', 260, 4),
('Любовь', 230, 5),
('Покинула чат', 220, 6),
('Сэра', 290, 7),
('Somewhere Over the Rainbow', 270, 8),
('Город дорог', 250, 9),
('Happy Birthday', 215, 10),
('Только ты одна', 285, 11),
('Любовь священная', 265, 4),
('Обнимашки-поцелуи', 245, 12),
('Где эта ночь?', 225, 2),
('Ах, какая женщина', 295, 13),
('Колыбельная', 275, 4)
ON CONFLICT DO NOTHING;

-- Наполняем таблицу музыкальными сборниками
INSERT INTO music_collection (name, year)
VALUES 
('Лучшая русская музыка 2010—2020', 2020),
('Музыкальная революция России', 2018),
('Голос России. Поп-музыка XXI века', 2019),
('Поп-чарты российского радио', 2021)
ON CONFLICT DO NOTHING;

-- Добавляем связь между сборниками и треками
INSERT INTO collection_and_tracks (collection_id, track_id)
SELECT mc.collection_id, mt.track_id
FROM music_collection AS mc
CROSS JOIN musical_tracks AS mt
WHERE 
    (mc.name = 'Лучшая русская музыка 2010—2020' AND mt.name IN ('Я буду рядом', 'Самая самая', 'Самба белого мотылька', 'Кукушка')) OR
    (mc.name = 'Музыкальная революция России' AND mt.name IN ('Любовь', 'Покинула чат', 'Сэра', 'Somewhere Over the Rainbow')) OR
    (mc.name = 'Голос России. Поп-музыка XXI века' AND mt.name IN ('Город дорог', 'Happy Birthday', 'Только ты одна', 'Любовь священная')) OR
    (mc.name = 'Поп-чарты российского радио' AND mt.name IN ('Обнимашки-поцелуи', 'Где эта ночь?', 'Ах, какая женщина', 'Колыбельная'))
ON CONFLICT DO NOTHING;

-- Справочно: для очистки
TRUNCATE TABLE music_artist RESTART IDENTITY CASCADE;

TRUNCATE TABLE musical_genres RESTART IDENTITY CASCADE;

TRUNCATE TABLE artist_albums RESTART IDENTITY CASCADE;

TRUNCATE TABLE music_album RESTART IDENTITY CASCADE;

TRUNCATE TABLE music_collection RESTART IDENTITY CASCADE;

TRUNCATE TABLE musical_tracks RESTART IDENTITY CASCADE;

TRUNCATE TABLE collection_and_tracks RESTART IDENTITY CASCADE;