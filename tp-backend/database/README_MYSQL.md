# 🗄️ Installation de la Base de Données MySQL pour BasicFit2

Ce guide vous explique comment configurer la base de données MySQL pour l'application BasicFit2.

## 📋 Prérequis

- MySQL 8.0 ou supérieur installé
- Accès administrateur à MySQL
- Client MySQL (mysql ou MySQL Workbench)

## 🚀 Installation Rapide

### 1. Créer la base de données

```sql
CREATE DATABASE IF NOT EXISTS basicfit2 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE basicfit2;
```

### 2. Exécuter le schéma

```bash
mysql -u root -p basicfit2 < database/schema_mysql.sql
```

Ou via MySQL Workbench :
1. Ouvrir MySQL Workbench
2. Se connecter au serveur MySQL
3. Ouvrir le fichier `schema_mysql.sql`
4. Exécuter le script

### 3. Vérifier l'installation

```sql
USE basicfit2;
SHOW TABLES;
```

Vous devriez voir :
- `users`
- `activities`
- `goals`
- `challenges`
- `daily_stats`

## 📊 Structure des Tables

### Table `users`
- **id** : Identifiant unique (AUTO_INCREMENT)
- **email** : Email de l'utilisateur (UNIQUE)
- **password** : Mot de passe hashé
- **role** : Rôle ('user' ou 'admin')
- **created_at** : Date de création
- **updated_at** : Date de mise à jour
- **last_login** : Dernière connexion

### Table `activities`
- **id** : Identifiant unique
- **user_id** : Référence à l'utilisateur
- **type** : Type d'activité (running, cycling, swimming, etc.)
- **duration** : Durée en minutes
- **calories** : Calories brûlées
- **distance** : Distance en km
- **notes** : Notes optionnelles
- **date** : Date de l'activité

### Table `goals`
- **id** : Identifiant unique
- **user_id** : Référence à l'utilisateur
- **title** : Titre de l'objectif
- **description** : Description
- **type** : Type (duration, distance, calories, activities_count)
- **target_value** : Valeur cible
- **current_value** : Valeur actuelle
- **start_date** : Date de début
- **end_date** : Date de fin
- **status** : Statut (active, completed, cancelled)

### Table `challenges`
- **id** : Identifiant unique
- **user_id** : Référence à l'utilisateur
- **name** : Nom du défi
- **description** : Description
- **challenge_type** : Type de défi
- **target_value** : Valeur cible
- **current_value** : Valeur actuelle
- **start_date** : Date de début
- **end_date** : Date de fin
- **status** : Statut (active, completed, failed)

### Table `daily_stats`
- **id** : Identifiant unique
- **user_id** : Référence à l'utilisateur
- **date** : Date
- **total_activities** : Nombre total d'activités
- **total_duration** : Durée totale
- **total_calories** : Calories totales
- **total_distance** : Distance totale

## ⚙️ Configuration dans le Backend

Pour utiliser MySQL au lieu de PostgreSQL, modifiez le fichier `.env` :

```env
# Base de données MySQL
DB_TYPE=mysql
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=votre_mot_de_passe
DB_NAME=basicfit2
```

## 🔧 Créer un Utilisateur MySQL Dédié (Recommandé)

```sql
-- Créer un utilisateur pour l'application
CREATE USER 'basicfit2_user'@'localhost' IDENTIFIED BY 'votre_mot_de_passe_securise';

-- Accorder les permissions
GRANT ALL PRIVILEGES ON basicfit2.* TO 'basicfit2_user'@'localhost';
FLUSH PRIVILEGES;
```

Puis utilisez ces identifiants dans votre fichier `.env`.

## 📝 Requêtes Utiles

### Vérifier les utilisateurs
```sql
SELECT id, email, role, created_at FROM users;
```

### Vérifier les activités
```sql
SELECT a.*, u.email 
FROM activities a 
JOIN users u ON a.user_id = u.id 
ORDER BY a.date DESC 
LIMIT 10;
```

### Vérifier les objectifs
```sql
SELECT g.*, u.email 
FROM goals g 
JOIN users u ON g.user_id = u.id 
WHERE g.status = 'active';
```

### Statistiques par utilisateur
```sql
SELECT * FROM user_stats_view;
```

## 🔄 Migration depuis PostgreSQL

Si vous migrez depuis PostgreSQL, vous devrez :
1. Exporter les données depuis PostgreSQL
2. Adapter le format si nécessaire
3. Importer dans MySQL

## ⚠️ Notes Importantes

- **Charset** : Utilisation de `utf8mb4` pour supporter tous les caractères Unicode (émojis inclus)
- **Engine** : Utilisation de `InnoDB` pour les transactions et les clés étrangères
- **Auto-increment** : MySQL utilise `AUTO_INCREMENT` au lieu de `SERIAL`
- **Timestamps** : `ON UPDATE CURRENT_TIMESTAMP` est géré automatiquement par MySQL
- **CHECK Constraints** : Supportés depuis MySQL 8.0.16+

## 🐛 Dépannage

### Erreur : "Unknown database 'basicfit2'"
```sql
CREATE DATABASE basicfit2 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Erreur : "Access denied"
Vérifiez les permissions de l'utilisateur MySQL :
```sql
SHOW GRANTS FOR 'basicfit2_user'@'localhost';
```

### Erreur : "Table doesn't exist"
Vérifiez que vous avez bien exécuté le script `schema_mysql.sql` :
```sql
USE basicfit2;
SHOW TABLES;
```

## 📚 Ressources

- [Documentation MySQL](https://dev.mysql.com/doc/)
- [MySQL Workbench](https://www.mysql.com/products/workbench/)

