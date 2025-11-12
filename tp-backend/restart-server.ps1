# Script pour redémarrer le serveur Node.js proprement
Write-Host "🔄 Arrêt des processus Node.js existants..." -ForegroundColor Yellow

# Arrêter tous les processus Node.js
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Attendre un peu pour que les ports soient libérés
Start-Sleep -Seconds 2

Write-Host "✅ Processus arrêtés" -ForegroundColor Green
Write-Host "🚀 Démarrage du serveur..." -ForegroundColor Cyan

# Changer vers le répertoire du serveur
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Démarrer le serveur
node server.js

