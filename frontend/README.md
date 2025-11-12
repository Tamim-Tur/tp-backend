# Frontend - Sport App

Interface React pour tester l'API backend.

## Installation

```bash
npm install
```

## Configuration

L'URL de l'API est configurée dans `src/services/api.js`. Par défaut, elle pointe vers `http://localhost:3000/api`.

Si votre backend tourne sur un autre port, vous pouvez :
- Modifier directement l'URL dans `src/services/api.js`
- Ou créer un fichier `.env` avec `VITE_API_URL=http://localhost:PORT/api`

## Démarrage

```bash
npm run dev
```

L'application sera accessible sur `http://localhost:5173` (ou un autre port si 5173 est occupé).

## Fonctionnalités

- **Authentification** : Inscription et connexion
- **Profil utilisateur** : Consultation et modification du profil
- **Activités** : Création, consultation et suppression d'activités sportives
- **Statistiques** : Affichage des statistiques personnelles
- **Gestion des utilisateurs** (Admin) : Liste et suppression des utilisateurs

## Utilisation

1. Démarrer le backend : `cd ../tp-backend && npm start`
2. Démarrer le frontend : `npm run dev`
3. Ouvrir le navigateur sur l'URL affichée
4. S'inscrire ou se connecter pour commencer à tester l'API
