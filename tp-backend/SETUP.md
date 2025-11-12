# 🔧 Configuration de la Base de Données

## ❌ Problème Actuel

L'erreur **500 Internal Server Error** est causée par le fait que la base de données PostgreSQL n'existe pas encore.

## ✅ Solution Rapide

### Option 1 : Script Automatique (Recommandé)

```bash
cd tp-backend
./setup-database.sh
```

### Option 2 : Manuellement

#### Étape 1 : Créer la base de données

```bash
# Se connecter à PostgreSQL
psql -U postgres

# Dans psql, créer la base de données
CREATE DATABASE sportapp;

# Quitter psql
\q
```

#### Étape 2 : Exécuter le script SQL

```bash
# Depuis le terminal
psql -U postgres -d sportapp -f database/schema.sql
```

Ou depuis psql :

```bash
psql -U postgres -d sportapp
\i database/schema.sql
\q
```

## 🔍 Vérification

Après avoir créé la base de données, testez la connexion :

```bash
cd tp-backend
node test-db.js
```

Vous devriez voir :
```
✅ Connexion PostgreSQL réussie
✅ Table "users" existe
✅ Table "activities" existe
```

## 🚀 Redémarrer le Serveur

Après avoir configuré la base de données, redémarrez le serveur backend :

```bash
cd tp-backend
npm start
```

## 📝 Notes

- Assurez-vous que PostgreSQL est démarré
- Vérifiez les credentials dans le fichier `.env`
- Si vous avez un mot de passe PostgreSQL, vous devrez peut-être utiliser `PGPASSWORD` :

```bash
export PGPASSWORD=votre_mot_de_passe
psql -U postgres -d sportapp -f database/schema.sql
```

