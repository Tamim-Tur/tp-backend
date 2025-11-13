# 🔧 Résolution de l'erreur d'authentification PostgreSQL

## Problème
```
❌ Erreur: authentification par mot de passe échouée pour l'utilisateur « postgres »
```

## Solutions

### 1. Vérifier que le fichier .env existe

Le fichier `.env` doit être dans le dossier `tp-backend/tp-backend/`

```bash
cd tp-backend/tp-backend
dir .env
# ou sur Linux/Mac: ls -la .env
```

### 2. Créer le fichier .env si nécessaire

Si le fichier n'existe pas, créez-le avec ce contenu :

```env
# PostgreSQL
PG_USER=postgres
PG_HOST=localhost
PG_DATABASE=sportapp
PG_PASSWORD=votre_mot_de_passe_postgresql
PG_PORT=5432

# MongoDB
MONGO_URI=mongodb://localhost:27017/sportapp

# JWT
JWT_SECRET=votre_secret_jwt_tres_securise
JWT_REFRESH_SECRET=votre_refresh_secret_jwt_tres_securise

# Server
PORT=3000
NODE_ENV=development

# Frontend
FRONTEND_URL=http://localhost:5173
```

**⚠️ IMPORTANT :** Remplacez `votre_mot_de_passe_postgresql` par le vrai mot de passe de votre utilisateur PostgreSQL.

### 3. Trouver le mot de passe PostgreSQL

Si vous ne connaissez pas le mot de passe PostgreSQL :

**Option A : Réinitialiser le mot de passe PostgreSQL**
```bash
# Windows (si PostgreSQL est installé)
# Modifiez le fichier pg_hba.conf pour permettre l'authentification locale
# Puis redémarrez PostgreSQL
```

**Option B : Utiliser l'authentification Windows (si configuré)**
```bash
# Essayez de vous connecter sans mot de passe
psql -U postgres
```

**Option C : Vérifier dans les fichiers de configuration**
- Cherchez dans les fichiers de configuration PostgreSQL
- Vérifiez si vous avez noté le mot de passe quelque part

### 4. Tester la connexion manuellement

Testez d'abord la connexion avec psql :

```bash
psql -U postgres -d sportapp
```

Si ça fonctionne, le problème vient du script. Si ça ne fonctionne pas, le problème vient de PostgreSQL.

### 5. Alternative : Créer l'admin directement via SQL

Si le script ne fonctionne pas, vous pouvez créer l'admin directement :

```bash
# Se connecter à PostgreSQL
psql -U postgres -d sportapp

# Puis exécuter (remplacez l'email et le mot de passe)
-- Note: Vous devez d'abord hasher le mot de passe avec bcrypt
-- Utilisez plutôt cette méthode si vous avez déjà un utilisateur :
UPDATE users SET role = 'admin' WHERE email = 'votre-email@example.com';
```

### 6. Vérifier que la base de données existe

```bash
psql -U postgres -l
```

Si `sportapp` n'existe pas, créez-la :
```sql
CREATE DATABASE sportapp;
```

### 7. Vérifier que les tables existent

```bash
psql -U postgres -d sportapp -c "\dt"
```

Si la table `users` n'existe pas, exécutez le script SQL :
```bash
psql -U postgres -d sportapp -f database/schema.sql
```

## Solution rapide

1. Créez/modifiez le fichier `.env` avec le bon mot de passe PostgreSQL
2. Relancez le script :
   ```bash
   node create-admin.js admin@example.com motdepasse123
   ```

## Si rien ne fonctionne

Utilisez la méthode SQL directe pour mettre à jour un utilisateur existant :

```sql
-- Se connecter à PostgreSQL
psql -U postgres -d sportapp

-- Mettre à jour un utilisateur existant en admin
UPDATE users SET role = 'admin' WHERE email = 'votre-email@example.com';
```

