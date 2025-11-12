# 🏃 Sport App - Application Sportive Complète

Application complète de suivi sportif avec backend Node.js/Express et frontend React.

## 📋 Structure du Projet

```
Api_VV/
├── tp-backend/          # Backend API (Node.js + Express)
│   ├── database/       # Scripts SQL pour PostgreSQL
│   ├── src/
│   │   ├── config/     # Configuration (DB, Swagger)
│   │   ├── controllers/# Contrôleurs API
│   │   ├── models/     # Modèles de données
│   │   ├── routes/     # Routes API
│   │   ├── services/   # Services métier
│   │   └── middlewares/# Middlewares
│   └── server.js       # Point d'entrée serveur
│
└── frontend/           # Frontend React (Vite)
    └── src/
        ├── components/ # Composants React
        ├── services/   # Service API
        └── App.jsx     # Application principale
```

## 🚀 Installation et Démarrage

### Prérequis

- Node.js (v16 ou supérieur)
- PostgreSQL (v12 ou supérieur)
- MongoDB (v5 ou supérieur)
- npm ou yarn

### 1. Configuration PostgreSQL

**⚠️ IMPORTANT : Vous devez exécuter le script SQL manuellement !**

```bash
# Se connecter à PostgreSQL
psql -U postgres

# Créer la base de données
CREATE DATABASE sportapp;

# Se connecter à la base de données
\c sportapp

# Exécuter le script SQL
\i tp-backend/database/schema.sql

# Ou depuis la ligne de commande :
psql -U postgres -d sportapp -f tp-backend/database/schema.sql
```

### 2. Configuration MongoDB

MongoDB se connectera automatiquement au démarrage. Assurez-vous que MongoDB est démarré :

```bash
# macOS
brew services start mongodb-community

# Linux
sudo systemctl start mongodb
```

### 3. Configuration Backend

```bash
cd tp-backend

# Installer les dépendances
npm install

# Créer le fichier .env
cat > .env << EOF
# PostgreSQL
PG_USER=postgres
PG_HOST=localhost
PG_DATABASE=sportapp
PG_PASSWORD=votre_mot_de_passe
PG_PORT=5432

# MongoDB
MONGO_URI=mongodb://localhost:27017/sportapp

# JWT
JWT_SECRET=votre_secret_jwt_tres_securise_changez_moi
JWT_REFRESH_SECRET=votre_refresh_secret_jwt_tres_securise_changez_moi

# Server
PORT=3000
NODE_ENV=development

# Frontend
FRONTEND_URL=http://localhost:5173
EOF

# Démarrer le serveur
npm start
```

### 4. Configuration Frontend

```bash
cd frontend

# Installer les dépendances
npm install

# Démarrer le serveur de développement
npm run dev
```

## ✨ Fonctionnalités

### Backend API

- ✅ **Authentification** : Inscription, connexion, refresh token
- ✅ **Gestion des utilisateurs** : Profil, modification, gestion admin
- ✅ **Activités sportives** : CRUD complet avec statistiques
- ✅ **Objectifs** : Création et suivi d'objectifs personnels
- ✅ **Statistiques** : Statistiques détaillées par période
- ✅ **Logs** : Journalisation des actions (MongoDB)
- ✅ **Sécurité** : JWT, bcrypt, rate limiting, helmet
- ✅ **Performance** : Pool de connexions, index SQL, requêtes optimisées

### Frontend

- ✅ **Interface moderne** : Design sportif avec gradients et animations
- ✅ **Tableau de bord** : Vue d'ensemble avec statistiques et objectifs
- ✅ **Gestion des activités** : Création, consultation, suppression
- ✅ **Profil utilisateur** : Modification du profil et mot de passe
- ✅ **Gestion admin** : Administration des utilisateurs
- ✅ **Responsive** : Adapté mobile et desktop

## 📊 Base de Données

### PostgreSQL (Données relationnelles)

- `users` : Utilisateurs
- `activities` : Activités sportives
- `goals` : Objectifs utilisateurs
- `challenges` : Défis
- `daily_stats` : Statistiques quotidiennes (cache)

### MongoDB (Données non relationnelles)

- `logs` : Journalisation des actions API

## 🔧 API Endpoints

### Authentification
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `POST /api/auth/refresh` - Rafraîchir le token

### Utilisateurs
- `GET /api/users/profile` - Profil utilisateur
- `PUT /api/users/profile` - Modifier le profil
- `GET /api/users` - Liste utilisateurs (admin)
- `DELETE /api/users/:id` - Supprimer utilisateur (admin)

### Activités
- `POST /api/activities` - Créer une activité
- `GET /api/activities` - Liste des activités
- `GET /api/activities/:id` - Détails d'une activité
- `DELETE /api/activities/:id` - Supprimer une activité
- `GET /api/activities/stats` - Statistiques (query: ?period=week|month|year|all)

### Objectifs
- `POST /api/goals` - Créer un objectif
- `GET /api/goals` - Liste des objectifs
- `GET /api/goals/:id` - Détails d'un objectif
- `PUT /api/goals/:id` - Modifier un objectif
- `DELETE /api/goals/:id` - Supprimer un objectif
- `POST /api/goals/:id/progress` - Mettre à jour la progression

## 📚 Documentation API

Une fois le serveur démarré, accédez à la documentation Swagger :
```
http://localhost:3000/api-docs
```

## 🎨 Design

L'interface utilise un design moderne avec :
- Gradients colorés (violet/bleu)
- Animations fluides
- Cards avec ombres
- Design responsive
- Thème sportif

## 🔒 Sécurité

- Authentification JWT
- Mots de passe hashés (bcrypt)
- Rate limiting
- Helmet pour les headers sécurisés
- Validation des données (Joi)
- CORS configuré

## 📝 Notes Importantes

1. **PostgreSQL** : Vous DEVEZ exécuter le script SQL manuellement avant de démarrer l'application
2. **Variables d'environnement** : Modifiez les secrets JWT dans le fichier `.env`
3. **Ports** : Backend sur 3000, Frontend sur 5173 (par défaut)
4. **MongoDB** : Optionnel en développement, mais requis pour les logs

## 🐛 Dépannage

### Erreur de connexion PostgreSQL
- Vérifiez que PostgreSQL est démarré
- Vérifiez les credentials dans `.env`
- Vérifiez que la base de données `sportapp` existe

### Erreur de connexion MongoDB
- Vérifiez que MongoDB est démarré
- En développement, l'app fonctionne sans MongoDB (logs désactivés)

### CORS errors
- Vérifiez que `FRONTEND_URL` dans `.env` correspond à l'URL du frontend

## 📄 Licence

Ce projet est un projet éducatif.

