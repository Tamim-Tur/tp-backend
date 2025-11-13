# 🚀 Guide Rapide : Créer un Admin

## Méthode 1 : Script Automatique (Recommandé)

Exécutez simplement :

```powershell
cd "tp-backend\tp-backend"
.\creer-env-et-admin.ps1
```

Le script va :
1. ✅ Vérifier/créer le fichier `.env`
2. ✅ Vous demander le mot de passe PostgreSQL
3. ✅ Vous demander l'email et mot de passe de l'admin
4. ✅ Créer l'admin automatiquement

## Méthode 2 : Script Simple

```powershell
cd "tp-backend\tp-backend"
.\setup-admin.ps1
```

## Méthode 3 : Manuellement

### Étape 1 : Vérifier le fichier .env

Le fichier `.env` doit contenir :
```env
PG_USER=postgres
PG_HOST=localhost
PG_DATABASE=sportapp
PG_PASSWORD=votre_mot_de_passe_postgresql
PG_PORT=5432
```

**⚠️ IMPORTANT :** Remplacez `votre_mot_de_passe_postgresql` par votre vrai mot de passe PostgreSQL.

### Étape 2 : Créer l'admin

```powershell
cd "tp-backend\tp-backend"
node create-admin.js admin@example.com motdepasse123
```

## Si vous avez une erreur d'authentification

### Option A : Utiliser le mot de passe "password"

Si vous voulez utiliser le mot de passe par défaut `password` :

```powershell
# Se connecter à PostgreSQL
psql -U postgres

# Dans psql, changer le mot de passe
ALTER USER postgres WITH PASSWORD 'password';
\q
```

Puis modifiez votre `.env` :
```env
PG_PASSWORD=password
```

### Option B : Trouver votre mot de passe PostgreSQL

Le mot de passe PostgreSQL est celui que vous avez défini lors de l'installation de PostgreSQL.

Si vous l'avez oublié, vous pouvez :
1. Le réinitialiser (voir CONFIGURATION_POSTGRESQL.md)
2. Ou utiliser l'authentification Windows si configurée

## Vérification

Après la création, vous devriez voir :
```
✅ Admin créé avec succès:
   ID: 1
   Email: admin@example.com
   Rôle: admin
```

Ensuite, connectez-vous à l'application avec cet email et mot de passe !

