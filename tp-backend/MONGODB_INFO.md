# 📊 Informations stockées dans MongoDB

## Collection : `logs`

MongoDB stocke **uniquement les logs des requêtes API** dans la collection `logs`. Chaque requête HTTP est automatiquement enregistrée.

### Structure d'un document Log

```javascript
{
  _id: ObjectId("..."),              // ID unique généré par MongoDB
  userId: "1" ou "anonymous",        // ID de l'utilisateur (ou "anonymous" si non connecté)
  action: "POST /api/activities",    // Méthode HTTP + endpoint
  endpoint: "/api/activities",       // Chemin de l'endpoint
  method: "POST",                    // Méthode HTTP (GET, POST, PUT, DELETE)
  statusCode: 201,                   // Code de statut HTTP (200, 400, 401, 404, 500, etc.)
  userAgent: "Mozilla/5.0...",       // User-Agent du navigateur
  ip: "127.0.0.1",                   // Adresse IP du client
  metadata: {                        // Métadonnées supplémentaires
    responseTime: 45,                // Temps de réponse en millisecondes
    query: {                         // Paramètres de requête (si GET)
      page: "1",
      limit: "10"
    },
    body: {                          // Corps de la requête (si POST/PUT)
      type: "running",
      duration: 30,
      calories: 250
    }
  },
  timestamp: ISODate("2025-11-12T14:30:00.000Z")  // Date et heure de la requête
}
```

### Exemples concrets

#### Exemple 1 : Inscription d'un utilisateur
```javascript
{
  userId: "anonymous",
  action: "POST /api/auth/register",
  endpoint: "/api/auth/register",
  method: "POST",
  statusCode: 201,
  userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)...",
  ip: "127.0.0.1",
  metadata: {
    responseTime: 120,
    body: {
      email: "user@example.com",
      password: "hashed_password"
    }
  },
  timestamp: ISODate("2025-11-12T14:30:00.000Z")
}
```

#### Exemple 2 : Création d'une activité
```javascript
{
  userId: "1",
  action: "POST /api/activities",
  endpoint: "/api/activities",
  method: "POST",
  statusCode: 201,
  userAgent: "Mozilla/5.0...",
  ip: "127.0.0.1",
  metadata: {
    responseTime: 85,
    body: {
      type: "running",
      duration: 30,
      calories: 250,
      distance: 5,
      notes: "Course matinale"
    }
  },
  timestamp: ISODate("2025-11-12T15:00:00.000Z")
}
```

#### Exemple 3 : Consultation du profil
```javascript
{
  userId: "1",
  action: "GET /api/users/profile",
  endpoint: "/api/users/profile",
  method: "GET",
  statusCode: 200,
  userAgent: "Mozilla/5.0...",
  ip: "127.0.0.1",
  metadata: {
    responseTime: 25,
    query: {}
  },
  timestamp: ISODate("2025-11-12T15:15:00.000Z")
}
```

#### Exemple 4 : Erreur 401 (non autorisé)
```javascript
{
  userId: "anonymous",
  action: "GET /api/activities",
  endpoint: "/api/activities",
  method: "GET",
  statusCode: 401,
  userAgent: "Mozilla/5.0...",
  ip: "127.0.0.1",
  metadata: {
    responseTime: 15,
    query: {}
  },
  timestamp: ISODate("2025-11-12T15:20:00.000Z")
}
```

## 📈 Utilisation des logs

### À quoi servent ces logs ?

1. **Analyse des performances** : Temps de réponse de chaque endpoint
2. **Sécurité** : Suivi des tentatives d'accès non autorisées
3. **Debugging** : Identification des erreurs et problèmes
4. **Statistiques** : Endpoints les plus utilisés, heures de pointe, etc.
5. **Audit** : Traçabilité de toutes les actions des utilisateurs

### Requêtes utiles

#### Compter les logs par utilisateur
```javascript
db.logs.aggregate([
  { $group: { _id: "$userId", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

#### Trouver les requêtes les plus lentes
```javascript
db.logs.find({ "metadata.responseTime": { $gt: 1000 } })
  .sort({ "metadata.responseTime": -1 })
  .limit(10)
```

#### Statistiques par endpoint
```javascript
db.logs.aggregate([
  { $group: { 
      _id: "$endpoint", 
      count: { $sum: 1 },
      avgResponseTime: { $avg: "$metadata.responseTime" }
    } 
  },
  { $sort: { count: -1 } }
])
```

#### Logs d'erreurs (4xx, 5xx)
```javascript
db.logs.find({ 
  statusCode: { $gte: 400 } 
}).sort({ timestamp: -1 })
```

## 🔍 Visualisation

Pour voir les logs dans MongoDB Compass :

1. Ouvrez MongoDB Compass
2. Connectez-vous à `mongodb://localhost:27017`
3. Sélectionnez la base de données `sportapp`
4. Ouvrez la collection `logs`
5. Vous verrez tous les logs enregistrés

## ⚠️ Note importante

- **PostgreSQL** stocke les données métier (users, activities, goals)
- **MongoDB** stocke uniquement les logs d'audit et de monitoring
- Les logs sont créés automatiquement pour chaque requête API
- En développement, si MongoDB n'est pas disponible, l'application continue de fonctionner (les logs ne sont juste pas enregistrés)

