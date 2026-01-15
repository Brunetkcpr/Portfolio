# 🐛 TROUBLESHOOTING - Solutions aux Erreurs Courantes

## 🚨 Erreurs les Plus Fréquentes

---

## 1️⃣ Page Blanche / Rien Ne S'affiche

### Symptômes
- Accès au site → page complètement blanche
- Pas de texte, pas d'images, pas de layout

### Causes Possibles
1. Fichier `index.html` manquant
2. Erreur JavaScript bloquante
3. Problème de configuration Vercel

### ✅ Solutions

**Étape 1: Vérifier index.html**
```bash
test -f index.html && echo "✓ Présent" || echo "✗ Manquant"
```

**Étape 2: Vérifier les erreurs console**
1. Ouvrir F12 → Console
2. Recharger la page
3. Chercher les erreurs rouges
4. Noter l'URL ou le message d'erreur

**Étape 3: Vérifier la configuration Vercel**
```bash
cat vercel.json
# Vérifier que outputDirectory = "."
```

**Étape 4: Redéployer**
```bash
npm run build
vercel --prod
```

---

## 2️⃣ CSS Ne S'affiche Pas / Style Cassé

### Symptômes
- Mise en page détruite
- Pas de couleurs/polices
- Erreurs 404 CSS dans F12

### Causes Possibles
1. Chemins CSS cassés
2. Dossier `wp-content/` vide ou manquant
3. Fichiers CSS manquants

### ✅ Solutions

**Étape 1: Corriger les URLs**
```bash
npm run fix
npm run check
```

**Étape 2: Vérifier les fichiers CSS**
```bash
# Vérifier que les CSS existent
ls -la wp-content/plugins/elementor/assets/css/
ls -la wp-content/themes/oceanwp/assets/css/

# Vérifier la taille (ne doit pas être 0)
ls -lh wp-content/themes/oceanwp/assets/css/style.min.css
```

**Étape 3: Vérifier dans F12**
1. F12 → Onglet "Elements" → `<head>`
2. Chercher les balises `<link rel="stylesheet">`
3. Cliquer sur le lien CSS
4. Vérifier le chemin et le contenu

**Étape 4: Tester avec diagnostic**
```
Ouvrir: /diagnostic.html
Onglet: "Ressources" → "Fichiers CSS"
```

**Étape 5: Redéployer**
```bash
npm run fix
git add .
git commit -m "Fix: CSS paths"
vercel --prod
```

---

## 3️⃣ Erreurs 404 - Fichiers Manquants

### Symptômes
- F12 → Network affiche des statuts 404 (rouge)
- Des fichiers CSS/JS/images ne chargent pas

### Causes Possibles
1. Dossiers `wp-content/` ou `wp-includes/` vides
2. Chemins relatifs cassés
3. Structure de dossiers incorrecte

### ✅ Solutions

**Étape 1: Identifier les fichiers manquants**
```bash
# Dans F12 → Network
# Copier les URLs avec erreur 404
# Exemple: /wp-content/plugins/elementor/assets/css/frontend.min.css
```

**Étape 2: Vérifier s'ils existent localement**
```bash
# Remplacer par le chemin réel
test -f wp-content/plugins/elementor/assets/css/frontend.min.css && echo "✓ Existe" || echo "✗ Manquant"
```

**Étape 3: Si le fichier existe localement**
```bash
# C'est un problème de chemins
npm run fix
npm run check
vercel --prod
```

**Étape 4: Si le fichier n'existe pas**
```bash
# Le site WordPress n'a pas été exporté complètement
# Vérifier que Simply Static a bien copié tous les fichiers
ls -la wp-content/
du -sh wp-content/  # Vérifier la taille totale
```

**Étape 5: Utiliser le diagnostic**
```
Ouvrir: /diagnostic.html
Onglet: "Outils"
Cliquer: "Lancer la vérification complète"
```

---

## 4️⃣ JavaScript Ne Fonctionne Pas

### Symptômes
- Les animations ne fonctionnent pas
- Les menus interactifs sont gelés
- Les formulaires ne réagissent pas
- Erreurs `TypeError` ou `ReferenceError` dans console

### Causes Possibles
1. Fichiers JS manquants
2. Ordre de chargement incorrect
3. Chemins relatifs cassés

### ✅ Solutions

**Étape 1: Vérifier les erreurs JS**
```bash
# F12 → Console
# Noter exactement le message d'erreur
# Exemple: "Uncaught ReferenceError: elementorFrontendConfig is not defined"
```

**Étape 2: Vérifier les fichiers JS**
```bash
ls -la wp-content/plugins/elementor/assets/js/
ls -la wp-content/themes/oceanwp/assets/js/
```

**Étape 3: Vérifier les chemins**
```bash
npm run fix
npm run check
```

**Étape 4: Redéployer**
```bash
vercel --prod
```

**Étape 5: Si l'erreur persiste**
1. Ouvrir F12 → Sources
2. Chercher le fichier qui cause l'erreur
3. Vérifier son chemin
4. Chercher des références circulaires ou de l'ordre de chargement

---

## 5️⃣ Images Ne S'affichent Pas

### Symptômes
- Images cassées (icône 🖼️ cassée)
- Erreurs 404 pour les images dans F12

### Causes Possibles
1. Dossier `wp-content/uploads/` vide
2. Chemins relatifs des images cassés
3. Fichiers d'image corrompus

### ✅ Solutions

**Étape 1: Vérifier le dossier uploads**
```bash
ls -la wp-content/uploads/
du -sh wp-content/uploads/  # Doit être > 0
```

**Étape 2: Corriger les chemins d'images**
```bash
npm run fix
npm run check
```

**Étape 3: Vérifier dans F12**
1. F12 → Network
2. Filtrer par "img"
3. Chercher les erreurs 404

**Étape 4: Tester en local**
```bash
npm start
# Accéder à http://localhost:8000
# Vérifier que les images s'affichent
```

**Étape 5: Redéployer**
```bash
vercel --prod
```

---

## 6️⃣ Erreur de Déploiement Vercel

### Symptômes
- Commande `vercel --prod` échoue
- Message d'erreur du build

### Causes Possibles
1. Vercel CLI non installé
2. Pas d'authentification Vercel
3. Problème de repository Git

### ✅ Solutions

**Erreur: "vercel: command not found"**
```bash
# Installer Vercel CLI
npm install -g vercel

# Ou avec yarn
yarn global add vercel
```

**Erreur: "Not authenticated"**
```bash
# Authentifier avec Vercel
vercel login

# Suivre les instructions
```

**Erreur: "Not a git repository"**
```bash
# Initialiser Git
git init
git add .
git commit -m "Initial commit"

# Puis redéployer
vercel --prod
```

**Erreur: "Build failed"**
```bash
# Vérifier les logs
vercel logs

# Vérifier la configuration
cat vercel.json

# Vérifier le script build
cat package.json | grep build

# Redéployer
vercel --prod
```

---

## 7️⃣ Cache Problématique

### Symptômes
- Anciennes versions du site s'affichent
- Modifications ne prennent pas effet
- F12 affiche des fichiers en cache

### Causes Possibles
1. Navigateur cache aggressif
2. CDN cache de Vercel
3. Service Worker actif

### ✅ Solutions

**Solution 1: Hard Refresh (Navigateur)**
```
macOS: Cmd + Shift + R
Windows/Linux: Ctrl + Shift + R
Firefox: Ctrl + Maj + R
```

**Solution 2: Vider le cache Vercel**
```bash
# Redéployer avec --prod
vercel --prod --skip-verify

# Ou via le dashboard Vercel
# Settings → Git → Deployments → "Redeploy"
```

**Solution 3: Vider le cache navigateur**
1. F12 → Settings (gear icon)
2. "Network" → Cocher "Disable cache (while DevTools is open)"
3. Recharger la page

**Solution 4: Service Worker**
Si un Service Worker bloque le cache:
```javascript
// Console navigateur
navigator.serviceWorker.getRegistrations().then(registrations => {
  registrations.forEach(reg => reg.unregister());
});
```

---

## 8️⃣ Performance Lente

### Symptômes
- Temps de chargement > 5 secondes
- Page gel pendant le chargement
- Images prennent longtemps à afficher

### Causes Possibles
1. Caching désactivé
2. Fichiers non compressés
3. Trop d'images non optimisées

### ✅ Solutions

**Étape 1: Vérifier le caching**
```bash
# Vérifier les headers de cache
curl -I https://votre-site.vercel.app/wp-content/themes/oceanwp/assets/css/style.min.css

# Doit afficher: cache-control: public, max-age=31536000, immutable
```

**Étape 2: Vérifier la compression**
```bash
# Vérifier GZIP
curl -I -H "Accept-Encoding: gzip" https://votre-site.vercel.app

# Doit afficher: content-encoding: gzip
```

**Étape 3: Mesurer les performances**
1. Ouvrir https://pagespeed.insights.google.com
2. Entrer l'URL du site
3. Analyser les recommandations

**Étape 4: Optimiser les images**
```bash
# Chercher les images volumineuses
find wp-content/uploads -name "*.jpg" -o -name "*.png" | xargs du -sh

# Utiliser ImageOptim (macOS) ou similar
```

---

## 9️⃣ Problème de CORS ou Ressources Externes

### Symptômes
- Erreurs CORS dans console
- Ressources externes ne chargent pas

### Causes Possibles
1. WordPress fait des requêtes vers le vrai serveur
2. URLs absolues vers des domaines externes
3. Configuration CORS manquante

### ✅ Solutions

**Étape 1: Identifier les requêtes problématiques**
```bash
# F12 → Console
# Chercher les erreurs "CORS" ou "blocked"
# F12 → Network → filtrer "xhr" et "fetch"
```

**Étape 2: Si ce sont des requêtes WordPress**
```bash
# Corriger les URLs
npm run fix

# Vérifier
npm run check
```

**Étape 3: Si ce sont des ressources CDN**
```bash
# Mettre à jour vercel.json avec les headers CORS corrects
cat vercel.json  # Vérifier que les headers existent
```

**Étape 4: Redéployer**
```bash
npm run build
vercel --prod
```

---

## 🔟 Autres Erreurs

### Erreur: "Mixed Content" (http et https mélangés)

**Cause**: Le site charge du contenu HTTP sur HTTPS

**Solution**:
```bash
# Chercher les URLs http://
grep -r "http://" wp-content/ --include="*.html"

# Corriger manuellement ou utiliser:
npm run fix
```

### Erreur: "File not found" dans logs Vercel

**Cause**: Un fichier référencé n'existe pas

**Solution**:
```bash
# Vérifier quel fichier manque dans les logs Vercel
vercel logs

# Chercher le fichier localement
find . -name "[fichier]" -type f

# Si absent, recopier depuis le dossier WordPress source
```

### Erreur: "Permission denied"

**Cause**: Fichiers non accessibles

**Solution**:
```bash
# Changer les permissions
chmod -R 755 wp-content/
chmod -R 755 wp-includes/
```

---

## 📞 Si Aucune Solution Ne Fonctionne

1. **Vérifier la documentation**
   - Relire `DEPLOYMENT.md`
   - Consulter `FIXES.md`
   - Vérifier `CHECKLIST.md`

2. **Tester en local**
   ```bash
   npm start
   # Accéder à http://localhost:8000
   # Vérifier que le problème existe aussi localement
   ```

3. **Réexport depuis WordPress**
   - Reexporter le site avec Simply Static
   - S'assurer d'avoir tous les fichiers
   - Replacer dans le dossier `simply-static-1-1768496043`

4. **Réinitialiser**
   ```bash
   npm run check  # Diagnostic complet
   npm run fix    # Corrections automatiques
   git add .
   git commit -m "Full reset and fixes"
   vercel --prod  # Redéploiement complet
   ```

---

## 🔗 Ressources Utiles

| Problème | Ressource |
|----------|-----------|
| Erreurs Vercel | https://vercel.com/docs/error-codes |
| Performance | https://pagespeed.insights.google.com |
| CORS | https://enable-cors.org |
| Cache | https://web.dev/http-cache/ |
| WordPress | https://wordpress.org/support/ |

---

**Dernière mise à jour**: 15 janvier 2026

*Utilisez `/diagnostic.html` pour identifier rapidement les problèmes.*
