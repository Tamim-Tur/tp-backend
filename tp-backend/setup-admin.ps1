# Script pour configurer et créer un admin automatiquement
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration Admin - Sport App" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Vérifier si .env existe
$envFile = Join-Path $scriptPath ".env"
if (-not (Test-Path $envFile)) {
    Write-Host "[INFO] Création du fichier .env..." -ForegroundColor Yellow
    $envContent = @"
# PostgreSQL
PG_USER=postgres
PG_HOST=localhost
PG_DATABASE=sportapp
PG_PASSWORD=password
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
    Write-Host "[OK] Fichier .env créé" -ForegroundColor Green
} else {
    Write-Host "[OK] Fichier .env existe déjà" -ForegroundColor Green
}

# Demander les informations pour l'admin
Write-Host ""
Write-Host "Création d'un compte admin" -ForegroundColor Yellow
Write-Host ""

$email = Read-Host "Email de l'admin (ex: admin@example.com)"
if ([string]::IsNullOrWhiteSpace($email)) {
    $email = "admin@example.com"
    Write-Host "   Utilisation de l'email par défaut: $email" -ForegroundColor Cyan
}

$password = Read-Host "Mot de passe de l'admin" -AsSecureString
$passwordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
)

if ([string]::IsNullOrWhiteSpace($passwordPlain)) {
    $passwordPlain = "admin123"
    Write-Host "   Utilisation du mot de passe par défaut: admin123" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Création de l'admin..." -ForegroundColor Yellow

# Exécuter le script Node.js
node create-admin.js $email $passwordPlain

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✅ Admin créé avec succès !" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Vous pouvez maintenant vous connecter avec :" -ForegroundColor Cyan
    Write-Host "  Email: $email" -ForegroundColor White
    Write-Host "  Mot de passe: (celui que vous avez entré)" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  ❌ Erreur lors de la création" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Vérifiez :" -ForegroundColor Yellow
    Write-Host "  1. Que PostgreSQL est démarré" -ForegroundColor Yellow
    Write-Host "  2. Que le mot de passe dans .env correspond à votre PostgreSQL" -ForegroundColor Yellow
    Write-Host "  3. Que la base de données 'sportapp' existe" -ForegroundColor Yellow
    Write-Host "  4. Que les tables sont créées (exécutez database/schema.sql)" -ForegroundColor Yellow
    Write-Host ""
}

