-- Crear las tablas principales
CREATE TABLE users (
    id UUID PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    language TEXT NOT NULL,
    level INTEGER DEFAULT 1,
    xp INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id UUID PRIMARY KEY,
    name_es TEXT NOT NULL,
    name_en TEXT NOT NULL,
    difficulty TEXT
);

CREATE TABLE words (
    id UUID PRIMARY KEY,
    category_id UUID REFERENCES categories(id),
    word TEXT NOT NULL,
    language TEXT NOT NULL
);

CREATE TABLE game_modes (
    id UUID PRIMARY KEY,
    name_es TEXT NOT NULL,
    name_en TEXT NOT NULL,
    rules TEXT
);

CREATE TABLE games (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    category_id UUID REFERENCES categories(id),
    mode_id UUID REFERENCES game_modes(id),
    language TEXT NOT NULL,
    score INTEGER,
    time_seconds INTEGER,
    words_found INTEGER,
    total_words INTEGER,
    is_daily BOOLEAN DEFAULT FALSE,
    played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE leaderboard (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    category_id UUID REFERENCES categories(id),
    best_score INTEGER,
    fastest_time INTEGER
);

CREATE TABLE achievements (
    id UUID PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    name_es TEXT NOT NULL,
    name_en TEXT NOT NULL,
    description_es TEXT,
    description_en TEXT
);

CREATE TABLE user_achievements (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    achievement_id UUID REFERENCES achievements(id),
    achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE daily_challenges (
    id UUID PRIMARY KEY,
    date DATE UNIQUE NOT NULL,
    category_id UUID REFERENCES categories(id),
    word_ids UUID[] -- Lista de palabras para ese día
);

-- Crear índices para optimizar consultas
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_words_category_id ON words(category_id);
CREATE INDEX idx_games_user_id ON games(user_id);
CREATE INDEX idx_games_category_id ON games(category_id);
CREATE INDEX idx_games_mode_id ON games(mode_id);
CREATE INDEX idx_leaderboard_user_id ON leaderboard(user_id);
CREATE INDEX idx_leaderboard_category_id ON leaderboard(category_id);
CREATE INDEX idx_user_achievements_user_id ON user_achievements(user_id);
CREATE INDEX idx_user_achievements_achievement_id ON user_achievements(achievement_id);
CREATE INDEX idx_daily_challenges_date ON daily_challenges(date);

-- Crear la extensión pgcrypto si no está presente
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Función para actualizar el nivel del usuario según la experiencia (xp)
CREATE OR REPLACE FUNCTION update_user_level()
RETURNS TRIGGER AS $$
BEGIN
    NEW.level := FLOOR(NEW.xp / 100) + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que se activa antes de actualizar XP en la tabla de usuarios
CREATE TRIGGER trg_update_level
BEFORE INSERT OR UPDATE OF xp ON users
FOR EACH ROW
EXECUTE FUNCTION update_user_level();

-- Función para otorgar el logro de "primera partida" (FIRST_GAME)
CREATE OR REPLACE FUNCTION grant_first_game_achievement()
RETURNS TRIGGER AS $$
DECLARE
    achievement_id UUID;
    already_has BOOLEAN;
BEGIN
    -- Buscar el logro FIRST_GAME
    SELECT id INTO achievement_id FROM achievements WHERE code = 'FIRST_GAME';

    -- Comprobar si el usuario ya tiene el logro
    SELECT EXISTS (
        SELECT 1 FROM user_achievements
        WHERE user_id = NEW.user_id AND achievement_id = achievement_id
    ) INTO already_has;

    -- Si no lo tiene, asignar el logro
    IF NOT already_has THEN
        INSERT INTO user_achievements (id, user_id, achievement_id, achieved_at)
        VALUES (gen_random_uuid(), NEW.user_id, achievement_id, CURRENT_TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para otorgar el logro FIRST_GAME después de una partida
CREATE TRIGGER trg_grant_first_game
AFTER INSERT ON games
FOR EACH ROW
EXECUTE FUNCTION grant_first_game_achievement();

-- Función para actualizar el leaderboard
CREATE OR REPLACE FUNCTION update_leaderboard()
RETURNS TRIGGER AS $$
BEGIN
    -- Si el usuario ya tiene una entrada en el leaderboard
    IF EXISTS (
        SELECT 1 FROM leaderboard
        WHERE user_id = NEW.user_id AND category_id = NEW.category_id
    ) THEN
        -- Actualizar la puntuación y tiempo si es mejor
        UPDATE leaderboard
        SET best_score = GREATEST(best_score, NEW.score),
            fastest_time = LEAST(fastest_time, NEW.time_seconds)
        WHERE user_id = NEW.user_id AND category_id = NEW.category_id;
    ELSE
        -- Si no existe, crear una nueva entrada
        INSERT INTO leaderboard (id, user_id, category_id, best_score, fastest_time)
        VALUES (gen_random_uuid(), NEW.user_id, NEW.category_id, NEW.score, NEW.time_seconds);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar el leaderboard después de una partida
CREATE TRIGGER trg_update_leaderboard
AFTER INSERT ON games
FOR EACH ROW
EXECUTE FUNCTION update_leaderboard();

-- Función para generar notificaciones del sistema (cuando el usuario sube de nivel)
CREATE OR REPLACE FUNCTION notify_level_up()
RETURNS TRIGGER AS $$
BEGIN
    -- Si el usuario ha subido de nivel
    IF NEW.level > OLD.level THEN
        INSERT INTO notifications (id, user_id, message)
        VALUES (
            gen_random_uuid(),
            NEW.id,
            '🎉 ¡Has subido al nivel ' || NEW.level || '!'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para notificar al usuario cuando sube de nivel
CREATE TRIGGER trg_notify_level_up
AFTER UPDATE OF xp ON users
FOR EACH ROW
WHEN (OLD.level IS DISTINCT FROM NEW.level)
EXECUTE FUNCTION notify_level_up();

-- Crear la tabla de notificaciones
CREATE TABLE notifications (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE
);
