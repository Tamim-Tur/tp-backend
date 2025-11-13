# Script pour créer le .env et l'admin automatiquement
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration Complète - Sport App" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Étape 1 : Créer le fichier .env
Write-Host "Étape 1 : Création du fichier .env..." -ForegroundColor Yellow
$envFile = Join-Path $scriptPath ".env"

if (Test-Path $envFile) {
    Write-Host "   Le fichier .env existe déjà" -ForegroundColor Cyan
    $overwrite = Read-Host "   Voulez-vous le réécrire ? (o/N)"
    if ($overwrite -ne "o" -and $overwrite -ne "O") {
        Write-Host "   Conservation du fichier existant" -ForegroundColor Green
    } else {
        Write-Host "   Réécriture du fichier .env..." -ForegroundColor Yellow
        Remove-Item $envFile
    }
}

if (-not (Test-Path $envFile)) {
    Write-Host "   Demande du mot de passe PostgreSQL..." -ForegroundColor Cyan
    Write-Host "   (Appuyez sur Entrée pour utiliser 'password' par défaut)" -ForegroundColor Gray
    
    $pgPassword = Read-Host "   Mot de passe PostgreSQL"
    if ([string]::IsNullOrWhiteSpace($pgPassword)) {
        $pgPassword = "password"
        Write-Host "   Utilisation du mot de passe par défaut: password" -ForegroundColor Cyan
    }
    
    $envContent = @"
# PostgreSQL
PG_USER=postgres
PG_HOST=localhost
PG_DATABASE=sportapp
PG_PASSWORD=$pgPassword
PG_PORT=5432

# MongoDB
MONGO_URI=mongodb://localhost:27017/sportapp

# JWT
JWT_SECRET=votre_secret_jwt_tres_securise_changez_moi_123456789
JWT_REFRESH_SECRET=votre_refresh_secret_jwt_tres_securise_changez_moi_987654321

# Server
PORT=3000
NODE_ENV=development

# Frontend
FRONTEND_URL=http://localhost:5173
"@
    $envContent | Out-File -FilePath $envFile -Encoding utf8
    Write-Host "   ✅ Fichier .env créé" -ForegroundColor Green
} else {
    Write-Host "   ✅ Fichier .env existe déjà" -ForegroundColor Green
}

Write-Host ""

# Étape 2 : Demander les informations pour l'admin
Write-Host "Étape 2 : Création du compte admin..." -ForegroundColor Yellow
Write-Host ""

$email = Read-Host "Email de l'admin (Entrée pour admin@example.com)"
if ([string]::IsNullOrWhiteSpace($email)) {
    $email = "admin@example.com"
}

Write-Host "   Mot de passe de l'admin (Entrée pour admin123)" -ForegroundColor Cyan
$password = Read-Host "   " -AsSecureString
$passwordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
)

if ([string]::IsNullOrWhiteSpace($passwordPlain)) {
    $passwordPlain = "admin123"
}

Write-Host ""
Write-Host "Création de l'admin avec :" -ForegroundColor Cyan
Write-Host "   Email: $email" -ForegroundColor White
Write-Host "   Mot de passe: (celui que vous avez entré)" -ForegroundColor White
Write-Host ""

# Étape 3 : Exécuter le script Node.js
Write-Host "Étape 3 : Exécution du script de création..." -ForegroundColor Yellow
node create-admin.js $email $passwordPlain

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✅ Configuration terminée !" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Vous pouvez maintenant :" -ForegroundColor Cyan
    Write-Host "   1. Démarrer le serveur : node server.js" -ForegroundColor White
    Write-Host "   2. Vous connecter avec :" -ForegroundColor White
    Write-Host "      Email: $email" -ForegroundColor Yellow
    Write-Host "      Mot de passe: (celui que vous avez entré)" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  ❌ Erreur lors de la création" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Vérifications à faire :" -ForegroundColor Yellow
    Write-Host "   1. PostgreSQL est démarré ?" -ForegroundColor White
    Write-Host "   2. Le mot de passe dans .env est correct ?" -ForegroundColor White
    Write-Host "   3. La base 'sportapp' existe ? (CREATE DATABASE sportapp;)" -ForegroundColor White
    Write-Host "   4. Les tables sont créées ? (psql -U postgres -d sportapp -f database/schema.sql)" -ForegroundColor White
    Write-Host ""
}

