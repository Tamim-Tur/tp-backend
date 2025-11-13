-- ============================================
-- SCHÉMA MYSQL POUR BASICFIT2
-- ============================================

-- Créer la base de données (à exécuter séparément)
-- CREATE DATABASE IF NOT EXISTS basicfit2 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE basicfit2;

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    CONSTRAINT chk_role CHECK (role IN ('user', 'admin'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_last_login ON users(last_login DESC);

-- Table des activités
CREATE TABLE IF NOT EXISTS activities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    duration INT NOT NULL,
    calories INT DEFAULT 0,
    distance DECIMAL(10, 2) DEFAULT 0,
    notes TEXT,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_activity_type CHECK (type IN ('running', 'cycling', 'swimming', 'walking', 'gym', 'yoga', 'hiking', 'tennis', 'basketball', 'football')),
    CONSTRAINT chk_duration CHECK (duration > 0),
    CONSTRAINT chk_calories CHECK (calories >= 0),
    CONSTRAINT chk_distance CHECK (distance >= 0),
    CONSTRAINT fk_activities_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_activities_user_id ON activities(user_id);
CREATE INDEX idx_activities_type ON activities(type);
CREATE INDEX idx_activities_date ON activities(date DESC);
CREATE INDEX idx_activities_user_date ON activities(user_id, date DESC);

-- Table des objectifs
CREATE TABLE IF NOT EXISTS goals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    target_value DECIMAL(10, 2) NOT NULL,
    current_value DECIMAL(10, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_goal_type CHECK (type IN ('duration', 'distance', 'calories', 'activities_count')),
    CONSTRAINT chk_target_value CHECK (target_value > 0),
    CONSTRAINT chk_current_value CHECK (current_value >= 0),
    CONSTRAINT chk_goal_status CHECK (status IN ('active', 'completed', 'cancelled')),
    CONSTRAINT chk_goal_dates CHECK (end_date >= start_date),
    CONSTRAINT fk_goals_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_goals_user_id ON goals(user_id);
CREATE INDEX idx_goals_status ON goals(status);
CREATE INDEX idx_goals_dates ON goals(start_date, end_date);

-- Table des défis
CREATE TABLE IF NOT EXISTS challenges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    challenge_type VARCHAR(50) NOT NULL,
    target_value DECIMAL(10, 2) NOT NULL,
    current_value DECIMAL(10, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_challenge_status CHECK (status IN ('active', 'completed', 'failed')),
    CONSTRAINT fk_challenges_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_challenges_user_id ON challenges(user_id);
CREATE INDEX idx_challenges_status ON challenges(status);

-- Table des statistiques quotidiennes
CREATE TABLE IF NOT EXISTS daily_stats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    date DATE NOT NULL,
    total_activities INT DEFAULT 0,
    total_duration INT DEFAULT 0,
    total_calories INT DEFAULT 0,
    total_distance DECIMAL(10, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_date (user_id, date),
    CONSTRAINT fk_daily_stats_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_daily_stats_user_date ON daily_stats(user_id, date DESC);

-- Vue des statistiques utilisateur
CREATE OR REPLACE VIEW user_stats_view AS
SELECT 
    u.id as user_id,
    u.email,
    COUNT(DISTINCT a.id) as total_activities,
    COALESCE(SUM(a.duration), 0) as total_duration,
    COALESCE(SUM(a.calories), 0) as total_calories,
    COALESCE(SUM(a.distance), 0) as total_distance,
    MAX(a.date) as last_activity_date
FROM users u
LEFT JOIN activities a ON u.id = a.user_id
GROUP BY u.id, u.email;

