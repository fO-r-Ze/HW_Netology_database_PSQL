-- Создание таблицы музыкальных жанров
CREATE TABLE IF NOT EXISTS Musical_genres (
    Musical_genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Создание таблицы музыкальных исполнителей
CREATE TABLE IF NOT EXISTS Music_artist (
    Artist_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Создание таблицы связи между исполнителями и жанрами
CREATE TABLE IF NOT EXISTS Artist_genres (
    Artist_id INT NOT NULL,
    Musical_genre_id INT NOT NULL,
    PRIMARY KEY (Artist_id, Musical_genre_id),
    FOREIGN KEY (Artist_id) REFERENCES Music_artist(Artist_id),
    FOREIGN KEY (Musical_genre_id) REFERENCES Musical_genres(Musical_genre_id)
);

-- Создание таблицы музыкальных альбомов
CREATE TABLE IF NOT EXISTS Music_album (
    Album_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    year INT NOT NULL
);

-- Создание таблицы связи между исполнителями и альбомами
CREATE TABLE IF NOT EXISTS Artist_albums (
    Artist_id INT NOT NULL,
    Album_id INT NOT NULL,
    PRIMARY KEY (Artist_id, Album_id),
    FOREIGN KEY (Artist_id) REFERENCES Music_artist(Artist_id),
    FOREIGN KEY (Album_id) REFERENCES Music_album(Album_id)
);

-- Создание таблицы музыкальных треков
CREATE TABLE IF NOT EXISTS Musical_tracks (
    Track_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    Album_id INT,
    FOREIGN KEY (Album_id) REFERENCES Music_album(Album_id)
);

-- Создание таблицы музыкальных коллекций
CREATE TABLE IF NOT EXISTS Music_collection (
    Collection_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    year INT NOT NULL
);

-- Создание таблицы связи между коллекциями и треками
CREATE TABLE IF NOT EXISTS Collection_and_Tracks (
    Collection_id INT NOT NULL,
    Track_id INT NOT NULL,
    PRIMARY KEY (Collection_id, Track_id),
    FOREIGN KEY (Collection_id) REFERENCES Music_collection(Collection_id),
    FOREIGN KEY (Track_id) REFERENCES Musical_tracks(Track_id)
);

CREATE TABLE Departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER REFERENCES Departments(department_id),
    director_id INTEGER REFERENCES Employees(employee_id)
);