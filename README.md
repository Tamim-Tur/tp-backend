# 🏃 Application Sportive - Backend & Frontend

TP SAIED Nabil - Tamim Mohamed -Reda El Hajjaji


## Lancement Backend
cd backend
npm install
node server.js
Le serveur backend sera accessible sur : **http://localhost:3000**

## Lancement Frontend
cd frontend
npm install
npn run dev
Le frontend sera accessible sur : **http://localhost:5173**


Créez un fichier `.env` à la racine du dossier backend avec le contenu suivant :
# PostgreSQL
PG_USER=postgres
PG_HOST=localhost
PG_DATABASE=sportapp
PG_PASSWORD=votre_mot_de_passe_postgres
PG_PORT=5432
# MongoDB
MONGO_URI=mongodb://localhost:27017/sportapp
# JWT
JWT_SECRET=votre_secret_jwt_tres_securise_changez_moi_123456789
JWT_REFRESH_SECRET=votre_refresh_secret_jwt_tres_securise_changez_moi_987654321
# Server
PORT=3000
NODE_ENV=development
# Frontend
FRONTEND_URL=http://localhost:5173


### 3. Créer un compte administrateur

Exécutez le script pour créer un compte admin :
node create-admin.js admin@example.com motdepasse123
Remplacez `admin@example.com` et `motdepasse123` par les valeurs de votre choix.



## 📚 Documentation API
Une fois le backend lancé, accédez à la documentation Swagger interactive :
**http://localhost:3000/api-docs**
Vous y trouverez :
- Toutes les routes disponibles
- Les paramètres requis
- Les exemples de requêtes
- La possibilité de tester les endpoints directement

### Routes principales
- **Authentification** : `/api/auth`
  - `POST /api/auth/register` - Inscription
  - `POST /api/auth/login` - Connexion
  - `POST /api/auth/refresh` - Rafraîchir le token

- **Utilisateurs** : `/api/users`
  - `GET /api/users` - Liste des utilisateurs (admin)
  - `GET /api/users/:id` - Détails d'un utilisateur
  - `PUT /api/users/:id` - Modifier un utilisateur
  - `DELETE /api/users/:id` - Supprimer un utilisateur

- **Activités** : `/api/activities`
  - `POST /api/activities` - Créer une activité
  - `GET /api/activities` - Liste des activités
  - `GET /api/activities/stats` - Statistiques
  - `GET /api/activities/:id` - Détails d'une activité
  - `PUT /api/activities/:id` - Modifier une activité
  - `DELETE /api/activities/:id` - Supprimer une activité

- **Objectifs** : `/api/goals`
  - `POST /api/goals` - Créer un objectif
  - `GET /api/goals` - Liste des objectifs
  - `GET /api/goals/:id` - Détails d'un objectif
  - `PUT /api/goals/:id` - Modifier un objectif
  - `DELETE /api/goals/:id` - Supprimer un objectif
  - `POST /api/goals/:id/progress` - Mettre à jour la progression

les routes  sont disponibles  dans  swagger aussi :
### Vérification
- **API** : http://localhost:3000/api
- **Documentation Swagger** : http://localhost:3000/api-docs

---

## Tests
### Lancer les tests backend
cd backend
npm test

Les tests couvrent :
- Authentification (inscription, connexion, refresh token)
- Gestion des utilisateurs
- Gestion des activités
