#!/bin/bash

# Script de déploiement automatisé pour Vercel
# Usage: ./deploy.sh [--prod] [--skip-checks]

set -e

COLORS='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'

PROD_FLAG=""
SKIP_CHECKS=false

# Parsing des arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --prod)
      PROD_FLAG="--prod"
      shift
      ;;
    --skip-checks)
      SKIP_CHECKS=true
      shift
      ;;
    *)
      echo "Option inconnue: $1"
      exit 1
      ;;
  esac
done

echo -e "${BLUE}🚀 Script de Déploiement Vercel${COLORS}"
echo "=================================="
echo ""

# Vérifier que Vercel CLI est installé
if ! command -v vercel &> /dev/null; then
    echo -e "${RED}❌ Vercel CLI non trouvé${COLORS}"
    echo "Installation: npm install -g vercel"
    exit 1
fi

echo -e "${GREEN}✓ Vercel CLI trouvé${COLORS}"
echo ""

# Étape 1: Corriger les URLs
if [ "$SKIP_CHECKS" = false ]; then
    echo -e "${YELLOW}📝 Étape 1: Correction des URLs...${COLORS}"
    
    if command -v node &> /dev/null; then
        node fix-urls.js
        echo -e "${GREEN}✓ URLs corrigées${COLORS}"
    else
        echo -e "${YELLOW}⚠ Node.js non trouvé, passage...${COLORS}"
    fi
    echo ""
fi

# Étape 2: Vérifier les ressources
if [ "$SKIP_CHECKS" = false ]; then
    echo -e "${YELLOW}📋 Étape 2: Vérification des ressources...${COLORS}"
    
    if command -v node &> /dev/null; then
        node check-resources.js
        echo ""
    fi
fi

# Étape 3: Vérifier Git
echo -e "${YELLOW}🔄 Étape 3: Vérification Git...${COLORS}"

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${YELLOW}  Initialisation Git...${COLORS}"
    git init
    git add .
    git commit -m "Initial commit: Static WordPress portfolio - $(date '+%Y-%m-%d %H:%M')"
else
    # Vérifier s'il y a des changements
    if ! git diff-index --quiet HEAD --; then
        echo -e "${YELLOW}  Commits des changements...${COLORS}"
        git add .
        git commit -m "Update deployment files - $(date '+%Y-%m-%d %H:%M')"
    fi
fi

echo -e "${GREEN}✓ Repository Git prêt${COLORS}"
echo ""

# Étape 4: Déploiement Vercel
echo -e "${YELLOW}🚀 Étape 4: Déploiement sur Vercel...${COLORS}"

if [ -z "$PROD_FLAG" ]; then
    echo "Mode: STAGING (prévisualisation)"
    echo "Pour déployer en production, utilisez: ./deploy.sh --prod"
    echo ""
fi

vercel $PROD_FLAG

echo ""
echo -e "${GREEN}✅ Déploiement terminé!${COLORS}"
echo ""
echo "Prochaines étapes:"
echo "  1. Accéder à votre site"
echo "  2. Ouvrir /diagnostic.html pour vérifier les ressources"
echo "  3. Tester avec F12 → Network → chercher les erreurs 404"
echo ""
