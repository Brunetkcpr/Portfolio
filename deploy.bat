@echo off
REM Script de déploiement automatisé pour Vercel (Windows)
REM Usage: deploy.bat [--prod] [--skip-checks]

setlocal enabledelayedexpansion

set "PROD_FLAG="
set "SKIP_CHECKS=false"

REM Parsing des arguments
:parse_args
if "%~1"=="" goto parse_done
if "%~1"=="--prod" (
    set "PROD_FLAG=--prod"
    shift
    goto parse_args
)
if "%~1"=="--skip-checks" (
    set "SKIP_CHECKS=true"
    shift
    goto parse_args
)
shift
goto parse_args

:parse_done
echo.
echo ==========================================
echo 🚀 Script de Deploiement Vercel
echo ==========================================
echo.

REM Vérifier que Vercel CLI est installé
vercel --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Vercel CLI non trouvé
    echo Installation: npm install -g vercel
    exit /b 1
)

echo ✓ Vercel CLI trouvé
echo.

REM Étape 1: Corriger les URLs
if /i "%SKIP_CHECKS%"=="false" (
    echo 📝 Etape 1: Correction des URLs...
    
    if exist check-resources.js (
        node fix-urls.js
        if errorlevel 0 (
            echo ✓ URLs corrigées
        )
    )
    echo.
)

REM Étape 2: Vérifier les ressources
if /i "%SKIP_CHECKS%"=="false" (
    echo 📋 Etape 2: Verification des ressources...
    
    if exist check-resources.js (
        node check-resources.js
    )
    echo.
)

REM Étape 3: Vérifier Git
echo 🔄 Etape 3: Verification Git...

git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo.
    echo   Initialisation Git...
    git init
    git add .
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
    for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a:%%b)
    git commit -m "Initial commit: Static WordPress portfolio - !mydate! !mytime!"
) else (
    echo   Repository existant
)

echo ✓ Repository Git prêt
echo.

REM Étape 4: Déploiement Vercel
echo 🚀 Etape 4: Deploiement sur Vercel...

if "!PROD_FLAG!"=="" (
    echo Mode: STAGING (prévisualisation)
    echo Pour déployer en production, utilisez: deploy.bat --prod
    echo.
)

vercel !PROD_FLAG!

echo.
echo ✅ Deploiement terminé!
echo.
echo Prochaines etapes:
echo   1. Acceder a votre site
echo   2. Ouvrir /diagnostic.html pour verifier les ressources
echo   3. Tester avec F12 ^> Network ^> chercher les erreurs 404
echo.

endlocal
