# 📊 Comment voir les logs dans MongoDB

## ✅ Problème résolu

J'ai ajouté le logger à la route `/auth` qui était manquante. Maintenant **toutes les requêtes** sont enregistrées dans MongoDB.

## 🔍 Voir les logs dans MongoDB Compass

1. **Ouvrez MongoDB Compass**
2. **Connectez-vous** à : `mongodb://localhost:27017`
3. **Sélectionnez** la base de données `sportapp`
4. **Ouvrez** la collection `logs`
5. **Vous verrez** tous les logs enregistrés !

## 📋 Logs actuellement dans MongoDB

J'ai créé 4 logs de test pour que vous puissiez voir quelque chose immédiatement.

## 🚀 Pour générer de nouveaux logs

### Option 1 : Utiliser l'interface web
- Faites des actions dans l'interface (inscription, connexion, créer des activités)
- Chaque action créera automatiquement un log dans MongoDB

### Option 2 : Script de test
```bash
cd tp-backend
node generate-test-logs.js
```

### Option 3 : Requêtes API directes
```bash
# Inscription
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'

# Connexion
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

## 🔄 Vérifier les logs en temps réel

```bash
cd tp-backend
node -e "require('dotenv').config(); const mongoose = require('mongoose'); (async () => { await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/sportapp'); const Log = require('./src/models/Log'); const count = await Log.countDocuments(); console.log('Nombre de logs:', count); await mongoose.connection.close(); })()"
```

## 📝 Structure des logs

Chaque log contient :
- `userId` : ID utilisateur ou "anonymous"
- `action` : Méthode + endpoint (ex: "POST /api/activities")
- `method` : GET, POST, PUT, DELETE
- `statusCode` : 200, 201, 400, 401, etc.
- `userAgent` : Navigateur utilisé
- `ip` : Adresse IP
- `metadata.responseTime` : Temps de réponse en ms
- `metadata.query` : Paramètres de requête
- `metadata.body` : Données envoyées
- `timestamp` : Date et heure

## ⚠️ Important

- Les logs sont créés **automatiquement** pour chaque requête API
- Si vous ne voyez pas de logs, vérifiez que :
  1. Le serveur backend est démarré
  2. MongoDB est démarré
  3. Vous avez fait des requêtes à l'API
  4. Vous êtes connecté à la bonne base de données dans MongoDB Compass

