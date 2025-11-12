# Guide de Configuration PostgreSQL pour Windows

## Problème actuel
L'erreur `authentification par mot de passe échouée pour l'utilisateur postgres` indique que :
- Soit PostgreSQL n'est pas installé
- Soit le mot de passe dans le fichier `.env` ne correspond pas au mot de passe PostgreSQL

## Solution 1 : Installer PostgreSQL (si non installé)

### Étape 1 : Télécharger PostgreSQL
1. Allez sur : https://www.postgresql.org/download/windows/
2. Téléchargez l'installateur "Download the installer"
3. Choisissez la version recommandée (généralement la dernière)

### Étape 2 : Installer PostgreSQL
1. Exécutez l'installateur
2. **IMPORTANT** : Lors de l'installation, notez le **mot de passe** que vous définissez pour l'utilisateur `postgres`
3. Laissez le port par défaut : `5432`
4. Laissez le répertoire de données par défaut

### Étape 3 : Vérifier l'installation
Ouvrez PowerShell et exécutez :
```powershell
psql --version
```

## Solution 2 : Configurer le mot de passe dans .env

### Si PostgreSQL est déjà installé :

1. **Trouvez votre mot de passe PostgreSQL** :
   - Si vous vous souvenez du mot de passe défini lors de l'installation, utilisez-le
   - Sinon, vous devrez le réinitialiser (voir ci-dessous)

2. **Modifiez le fichier `.env`** :
   - Ouvrez le fichier `tp-backend/tp-backend/.env`
   - Modifiez la ligne `PG_PASSWORD=votre_mot_de_passe_ici`
   - Remplacez `votre_mot_de_passe_ici` par votre mot de passe PostgreSQL réel

### Réinitialiser le mot de passe PostgreSQL (si oublié)

1. Arrêtez le service PostgreSQL :
```powershell
Stop-Service postgresql-x64-XX  # Remplacez XX par votre version
```

2. Modifiez le fichier `pg_hba.conf` :
   - Localisez le fichier (généralement dans `C:\Program Files\PostgreSQL\XX\data\pg_hba.conf`)
   - Ouvrez-le en tant qu'administrateur
   - Trouvez la ligne : `host all all 127.0.0.1/32 md5`
   - Remplacez `md5` par `trust`
   - Sauvegardez

3. Redémarrez PostgreSQL :
```powershell
Start-Service postgresql-x64-XX
```

4. Connectez-vous sans mot de passe :
```powershell
psql -U postgres
```

5. Changez le mot de passe :
```sql
ALTER USER postgres WITH PASSWORD 'nouveau_mot_de_passe';
\q
```

6. Remettez `md5` dans `pg_hba.conf` et redémarrez PostgreSQL

## Solution 3 : Créer la base de données

Une fois PostgreSQL configuré, créez la base de données :

```powershell
# Se connecter à PostgreSQL
psql -U postgres

# Dans psql, exécutez :
CREATE DATABASE sportapp;
\q
```

Puis exécutez le schéma SQL :
```powershell
cd "C:\Users\tamim\Desktop\etudes 2025-2026\Efrei\cours\semainde de 10-14 novembre\tpp\tp-backend\tp-backend"
psql -U postgres -d sportapp -f database/schema.sql
```

## Vérification finale

1. Vérifiez que le fichier `.env` contient le bon mot de passe
2. Vérifiez que PostgreSQL est démarré :
```powershell
Get-Service -Name "*postgresql*"
```

3. Testez la connexion :
```powershell
psql -U postgres -d sportapp -c "SELECT version();"
```

4. Redémarrez votre serveur Node.js :
```powershell
cd "C:\Users\tamim\Desktop\etudes 2025-2026\Efrei\cours\semainde de 10-14 novembre\tpp\tp-backend\tp-backend"
node server.js
```

Vous devriez voir :
```
✅ Connecté à PostgreSQL
✅ Connecté à MongoDB
```

## Astuce rapide : Utiliser un mot de passe simple pour le développement

Si vous voulez utiliser le mot de passe `password` (comme dans le `.env` par défaut) :

```powershell
psql -U postgres
```

Puis dans psql :
```sql
ALTER USER postgres WITH PASSWORD 'password';
\q
```

Ensuite, votre fichier `.env` fonctionnera directement sans modification.

