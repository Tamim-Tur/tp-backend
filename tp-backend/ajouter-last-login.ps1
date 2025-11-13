# Script pour ajouter la colonne last_login à la base de données
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Ajout de la colonne last_login" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Charger les variables d'environnement
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^([^#][^=]+)=(.*)$") {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }
}

$pgUser = $env:PG_USER
if (-not $pgUser) { $pgUser = "postgres" }

$pgDatabase = $env:PG_DATABASE
if (-not $pgDatabase) { $pgDatabase = "sportapp" }

$pgPassword = $env:PG_PASSWORD
if (-not $pgPassword) { $pgPassword = "password" }

Write-Host "Connexion à PostgreSQL..." -ForegroundColor Yellow
Write-Host "   Base de données: $pgDatabase" -ForegroundColor Cyan
Write-Host "   Utilisateur: $pgUser" -ForegroundColor Cyan
Write-Host ""

# Définir le mot de passe pour psql
$env:PGPASSWORD = $pgPassword

# Vérifier si la colonne existe déjà
Write-Host "Vérification de l'existence de la colonne..." -ForegroundColor Yellow
$checkQuery = "SELECT column_name FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'last_login';"
$checkResult = psql -U $pgUser -d $pgDatabase -t -c $checkQuery 2>&1

if ($checkResult -match "last_login") {
    Write-Host "✅ La colonne last_login existe déjà" -ForegroundColor Green
} else {
    Write-Host "   La colonne n'existe pas, ajout en cours..." -ForegroundColor Yellow
    
    # Exécuter le script SQL
    $sqlFile = Join-Path $scriptPath "database\add_last_login.sql"
    if (Test-Path $sqlFile) {
        $result = psql -U $pgUser -d $pgDatabase -f $sqlFile 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Colonne last_login ajoutée avec succès" -ForegroundColor Green
        } else {
            Write-Host "❌ Erreur lors de l'ajout:" -ForegroundColor Red
            Write-Host $result -ForegroundColor Red
        }
    } else {
        # Exécuter directement la commande SQL
        $sqlCommand = "ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login TIMESTAMP; CREATE INDEX IF NOT EXISTS idx_users_last_login ON users(last_login DESC);"
        $result = psql -U $pgUser -d $pgDatabase -c $sqlCommand 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Colonne last_login ajoutée avec succès" -ForegroundColor Green
        } else {
            Write-Host "❌ Erreur lors de l'ajout:" -ForegroundColor Red
            Write-Host $result -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "✅ Configuration terminée !" -ForegroundColor Green
Write-Host ""
Write-Host "La dernière connexion sera maintenant enregistrée automatiquement" -ForegroundColor Cyan
Write-Host "lorsque les utilisateurs se connectent." -ForegroundColor Cyan
Write-Host ""

