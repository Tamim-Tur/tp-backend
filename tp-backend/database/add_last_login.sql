-- Ajouter la colonne last_login à la table users
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login TIMESTAMP;

-- Créer un index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_users_last_login ON users(last_login DESC);

