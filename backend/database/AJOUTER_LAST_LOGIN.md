# 📝 Ajouter la colonne last_login à la base de données

## Pour les bases de données existantes

Si votre base de données existe déjà, exécutez ce script SQL pour ajouter la colonne `last_login` :

```bash
# Méthode 1 : Via psql
psql -U postgres -d sportapp -f database/add_last_login.sql

# Méthode 2 : Directement dans psql
psql -U postgres -d sportapp
```

Puis dans psql :
```sql
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login TIMESTAMP;
CREATE INDEX IF NOT EXISTS idx_users_last_login ON users(last_login DESC);
\q
```

## Pour les nouvelles installations

Le schéma SQL principal (`schema.sql`) a été mis à jour et inclut déjà la colonne `last_login`. Aucune action supplémentaire n'est nécessaire.

## Vérification

Pour vérifier que la colonne existe :

```sql
psql -U postgres -d sportapp -c "\d users"
```

Vous devriez voir la colonne `last_login` dans la liste.

