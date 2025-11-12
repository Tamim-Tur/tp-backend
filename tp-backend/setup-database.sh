#!/bin/bash

# Script pour créer la base de données et exécuter le schéma SQL
# Utilise Postgres.app sur macOS

echo "🔄 Configuration de la base de données PostgreSQL..."

# Chemin vers psql dans Postgres.app
PSQL_PATH="/Applications/Postgres.app/Contents/Versions/18/bin/psql"

# Vérifier si psql existe
if [ ! -f "$PSQL_PATH" ]; then
    echo "❌ psql non trouvé à $PSQL_PATH"
    echo "💡 Vérifiez que Postgres.app est installé"
    exit 1
fi

# Lire les variables d'environnement
if [ -f .env ]; then
    source .env
fi

PG_USER=${PG_USER:-postgres}
PG_HOST=${PG_HOST:-localhost}
PG_DATABASE=${PG_DATABASE:-sportapp}
PG_PORT=${PG_PORT:-5432}

echo "📝 Configuration:"
echo "   User: $PG_USER"
echo "   Host: $PG_HOST"
echo "   Database: $PG_DATABASE"
echo "   Port: $PG_PORT"
echo ""

# Créer la base de données
echo "🔄 Création de la base de données '$PG_DATABASE'..."
"$PSQL_PATH" -U "$PG_USER" -h "$PG_HOST" -p "$PG_PORT" -c "CREATE DATABASE $PG_DATABASE;" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Base de données créée avec succès"
elif [ $? -eq 2 ]; then
    echo "⚠️  La base de données existe déjà (c'est OK)"
else
    echo "❌ Erreur lors de la création de la base de données"
    echo "💡 Vérifiez que PostgreSQL est démarré dans Postgres.app"
    exit 1
fi

# Exécuter le script SQL
echo ""
echo "🔄 Exécution du script SQL..."
if [ -f "database/schema.sql" ]; then
    "$PSQL_PATH" -U "$PG_USER" -h "$PG_HOST" -p "$PG_PORT" -d "$PG_DATABASE" -f database/schema.sql
    
    if [ $? -eq 0 ]; then
        echo "✅ Script SQL exécuté avec succès"
        echo ""
        echo "✨ Base de données configurée !"
        echo ""
        echo "🚀 Vous pouvez maintenant redémarrer le serveur backend"
    else
        echo "❌ Erreur lors de l'exécution du script SQL"
        exit 1
    fi
else
    echo "❌ Fichier database/schema.sql introuvable"
    exit 1
fi
