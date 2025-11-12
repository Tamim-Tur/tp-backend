# Script de configuration PostgreSQL pour Windows
# Ce script aide a configurer PostgreSQL pour l'application

Write-Host "`n[INFO] Configuration PostgreSQL pour SportApp`n" -ForegroundColor Cyan

# Verifier si PostgreSQL est installe
Write-Host "1. Verification de l'installation PostgreSQL..." -ForegroundColor Yellow
$pgPath = Get-Command psql -ErrorAction SilentlyContinue

if (-not $pgPath) {
    Write-Host "[ERREUR] PostgreSQL n'est pas installe ou n'est pas dans le PATH" -ForegroundColor Red
    Write-Host "`n[ASTUCE] Veuillez installer PostgreSQL depuis:" -ForegroundColor Yellow
    Write-Host "   https://www.postgresql.org/download/windows/" -ForegroundColor Cyan
    Write-Host "`n[ATTENTION] Apres l'installation, relancez ce script.`n" -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] PostgreSQL trouve: $($pgPath.Source)" -ForegroundColor Green

# Verifier le service PostgreSQL
Write-Host "`n2. Verification du service PostgreSQL..." -ForegroundColor Yellow
$pgService = Get-Service -Name "*postgresql*" -ErrorAction SilentlyContinue

if ($pgService) {
    Write-Host "[OK] Service trouve: $($pgService.Name)" -ForegroundColor Green
    Write-Host "   Statut: $($pgService.Status)" -ForegroundColor $(if ($pgService.Status -eq 'Running') { 'Green' } else { 'Yellow' })
    
    if ($pgService.Status -ne 'Running') {
        Write-Host "`n[ATTENTION] Demarrage du service..." -ForegroundColor Yellow
        try {
            Start-Service -Name $pgService.Name
            Write-Host "[OK] Service demarre" -ForegroundColor Green
        } catch {
            Write-Host "[ERREUR] Impossible de demarrer le service. Executez en tant qu'administrateur." -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "[ATTENTION] Service PostgreSQL non trouve (peut etre normal selon l'installation)" -ForegroundColor Yellow
}

# Lire le fichier .env
Write-Host "`n3. Verification du fichier .env..." -ForegroundColor Yellow
$envFile = Join-Path $PSScriptRoot ".env"

if (-not (Test-Path $envFile)) {
    Write-Host "[ERREUR] Fichier .env non trouve" -ForegroundColor Red
    Write-Host "[ASTUCE] Creation du fichier .env..." -ForegroundColor Yellow
    
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
JWT_SECRET=votre_secret_jwt_tres_securise_changez_moi
JWT_REFRESH_SECRET=votre_refresh_secret_jwt_tres_securise_changez_moi

# Server
PORT=3000
NODE_ENV=development

# Frontend
FRONTEND_URL=http://localhost:5173
"@
    $envContent | Out-File -FilePath $envFile -Encoding utf8
    
    Write-Host "[OK] Fichier .env cree" -ForegroundColor Green
}

# Extraire le mot de passe du .env
$envContent = Get-Content $envFile -Raw
if ($envContent -match "PG_PASSWORD=(.+)") {
    $currentPassword = $matches[1].Trim()
    Write-Host "   Mot de passe actuel dans .env: $currentPassword" -ForegroundColor Cyan
} else {
    Write-Host "[ATTENTION] Impossible de lire PG_PASSWORD du fichier .env" -ForegroundColor Yellow
    $currentPassword = "password"
}

# Tester la connexion
Write-Host "`n4. Test de connexion a PostgreSQL..." -ForegroundColor Yellow
$env:PGPASSWORD = $currentPassword

try {
    $testResult = psql -U postgres -h localhost -c "SELECT version();" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Connexion reussie !" -ForegroundColor Green
        $connectionOk = $true
    } else {
        Write-Host "[ERREUR] Echec de la connexion" -ForegroundColor Red
        Write-Host "   Erreur: $testResult" -ForegroundColor Red
        $connectionOk = $false
    }
} catch {
    Write-Host "[ERREUR] Erreur lors du test de connexion" -ForegroundColor Red
    $connectionOk = $false
}

if (-not $connectionOk) {
    Write-Host "`n[ASTUCE] Le mot de passe dans .env ne correspond pas au mot de passe PostgreSQL" -ForegroundColor Yellow
    Write-Host "`nOptions:" -ForegroundColor Cyan
    Write-Host "  1. Modifiez le fichier .env avec votre mot de passe PostgreSQL reel" -ForegroundColor White
    Write-Host "  2. Ou changez le mot de passe PostgreSQL pour correspondre a celui du .env:" -ForegroundColor White
    Write-Host "     psql -U postgres" -ForegroundColor Cyan
    Write-Host "     ALTER USER postgres WITH PASSWORD '$currentPassword';" -ForegroundColor Cyan
    Write-Host "     \q" -ForegroundColor Cyan
    exit 1
}

# Verifier si la base de donnees existe
Write-Host "`n5. Verification de la base de donnees 'sportapp'..." -ForegroundColor Yellow
$dbCheck = psql -U postgres -h localhost -tAc "SELECT 1 FROM pg_database WHERE datname='sportapp'" 2>&1

if ($dbCheck -match "1") {
    Write-Host "[OK] Base de donnees 'sportapp' existe deja" -ForegroundColor Green
} else {
    Write-Host "[ATTENTION] Base de donnees 'sportapp' n'existe pas" -ForegroundColor Yellow
    Write-Host "[ASTUCE] Creation de la base de donnees..." -ForegroundColor Cyan
    
    $createDb = psql -U postgres -h localhost -c "CREATE DATABASE sportapp;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Base de donnees creee" -ForegroundColor Green
    } else {
        Write-Host "[ERREUR] Erreur lors de la creation: $createDb" -ForegroundColor Red
    }
}

# Verifier si le schema SQL existe
Write-Host "`n6. Verification du schema SQL..." -ForegroundColor Yellow
$schemaFile = Join-Path $PSScriptRoot "database\schema.sql"

if (Test-Path $schemaFile) {
    Write-Host "[OK] Fichier schema.sql trouve" -ForegroundColor Green
    Write-Host "[ASTUCE] Pour executer le schema SQL, utilisez:" -ForegroundColor Cyan
    Write-Host "   psql -U postgres -d sportapp -f database\schema.sql" -ForegroundColor White
} else {
    Write-Host "[ATTENTION] Fichier schema.sql non trouve" -ForegroundColor Yellow
}

Write-Host "`n[SUCCES] Configuration terminee !" -ForegroundColor Green
Write-Host "`n[INFO] Vous pouvez maintenant demarrer le serveur:" -ForegroundColor Cyan
Write-Host "   node server.js`n" -ForegroundColor White

