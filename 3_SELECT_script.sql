-- Выводим название и продолжительность самого длительного трека.
SELECT name, duration FROM musical_tracks
WHERE duration = (SELECT MAX(duration) FROM musical_tracks)

-- Выводим название треков, продолжительность которых не менее 3,5 минут.
SELECT name, duration FROM musical_tracks
WHERE duration <= (3.5 * 60)

-- Выводим названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name FROM music_collection
WHERE year BETWEEN 2018 AND 2020

-- Выводим исполнителя, чьё имя состоит из одного слова.
SELECT name FROM music_artist
WHERE name NOT LIKE '% %'

-- Выводим название треков, которые содержат слово «мой» или «my».
SELECT name FROM musical_tracks
WHERE name LIKE '%мой%' OR name LIKE '%my%'


-- Выводим количество исполнителей в каждом жанре. (специально LEFT JOIN, чтобы и нулевые значения вывелись)
SELECT mg.name AS genre_name, COUNT(DISTINCT ma.artist_id) AS artist_count
FROM musical_genres AS mg
LEFT JOIN artist_genres AS ag ON mg.musical_genre_id = ag.musical_genre_id
LEFT JOIN music_artist AS ma ON ag.artist_id = ma.artist_id
GROUP BY mg.name
ORDER BY artist_count DESC;

-- Выводим количество треков, вошедших в альбомы 2013–2014 годов. (изменил с промежутка 2019-2020, для наглядности)
SELECT ma.name, COUNT(mt.name) AS track_count
FROM musical_tracks AS mt
JOIN music_album AS ma ON mt.album_id = ma.album_id
WHERE ma.year BETWEEN 2013 AND 2014
GROUP BY ma.name;

-- Выводим среднюю продолжительность треков по каждому альбому.
SELECT ma.name, ROUND(AVG(mt.duration), 2) AS track_duration
FROM musical_tracks AS mt
JOIN music_album AS ma ON mt.album_id = ma.album_id
GROUP BY ma.name
ORDER BY track_duration DESC;

-- Выводим всех исполнителей, которые не выпустили альбомы в 2013 году. (изменил с 2020 года, для наглядности)
SELECT mart.name
FROM music_artist AS mart
JOIN artist_albums AS aa ON mart.artist_id = aa.artist_id
JOIN music_album AS malb ON malb.album_id = aa.album_id
WHERE malb.year = '2013'
GROUP BY mart.name;

-- Выводим названия сборников, в которых присутствует конкретный исполнитель (выберите его сами). (У меня во всех сборниках присутствуют все исполнители, но вроде правильно работает)
SELECT mc.name
FROM music_collection AS mc
JOIN collection_and_tracks AS ct ON ct.collection_id = mc.collection_id
JOIN musical_tracks AS mt ON mt.track_id = ct.track_id
JOIN music_album AS ma ON ma.album_id = mt.album_id
JOIN artist_albums AS aa ON aa.album_id = ma.album_id
JOIN music_artist AS mart ON mart.artist_id = aa.artist_id
WHERE mart.name = 'Баста'
GROUP BY mc.name;


-- Выводим названия альбомов, в которых присутствуют исполнители более чем одного жанра. (У меня у каждого исполнителя по 2 жанра...)
SELECT malb.name
FROM music_album AS malb
JOIN artist_albums AS aa ON aa.album_id = malb.album_id
JOIN music_artist AS mart ON mart.artist_id = aa.artist_id
JOIN artist_genres AS ag ON ag.artist_id = mart.artist_id
JOIN musical_genres AS mg ON mg.musical_genre_id = ag.musical_genre_id
GROUP BY malb.name
HAVING COUNT(mg.musical_genre_id) > 1;

-- Выводим наименования треков, которые не входят в сборники (У меня все треки входят в сборники...)
SELECT mt.name 
FROM musical_tracks AS mt
LEFT JOIN collection_and_tracks AS ct ON mt.track_id = ct.track_id
WHERE ct.track_id IS NULL;

-- Выводим исполнителя или исполнителей, написавших самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
WITH track_durations AS (
	SELECT mart.name, mt.duration AS track_duration
	FROM music_artist AS mart
	JOIN artist_albums AS aa ON aa.artist_id = mart.artist_id
	JOIN music_album AS malb ON aa.album_id = malb.album_id
	JOIN musical_tracks AS mt ON mt.album_id = malb.album_id
	GROUP BY mart.name, mt.duration
)
SELECT name
FROM track_durations
WHERE track_duration = (
	SELECT MIN(track_duration)
	FROM track_durations
	);

-- Выводим названия альбомов, содержащих наименьшее количество треков.
WITH album_counts AS (
    SELECT malb.name, COUNT(mt.track_id) AS num_tracks
    FROM music_album AS malb
    JOIN musical_tracks AS mt ON malb.album_id = mt.album_id
    GROUP BY malb.name
)
SELECT name
FROM album_counts
WHERE num_tracks = (
	SELECT MIN(num_tracks) 
	FROM album_counts
);