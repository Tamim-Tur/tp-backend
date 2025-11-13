SELECT id, email, role, created_at 
FROM users 
ORDER BY created_at DESC;


SELECT COUNT(*) as total_utilisateurs FROM users;


SELECT role, COUNT(*) as nombre 
FROM users 
GROUP BY role;


SELECT 
    a.id,
    u.email as utilisateur,
    a.type,
    a.duration as duree_minutes,
    a.calories,
    a.distance as distance_km,
    a.date,
    a.created_at
FROM activities a
JOIN users u ON a.user_id = u.id
ORDER BY a.date DESC;


SELECT 
    type,
    duration,
    calories,
    distance,
    date,
    notes
FROM activities 
WHERE user_id = 1
ORDER BY date DESC;


SELECT 
    u.id,
    u.email,
    COUNT(a.id) as nombre_activites,
    COALESCE(SUM(a.duration), 0) as duree_totale_minutes,
    COALESCE(SUM(a.calories), 0) as calories_totales,
    COALESCE(SUM(a.distance), 0) as distance_totale_km
FROM users u
LEFT JOIN activities a ON u.id = a.user_id
GROUP BY u.id, u.email
ORDER BY nombre_activites DESC;


SELECT 
    type,
    COUNT(*) as nombre,
    AVG(duration) as duree_moyenne_minutes,
    SUM(calories) as calories_totales,
    SUM(distance) as distance_totale_km
FROM activities
GROUP BY type
ORDER BY nombre DESC;


SELECT 
    g.id,
    u.email as utilisateur,
    g.title as titre,
    g.type,
    g.current_value as valeur_actuelle,
    g.target_value as valeur_cible,
    g.status,
    g.start_date as date_debut,
    g.end_date as date_fin,
    ROUND((g.current_value / g.target_value * 100)::numeric, 2) as pourcentage
FROM goals g
JOIN users u ON g.user_id = u.id
ORDER BY g.created_at DESC;


SELECT 
    status,
    COUNT(*) as nombre
FROM goals
GROUP BY status;


SELECT 
    u.email,
    g.title,
    g.type,
    g.current_value,
    g.target_value,
    ROUND((g.current_value / g.target_value * 100)::numeric, 2) as pourcentage_complete,
    g.end_date
FROM goals g
JOIN users u ON g.user_id = u.id
WHERE g.status = 'active'
ORDER BY pourcentage_complete DESC;


SELECT 
    c.id,
    u.email as utilisateur,
    c.name as nom,
    c.challenge_type as type_defi,
    c.current_value as valeur_actuelle,
    c.target_value as valeur_cible,
    c.status,
    c.start_date as date_debut,
    c.end_date as date_fin
FROM challenges c
JOIN users u ON c.user_id = u.id
ORDER BY c.created_at DESC;


SELECT 
    u.email,
    a.type,
    a.duration,
    a.calories,
    a.distance,
    a.date
FROM activities a
JOIN users u ON a.user_id = u.id
WHERE a.date >= NOW() - INTERVAL '7 days'
ORDER BY a.date DESC;


SELECT 
    DATE_TRUNC('month', date) as mois,
    COUNT(*) as nombre_activites,
    SUM(duration) as duree_totale,
    SUM(calories) as calories_totales
FROM activities
GROUP BY DATE_TRUNC('month', date)
ORDER BY mois DESC;


SELECT 
    u.email,
    COUNT(a.id) as nombre_activites,
    SUM(a.calories) as calories_totales
FROM users u
JOIN activities a ON u.id = a.user_id
GROUP BY u.id, u.email
ORDER BY calories_totales DESC
LIMIT 10;


SELECT 
    u.email,
    a.type,
    a.duration,
    a.calories,
    a.distance
FROM activities a
JOIN users u ON a.user_id = u.id
WHERE DATE(a.date) = CURRENT_DATE
ORDER BY a.date DESC;


SELECT 
    (SELECT COUNT(*) FROM users) as total_utilisateurs,
    (SELECT COUNT(*) FROM activities) as total_activites,
    (SELECT COUNT(*) FROM goals) as total_objectifs,
    (SELECT COUNT(*) FROM challenges) as total_defis,
    (SELECT SUM(calories) FROM activities) as calories_totales_brulées,
    (SELECT SUM(duration) FROM activities) as duree_totale_minutes,
    (SELECT SUM(distance) FROM activities) as distance_totale_km;


SELECT 
    u.id,
    u.email,
    u.created_at
FROM users u
LEFT JOIN activities a ON u.id = a.user_id
WHERE a.id IS NULL;


SELECT 
    TO_CHAR(date, 'Day') as jour_semaine,
    COUNT(*) as nombre_activites,
    AVG(duration) as duree_moyenne
FROM activities
GROUP BY TO_CHAR(date, 'Day'), EXTRACT(DOW FROM date)
ORDER BY EXTRACT(DOW FROM date);


SELECT 
    a.*,
    u.email as utilisateur_email
FROM activities a
JOIN users u ON a.user_id = u.id
WHERE a.id = 1;


SELECT * FROM user_stats_view
ORDER BY total_calories DESC;

