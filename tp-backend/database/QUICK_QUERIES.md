# 🔍 Requêtes SQL Rapides pour PostgreSQL

## 📋 Comment utiliser ces requêtes

### Option 1 : Via psql (ligne de commande)
```bash
# Se connecter à PostgreSQL
/Applications/Postgres.app/Contents/Versions/18/bin/psql -U postgres -d sportapp

# Puis copier-coller les requêtes ci-dessous
```

### Option 2 : Via MongoDB Compass ou pgAdmin
- Ouvrez votre outil de gestion PostgreSQL
- Connectez-vous à la base `sportapp`
- Exécutez les requêtes dans l'éditeur SQL

---

## 🚀 Requêtes Essentielles

### 1️⃣ Voir tous les utilisateurs
```sql
SELECT id, email, role, created_at 
FROM users 
ORDER BY created_at DESC;
```

### 2️⃣ Voir toutes les activités
```sql
SELECT 
    a.id,
    u.email as utilisateur,
    a.type,
    a.duration as duree_minutes,
    a.calories,
    a.distance as distance_km,
    a.date
FROM activities a
JOIN users u ON a.user_id = u.id
ORDER BY a.date DESC;
```

### 3️⃣ Statistiques par utilisateur
```sql
SELECT 
    u.email,
    COUNT(a.id) as nombre_activites,
    SUM(a.duration) as duree_totale_minutes,
    SUM(a.calories) as calories_totales,
    SUM(a.distance) as distance_totale_km
FROM users u
LEFT JOIN activities a ON u.id = a.user_id
GROUP BY u.id, u.email
ORDER BY nombre_activites DESC;
```

### 4️⃣ Voir tous les objectifs
```sql
SELECT 
    u.email,
    g.title,
    g.type,
    g.current_value,
    g.target_value,
    g.status,
    ROUND((g.current_value / g.target_value * 100)::numeric, 2) as pourcentage
FROM goals g
JOIN users u ON g.user_id = u.id
ORDER BY g.created_at DESC;
```

### 5️⃣ Activités par type
```sql
SELECT 
    type,
    COUNT(*) as nombre,
    AVG(duration) as duree_moyenne,
    SUM(calories) as calories_totales
FROM activities
GROUP BY type
ORDER BY nombre DESC;
```

### 6️⃣ Statistiques globales
```sql
SELECT 
    (SELECT COUNT(*) FROM users) as total_utilisateurs,
    (SELECT COUNT(*) FROM activities) as total_activites,
    (SELECT COUNT(*) FROM goals) as total_objectifs,
    (SELECT SUM(calories) FROM activities) as calories_totales,
    (SELECT SUM(duration) FROM activities) as duree_totale_minutes;
```

### 7️⃣ Activités récentes (7 derniers jours)
```sql
SELECT 
    u.email,
    a.type,
    a.duration,
    a.calories,
    a.date
FROM activities a
JOIN users u ON a.user_id = u.id
WHERE a.date >= NOW() - INTERVAL '7 days'
ORDER BY a.date DESC;
```

### 8️⃣ Top utilisateurs par calories
```sql
SELECT 
    u.email,
    SUM(a.calories) as calories_totales,
    COUNT(a.id) as nombre_activites
FROM users u
JOIN activities a ON u.id = a.user_id
GROUP BY u.id, u.email
ORDER BY calories_totales DESC
LIMIT 10;
```

---

## 🔧 Requêtes Utiles pour le Debug

### Voir la structure d'une table
```sql
\d users
\d activities
\d goals
```

### Compter les enregistrements
```sql
SELECT 'users' as table_name, COUNT(*) FROM users
UNION ALL
SELECT 'activities', COUNT(*) FROM activities
UNION ALL
SELECT 'goals', COUNT(*) FROM goals
UNION ALL
SELECT 'challenges', COUNT(*) FROM challenges;
```

### Voir les dernières activités créées
```sql
SELECT * FROM activities 
ORDER BY created_at DESC 
LIMIT 10;
```

### Voir les utilisateurs avec leurs activités
```sql
SELECT 
    u.id,
    u.email,
    COUNT(a.id) as nb_activites,
    MAX(a.date) as derniere_activite
FROM users u
LEFT JOIN activities a ON u.id = a.user_id
GROUP BY u.id, u.email;
```

---

## 📊 Requêtes Avancées

### Activités par mois
```sql
SELECT 
    TO_CHAR(date, 'YYYY-MM') as mois,
    COUNT(*) as nombre_activites,
    SUM(calories) as calories_totales
FROM activities
GROUP BY TO_CHAR(date, 'YYYY-MM')
ORDER BY mois DESC;
```

### Objectifs avec progression
```sql
SELECT 
    u.email,
    g.title,
    g.current_value,
    g.target_value,
    ROUND((g.current_value / g.target_value * 100)::numeric, 2) as pourcentage,
    CASE 
        WHEN g.current_value >= g.target_value THEN '✅ Complété'
        ELSE '🎯 En cours'
    END as statut
FROM goals g
JOIN users u ON g.user_id = u.id
WHERE g.status = 'active'
ORDER BY pourcentage DESC;
```

---

## 🗑️ Requêtes de Nettoyage (Attention !)

### Supprimer toutes les activités (⚠️ DANGEREUX)
```sql
-- NE PAS EXÉCUTER EN PRODUCTION !
-- DELETE FROM activities;
```

### Supprimer un utilisateur et ses données
```sql
-- Supprime l'utilisateur et toutes ses activités (grâce à CASCADE)
-- DELETE FROM users WHERE id = 1;
```

---

## 💡 Astuces

1. **Utilisez LIMIT** pour limiter les résultats :
   ```sql
   SELECT * FROM activities LIMIT 10;
   ```

2. **Filtrez par date** :
   ```sql
   SELECT * FROM activities 
   WHERE date >= '2025-01-01' 
   AND date < '2025-02-01';
   ```

3. **Triez les résultats** :
   ```sql
   SELECT * FROM activities 
   ORDER BY date DESC, calories DESC;
   ```

4. **Cherchez un utilisateur spécifique** :
   ```sql
   SELECT * FROM users WHERE email LIKE '%@example.com';
   ```

