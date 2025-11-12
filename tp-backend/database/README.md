# Configuration de la Base de Données

## PostgreSQL

### Installation et Configuration

1. **Installer PostgreSQL** (si ce n'est pas déjà fait) :
   ```bash
   # macOS
   brew install postgresql
   brew services start postgresql
   
   # Linux
   sudo apt-get install postgresql postgresql-contrib
   sudo systemctl start postgresql
   ```

2. **Créer la base de données** :
   ```bash
   psql -U postgres
   CREATE DATABASE sportapp;
   \q
   ```

3. **Exécuter le script SQL** :
   ```bash
   psql -U postgres -d sportapp -f database/schema.sql
   ```

4. **Créer un utilisateur** (optionnel mais recommandé) :
   ```sql
   CREATE USER sportapp_user WITH PASSWORD 'votre_mot_de_passe';
   GRANT ALL PRIVILEGES ON DATABASE sportapp TO sportapp_user;
   GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sportapp_user;
   GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sportapp_user;
   ```

### Variables d'environnement

Créez un fichier `.env` dans `tp-backend/` :

```env
# PostgreSQL
PG_USER=postgres
PG_HOST=localhost
PG_DATABASE=sportapp
PG_PASSWORD=votre_mot_de_passe
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

## MongoDB

### Installation et Configuration

1. **Installer MongoDB** :
   ```bash
   # macOS
   brew tap mongodb/brew
   brew install mongodb-community
   brew services start mongodb-community
   
   # Linux
   sudo apt-get install mongodb
   sudo systemctl start mongodb
   ```

2. **MongoDB se connectera automatiquement** via le code dans `config/database.js`

### Utilisation

MongoDB est utilisé pour :
- Les logs d'activité (Log model)
- Les données non relationnelles
- Les métadonnées et statistiques en temps réel

## Vérification

Pour vérifier que tout fonctionne :

```bash
# Démarrer le backend
cd tp-backend
npm start

# Vous devriez voir :
# ✅ Connecté à PostgreSQL
# ✅ Connecté à MongoDB
```

