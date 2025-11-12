# 🚀 Guide de Démarrage Rapide - Sport App

## ✅ État Actuel

Tout est **configuré et prêt** ! Voici ce qui est en place :

### Backend
- ✅ **PostgreSQL** : Connecté et opérationnel
- ✅ **MongoDB** : Connecté et opérationnel
- ✅ **Base de données** : `sportapp` initialisée avec toutes les tables
- ✅ **Serveur API** : Démarré sur `http://localhost:3000`
- ✅ **Documentation Swagger** : Disponible sur `http://localhost:3000/api-docs`

### Frontend
- ✅ **React App** : Démarré sur `http://localhost:5173`
- ✅ **Composant Goals** : Créé et intégré
- ✅ **Navigation** : Bouton "🎯 Objectifs" ajouté
- ✅ **Styles** : CSS complet pour les objectifs

## 📋 URLs d'Accès

- **Frontend** : http://localhost:5173
- **Backend API** : http://localhost:3000/api
- **Documentation API** : http://localhost:3000/api-docs

## 🎯 Fonctionnalités Disponibles

### Authentification
- Inscription de nouveaux utilisateurs
- Connexion avec email/mot de passe
- Gestion des tokens JWT

### Activités Sportives
- Créer des activités (course, vélo, natation, marche, gym)
- Voir toutes ses activités
- Supprimer des activités
- Statistiques détaillées

### Objectifs (Goals) ✨ NOUVEAU
- **Créer un objectif** : Définir un objectif avec titre, type, valeur cible, dates
- **Types d'objectifs** :
  - Durée (minutes)
  - Distance (km)
  - Calories
  - Nombre d'activités
- **Suivre la progression** : Barre de progression visuelle avec pourcentage
- **Mettre à jour automatiquement** : Calcul basé sur les activités
- **Filtrer par statut** : Actif, Terminé, Annulé
- **Supprimer** : Gestion complète des objectifs

### Profil Utilisateur
- Voir son profil
- Modifier email et mot de passe

### Administration (Admin)
- Liste des utilisateurs
- Suppression d'utilisateurs

## 🎮 Comment Utiliser

### 1. Accéder à l'Application
Ouvrez votre navigateur et allez sur : **http://localhost:5173**

### 2. S'Inscrire ou Se Connecter
- Si vous n'avez pas de compte, cliquez sur "S'inscrire"
- Sinon, connectez-vous avec votre email et mot de passe

### 3. Naviguer dans l'Application
Utilisez le menu en haut pour accéder à :
- **📊 Tableau de bord** : Vue d'ensemble avec statistiques
- **🏋️ Activités** : Gérer vos activités sportives
- **🎯 Objectifs** : Créer et suivre vos objectifs
- **👤 Profil** : Gérer votre compte

### 4. Créer un Objectif
1. Cliquez sur **"🎯 Objectifs"** dans le menu
2. Cliquez sur **"+ Nouvel Objectif"**
3. Remplissez le formulaire :
   - **Titre** : Ex: "Courir 100 km ce mois"
   - **Description** : (optionnel)
   - **Type** : Choisissez parmi les 4 types
   - **Valeur cible** : La valeur à atteindre
   - **Date de début** : Quand commence l'objectif
   - **Date de fin** : Quand se termine l'objectif
4. Cliquez sur **"Créer l'objectif"**

### 5. Suivre la Progression
- La barre de progression se met à jour automatiquement
- Cliquez sur **"🔄 Mettre à jour la progression"** pour recalculer basé sur vos activités
- Les objectifs terminés passent automatiquement en statut "Terminé"

## 🔧 Commandes Utiles

### Redémarrer le Backend
```powershell
cd "C:\Users\tamim\Desktop\etudes 2025-2026\Efrei\cours\semainde de 10-14 novembre\tpp\tp-backend\tp-backend"
node server.js
```

### Redémarrer le Frontend
```powershell
cd "C:\Users\tamim\Desktop\etudes 2025-2026\Efrei\cours\semainde de 10-14 novembre\tpp\tp-backend\frontend"
npm run dev
```

### Vérifier les Services
- **PostgreSQL** : Service `postgresql-x64-18` doit être en cours d'exécution
- **MongoDB** : Doit être accessible sur `localhost:27017`

## 📝 Notes Importantes

1. **CORS** : Le backend accepte les requêtes depuis le frontend (ports 5173, 5174)
2. **Authentification** : Toutes les routes (sauf auth) nécessitent un token JWT
3. **Base de données** : Les données sont persistantes dans PostgreSQL et MongoDB
4. **Documentation** : Consultez Swagger pour tous les endpoints disponibles

## 🐛 Dépannage

### Le frontend ne se charge pas
- Vérifiez que le port 5173 n'est pas utilisé par un autre processus
- Redémarrez avec `npm run dev`

### Le backend ne répond pas
- Vérifiez que PostgreSQL est démarré
- Vérifiez le fichier `.env` avec les bonnes informations
- Consultez les logs dans la console

### Erreur de connexion à la base de données
- Vérifiez que PostgreSQL est démarré : `Get-Service postgresql-x64-18`
- Vérifiez le mot de passe dans `.env` correspond à celui de PostgreSQL

## ✨ Fonctionnalités Avancées

### Mise à jour Automatique de Progression
Les objectifs peuvent être mis à jour automatiquement en fonction des activités :
- **Durée** : Somme de toutes les durées d'activités
- **Distance** : Somme de toutes les distances
- **Calories** : Somme de toutes les calories
- **Nombre d'activités** : Compte le nombre d'activités

### Filtrage Intelligent
Filtrez vos objectifs par statut pour voir :
- Les objectifs **actifs** en cours
- Les objectifs **terminés** avec succès
- Les objectifs **annulés**

---

**🎉 Tout est prêt ! Profitez de votre application Sport App !**

