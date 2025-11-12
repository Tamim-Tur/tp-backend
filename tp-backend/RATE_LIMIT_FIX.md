# 🔧 Correction de l'erreur 429 (Too Many Requests)

## ❌ Problème

L'erreur **429 (Too Many Requests)** se produisait car le rate limiting était trop strict :
- 100 requêtes maximum par 15 minutes pour TOUTES les routes
- Les routes d'authentification étaient limitées de la même manière
- En développement, c'est trop restrictif

## ✅ Solution appliquée

### 1. Rate limiting plus permissif en développement
- **Production** : 100 requêtes / 15 min (sécurisé)
- **Développement** : 1000 requêtes / 15 min (plus permissif)

### 2. Rate limiting spécifique pour l'authentification
- **Production** : 5 tentatives / 15 min (sécurisé contre les attaques)
- **Développement** : 50 tentatives / 15 min (plus permissif)
- **skipSuccessfulRequests** : Les connexions réussies ne comptent pas

### 3. Gestion d'erreur améliorée
- Messages d'erreur plus clairs
- Gestion des erreurs 429 avec message explicite
- Meilleure gestion des réponses non-JSON

## 🚀 Pour appliquer la correction

**Redémarrez le serveur backend :**

```bash
cd tp-backend
npm start
```

Ensuite, réessayez de vous inscrire dans l'interface.

## 📝 Configuration actuelle

### Rate Limiting Général
- **Window** : 15 minutes
- **Max requêtes** : 
  - Production : 100
  - Développement : 1000

### Rate Limiting Authentification
- **Window** : 15 minutes
- **Max tentatives** :
  - Production : 5
  - Développement : 50
- **Skip successful** : Oui (les connexions réussies ne comptent pas)

## ⚠️ Si l'erreur persiste

Si vous êtes toujours bloqué par le rate limiting :

1. **Attendez 15 minutes** pour que le compteur se réinitialise
2. **Ou redémarrez le serveur** pour réinitialiser le compteur
3. **Ou modifiez temporairement** la limite dans `src/app.js`

## 🔒 Sécurité

En production, les limites sont plus strictes pour protéger contre :
- Les attaques par force brute
- Les abus de l'API
- La surcharge du serveur

