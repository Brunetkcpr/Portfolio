#!/bin/bash

# 🧪 Script de test pré-déploiement
# Exécuter ceci avant de déployer sur Vercel

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🧪 TEST PRÉ-DÉPLOIEMENT${NC}"
echo "=============================="
echo ""

# Compteurs
TESTS_TOTAL=0
TESTS_PASSES=0
TESTS_ECHOUES=0

# Fonction de test
test_condition() {
    local description=$1
    local condition=$2
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if eval "$condition"; then
        echo -e "${GREEN}✓${NC} $description"
        TESTS_PASSES=$((TESTS_PASSES + 1))
    else
        echo -e "${RED}✗${NC} $description"
        TESTS_ECHOUES=$((TESTS_ECHOUES + 1))
    fi
}

# 1. Vérifications de Fichiers
echo -e "${YELLOW}📋 Fichiers Essentiels${NC}"
test_condition "index.html existe" "[ -f index.html ]"
test_condition "wp-content existe" "[ -d wp-content ]"
test_condition "wp-includes existe" "[ -d wp-includes ]"
test_condition "vercel.json existe" "[ -f vercel.json ]"
test_condition "package.json existe" "[ -f package.json ]"
echo ""

# 2. Vérifications de Structure
echo -e "${YELLOW}🗂️  Structure WordPress${NC}"
test_condition "wp-content/plugins existe" "[ -d wp-content/plugins ]"
test_condition "wp-content/themes existe" "[ -d wp-content/themes ]"
test_condition "wp-content/uploads existe" "[ -d wp-content/uploads ]"
test_condition "wp-includes/js existe" "[ -d wp-includes/js ]"
test_condition "wp-includes/css existe" "[ -d wp-includes/css ]"
echo ""

# 3. Vérifications de Fichiers Critiques
echo -e "${YELLOW}⚙️  Fichiers Critiques${NC}"
test_condition "elementor css existe" "[ -f wp-content/plugins/elementor/assets/css/frontend.min.css ]"
test_condition "elementor js existe" "[ -f wp-content/plugins/elementor/assets/js/frontend.min.js ]"
test_condition "oceanwp css existe" "[ -f wp-content/themes/oceanwp/assets/css/style.min.css ]"
test_condition "oceanwp js existe" "[ -f wp-content/themes/oceanwp/assets/js/theme.min.js ]"
echo ""

# 4. Vérifications de Configuration
echo -e "${YELLOW}⚙️  Configuration${NC}"
test_condition "vercel.json est valide" "node -e 'require(\"./vercel.json\")' 2>/dev/null"
test_condition "package.json est valide" "node -e 'require(\"./package.json\")' 2>/dev/null"
test_condition "package.json a script build" "grep -q '\"build\"' package.json"
test_condition "package.json a script check" "grep -q '\"check\"' package.json"
test_condition "package.json a script fix" "grep -q '\"fix\"' package.json"
echo ""

# 5. Vérifications de Documentation
echo -e "${YELLOW}📚 Documentation${NC}"
test_condition "README.md existe" "[ -f README.md ]"
test_condition "QUICKSTART.md existe" "[ -f QUICKSTART.md ]"
test_condition "DEPLOYMENT.md existe" "[ -f DEPLOYMENT.md ]"
test_condition "TROUBLESHOOTING.md existe" "[ -f TROUBLESHOOTING.md ]"
test_condition "diagnostic.html existe" "[ -f diagnostic.html ]"
echo ""

# 6. Vérifications de Permissions
echo -e "${YELLOW}🔐 Permissions${NC}"
test_condition "index.html est lisible" "[ -r index.html ]"
test_condition "wp-content est accessible" "[ -r wp-content ] && [ -x wp-content ]"
test_condition "deploy.sh est exécutable" "[ -x deploy.sh ]"
echo ""

# Résumé
echo "=============================="
echo -e "${BLUE}📊 Résumé des Tests${NC}"
echo "=============================="
echo -e "Tests passés:   ${GREEN}${TESTS_PASSES}/${TESTS_TOTAL}${NC}"
echo -e "Tests échoués:  ${RED}${TESTS_ECHOUES}/${TESTS_TOTAL}${NC}"
echo ""

if [ $TESTS_ECHOUES -eq 0 ]; then
    echo -e "${GREEN}✅ TOUS LES TESTS PASSÉS - Prêt pour le déploiement!${NC}"
    echo ""
    echo "Prochaines étapes:"
    echo "  1. npm run fix"
    echo "  2. npm run check"
    echo "  3. ./deploy.sh --prod"
    echo ""
    exit 0
else
    echo -e "${RED}❌ CERTAINS TESTS ONT ÉCHOUÉ - Vérifiez ci-dessus${NC}"
    echo ""
    echo "Actions suggérées:"
    echo "  • Vérifier que Simply Static a bien exporté tous les fichiers"
    echo "  • Vérifier la structure du dossier"
    echo "  • Relire la documentation: DEPLOYMENT.md"
    echo ""
    exit 1
fi
