# 📋 GUIDE PAR CAS D'USAGE

## Situation: J'ai juste uploadé sur Vercel et ça ne marche pas

### Actions Immédiates

**1. Vérifier la page**
- Accéder à votre URL Vercel
- Ouvrir F12 (Developer Tools)
- Onglet "Console" → Chercher erreurs rouges
- Onglet "Network" → Chercher 404 (rouge)

**2. Diagnostic rapide**
```bash
cd simply-static-1-1768496043
npm run check
```

**3. Corriger et redéployer**
```bash
npm run fix
vercel --prod
```

**Temps estimé**: 2 minutes

---

## Situation: Les styles CSS ne s'affichent pas

### Diagnostic

**Étape 1**: Vérifier les fichiers
```bash
ls -la wp-content/themes/
ls -la wp-content/plugins/elementor/assets/css/
```

**Étape 2**: Tester localement
```bash
npm start
# Ouvrir http://localhost:8000
# Si OK localement → problème Vercel
# Si KO localement → problème fichiers
```

### Solution

**Si OK localement**:
```bash
npm run fix
npm run check
git add .
git commit -m "Fix CSS paths"
vercel --prod
```

**Si KO localement**:
1. Réexporter depuis WordPress (Simply Static)
2. Replacer les fichiers
3. Exécuter `npm run fix`
4. Redéployer

**Temps estimé**: 5-10 minutes

---

## Situation: Les JavaScript ne fonctionne pas (pas d'interactivité)

### Test Rapide
```javascript
// Dans la console (F12)
console.log(window.elementorFrontendConfig);
// Si undefined → JS Elementor ne charge pas
```

### Solution

```bash
npm run check      # Voir quel fichier JS manque
npm run fix        # Corriger les chemins
npm start          # Tester en local
# Vérifier dans la console que les objets globaux existent

# Si OK localement
git add .
git commit -m "Fix JS paths"
vercel --prod
```

**Temps estimé**: 5 minutes

---

## Situation: Les images ne s'affichent pas

### Diagnostic Rapide
```bash
# Vérifier qu'il y a des images
find wp-content/uploads -type f | head -10

# Vérifier la structure
ls -la wp-content/uploads/
```

### Solution
```bash
npm run fix        # Corriger les chemins d'images
npm run check      # Vérifier
npm start          # Tester en local

# Si OK en local
vercel --prod
```

**Temps estimé**: 3 minutes

---

## Situation: Le site marche localement mais pas sur Vercel

### Diagnostic
1. Vérifier que `vercel.json` existe
2. Vérifier que `outputDirectory: "."` dans `vercel.json`
3. Vérifier les logs Vercel

```bash
vercel logs
```

### Solution
```bash
# Nettoyer et redéployer
npm run build
git add .
git commit -m "Vercel deployment fix"
vercel --prod
```

**Temps estimé**: 5 minutes

---

## Situation: Erreurs 404 sur les fichiers

### Identifier le problème

Dans F12 → Network:
1. Chercher les lignes rouges (404)
2. Copier le chemin exact
3. Vérifier localement

```bash
# Exemple si erreur sur /wp-content/plugins/elementor/assets/css/frontend.min.css
test -f wp-content/plugins/elementor/assets/css/frontend.min.css && echo "Existe" || echo "Manquant"
```

### Si Existe Localement
```bash
# Problème de chemin
npm run fix
npm run check
git add .
git commit -m "Fix paths for Vercel"
vercel --prod
```

### Si Manquant Localement
```bash
# Besoin de réexporter depuis WordPress
# 1. Aller sur WordPress admin
# 2. Plugins → Simply Static
# 3. "Generate Static Files"
# 4. Remplacer le dossier simplement-static-1-XXXXX
```

**Temps estimé**: 5-20 minutes selon la cause

---

## Situation: Cache problématique (anciennes versions)

### Solution Rapide
```bash
# Hard refresh navigateur
# macOS: Cmd + Shift + R
# Windows: Ctrl + Shift + R

# Ou forcer nouveau déploiement
vercel --prod --skip-verify
```

### Solution Complète
```bash
# Vider le cache Vercel complètement
git commit -m "Cache bust" --allow-empty
vercel --prod
```

**Temps estimé**: 1 minute

---

## Situation: Déploiement échoue (build error)

### Voir l'erreur
```bash
vercel logs
```

### Erreur: "vercel: command not found"
```bash
npm install -g vercel
```

### Erreur: "Not authenticated"
```bash
vercel login
```

### Erreur: "Not a git repository"
```bash
git init
git add .
git commit -m "Initial"
vercel --prod
```

### Autre erreur
1. Copier le message exact
2. Googler: "vercel [message erreur]"
3. Vérifier le fichier problématique

**Temps estimé**: 5-10 minutes

---

## Situation: Je veux un domaine personnalisé

### Configuration Vercel
1. Aller sur vercel.com/dashboard
2. Sélectionner le projet
3. Settings → Domains
4. Ajouter le domaine
5. Suivre les instructions

### Pour un domaine acheté ailleurs
1. Aller chez le registrar (GoDaddy, Namecheap, etc.)
2. Changer les DNS selon les instructions Vercel
3. Attendre 24h pour la propagation

**Temps estimé**: 10-30 min (+ 24h attente)

---

## Situation: Performance lente

### Mesure
```bash
# Accéder à Google PageSpeed
https://pagespeed.insights.google.com
# Entrer l'URL
```

### Optimisations Rapides

**1. Vérifier le caching**
```bash
curl -I https://votre-site.vercel.app/wp-content/themes/oceanwp/assets/css/style.min.css
# Doit avoir: cache-control: public, max-age=31536000
```

**2. Activer la compression**
```bash
# Déjà configurée dans vercel.json
# Vérifier:
curl -I -H "Accept-Encoding: gzip" https://votre-site.vercel.app
# Doit avoir: content-encoding: gzip
```

**3. Optimiser les images**
```bash
# Chercher les grosses images
find wp-content/uploads -size +1M -type f
# Réduire leur taille avec ImageOptim ou similar
```

**Temps estimé**: 10-30 minutes

---

## Situation: HTTPS/Sécurité

### Auto-SSL (Automatique)
- Vercel fourni automatiquement un certificat SSL
- Aucune action requise
- Accédez via `https://`

### Certificat personnalisé
1. Dashboard Vercel → Settings → SSL/TLS
2. "Custom Certificate"
3. Uploader les fichiers

**Temps estimé**: 5 minutes (auto) ou 15 min (custom)

---

## Situation: Revert à une version antérieure

### Depuis le Dashboard Vercel
1. Aller sur vercel.com/dashboard
2. Projet → Deployments
3. Chercher le déploiement à revenir
4. Cliquer sur les 3 points → Promote to Production

### Via CLI
```bash
vercel list              # Voir tous les déploiements
vercel rollback [url]    # Revenir à une version
```

**Temps estimé**: 2-5 minutes

---

## Situation: Je veux voir les anciennes versions

### Depuis Vercel Dashboard
- Deployments → Voir l'historique
- Cliquer sur un déploiement
- "Visit" pour prévisualiser

### Via logs
```bash
vercel list --limit 50   # Voir 50 derniers déploiements
```

**Temps estimé**: 1 minute

---

## Situation: Collaborateurs/Équipe

### Ajouter des collaborateurs
1. Dashboard Vercel → Project Settings
2. Collaborators → Add
3. Entrer l'email

### Permissions
- **Admin**: Accès complet
- **Member**: Déploiement et config
- **Guest**: Prévisualisation uniquement

**Temps estimé**: 5 minutes

---

## 📞 Checklist Finale par Scénario

### ✅ Scénario: Dépanner Rapidement (5 min)
- [ ] Ouvrir F12
- [ ] Chercher erreurs rouges
- [ ] Exécuter `npm run check`
- [ ] Exécuter `npm run fix`
- [ ] Redéployer: `vercel --prod`

### ✅ Scénario: Déployer Correctement (10 min)
- [ ] `npm run fix`
- [ ] `npm run check`
- [ ] `npm start` (tester local)
- [ ] `git add . && git commit -m "..."`
- [ ] `vercel --prod`

### ✅ Scénario: Problème Complexe (30 min)
- [ ] Lire `TROUBLESHOOTING.md`
- [ ] Accéder à `/diagnostic.html`
- [ ] Lancer diagnostic complet
- [ ] Noter les 404
- [ ] Vérifier localement
- [ ] Corriger et redéployer

---

**Besoin d'aide rapide?** Accéder à `/diagnostic.html` pour un diagnostic interactif.

*Créé: 15 janvier 2026*
