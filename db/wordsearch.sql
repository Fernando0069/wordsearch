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
    rules TEXT,
    time_limit_seconds INTEGER DEFAULT 60  -- Nuevo campo
);

CREATE TABLE games (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    category_id UUID REFERENCES categories(id),
    mode_id UUID REFERENCES game_modes(id),
    game_language TEXT NOT NULL,     -- Idioma de la interfaz
    words_language TEXT NOT NULL,    -- Idioma de las palabras
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

-- Se mantiene la tabla para futuras pruebas
CREATE TABLE daily_challenges (
    id UUID PRIMARY KEY,
    date DATE UNIQUE NOT NULL,
    category_id UUID REFERENCES categories(id),
    word_ids UUID[]  -- Lista de palabras para ese día
);

-- Índices
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

-- Extensión necesaria para UUID
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Función para actualizar el nivel del usuario según la experiencia
CREATE OR REPLACE FUNCTION update_user_level()
RETURNS TRIGGER AS $$
BEGIN
    NEW.level := FLOOR(NEW.xp / 100) + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_level
BEFORE INSERT OR UPDATE OF xp ON users
FOR EACH ROW
EXECUTE FUNCTION update_user_level();

-- Logro por la primera partida
CREATE OR REPLACE FUNCTION grant_first_game_achievement()
RETURNS TRIGGER AS $$
DECLARE
    achievement_id UUID;
    already_has BOOLEAN;
BEGIN
    SELECT id INTO achievement_id FROM achievements WHERE code = 'FIRST_GAME';

    SELECT EXISTS (
        SELECT 1 FROM user_achievements
        WHERE user_id = NEW.user_id AND achievement_id = achievement_id
    ) INTO already_has;

    IF NOT already_has THEN
        INSERT INTO user_achievements (id, user_id, achievement_id, achieved_at)
        VALUES (gen_random_uuid(), NEW.user_id, achievement_id, CURRENT_TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_grant_first_game
AFTER INSERT ON games
FOR EACH ROW
EXECUTE FUNCTION grant_first_game_achievement();

-- Leaderboard
CREATE OR REPLACE FUNCTION update_leaderboard()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM leaderboard
        WHERE user_id = NEW.user_id AND category_id = NEW.category_id
    ) THEN
        UPDATE leaderboard
        SET best_score = GREATEST(best_score, NEW.score),
            fastest_time = LEAST(fastest_time, NEW.time_seconds)
        WHERE user_id = NEW.user_id AND category_id = NEW.category_id;
    ELSE
        INSERT INTO leaderboard (id, user_id, category_id, best_score, fastest_time)
        VALUES (gen_random_uuid(), NEW.user_id, NEW.category_id, NEW.score, NEW.time_seconds);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_leaderboard
AFTER INSERT ON games
FOR EACH ROW
EXECUTE FUNCTION update_leaderboard();

-- Notificaciones por subir de nivel
CREATE TABLE notifications (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE
);

CREATE OR REPLACE FUNCTION notify_level_up()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.level > OLD.level THEN
        INSERT INTO notifications (id, user_id, message)
        VALUES (
            gen_random_uuid(),
            NEW.id,
            '¡Has subido al nivel ' || NEW.level || '!'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_notify_level_up
AFTER UPDATE OF xp ON users
FOR EACH ROW
WHEN (OLD.level IS DISTINCT FROM NEW.level)
EXECUTE FUNCTION notify_level_up();
