# Guide de Déploiement sur Vercel

## 🚀 Guide Rapide

### 1. Préparation Locale

```bash
# Aller au dossier du projet
cd simply-static-1-1768496043

# Vérifier et corriger les ressources
npm run fix
npm run check
```

### 2. Initialiser Git

```bash
# Si git n'est pas initialisé
git init
git add .
git commit -m "Initial commit: Static WordPress portfolio"
```

### 3. Déployer sur Vercel

**Option A: Via CLI (Recommandé)**
```bash
npm install -g vercel
vercel
```

**Option B: Via GitHub**
1. Pousser le code sur GitHub
2. Aller à https://vercel.com
3. Cliquer sur "New Project"
4. Importer le repository GitHub
5. Configuration:
   - Framework: Other
   - Root Directory: ./
   - Build Command: `npm run build`
   - Output Directory: .

## ⚙️ Configuration Vercel

Le fichier `vercel.json` contient:
- ✅ **Caching** des assets statiques (1 an)
- ✅ **Compression GZIP** automatique
- ✅ **Réécriture d'URLs** pour le routage
- ✅ **Headers de sécurité**

## 🔍 Vérification Post-Déploiement

### 1. Vérifier les Assets Statiques
```bash
curl -I https://votre-site.vercel.app/wp-content/plugins/elementor/assets/css/frontend.min.css
# Doit retourner: HTTP 200
```

### 2. Vérifier les Redirections
- Accédez à `https://votre-site.vercel.app`
- Ouvrez F12 → Onglet "Network"
- Vérifiez qu'aucun fichier ne retourne 404

### 3. Tester les Ressources
```javascript
// Console du navigateur
document.querySelectorAll('[href*="/wp-content"], [src*="/wp-content"]').forEach(el => {
  const url = el.href || el.src;
  fetch(url).then(r => {
    console.log(r.status, url);
  }).catch(e => console.error('ERREUR', url));
});
```

## 🐛 Dépannage

### Les styles ne s'affichent pas
**Symptôme**: Page blanche ou mal formatée

**Solutions**:
1. Vérifier que `/wp-content/plugins/` existe
2. Vérifier que `/wp-content/themes/oceanwp/` existe
3. Dans F12, chercher les erreurs 404 CSS
4. Exécuter: `npm run check`

```bash
# Exemple
npm run check
# Affichera les fichiers manquants
```

### Les images ne s'affichent pas
**Symptôme**: Images cassées ou manquantes

**Cause courante**: Chemins relatifs cassés

**Solution**:
```bash
npm run fix
git add .
git commit -m "Fix: Correction des chemins d'images"
vercel --prod
```

### Erreur 404 sur toutes les pages
**Cause**: Output directory mal configuré

**Solution**:
1. Vérifier `vercel.json`
2. S'assurer que `outputDirectory` = `.`
3. Redéployer: `vercel --prod`

### Performance lente
**Cause**: Caching non activé

**Vérification**:
```bash
curl -I https://votre-site.vercel.app/wp-content/themes/oceanwp/assets/css/style.min.css
# Chercher: "cache-control: public, max-age=31536000"
```

## 📊 Checklist Finale

- [ ] Fichiers HTML valides
- [ ] Dossiers `wp-content/` et `wp-includes/` présents
- [ ] `npm run check` sans erreurs
- [ ] Git repository initialisé
- [ ] Déployé sur Vercel
- [ ] Page d'accueil charge correctement
- [ ] CSS/JS chargés (F12 → Network)
- [ ] Pas d'erreurs console (F12 → Console)
- [ ] Images visibles
- [ ] Responsive (test mobile)

## 🆘 Support

### Besoin d'aide?

1. **Vérifier les logs Vercel**
   - Dashboard Vercel → Project → Deployments → Logs

2. **Tester localement**
   ```bash
   npm start
   # Ouvre http://localhost:8000
   ```

3. **Vérifier la structure**
   ```bash
   ls -la
   ls -la wp-content/
   ls -la wp-includes/
   ```

## 🔗 Ressources Utiles

- [Documentation Vercel](https://vercel.com/docs)
- [Déployer un site statique](https://vercel.com/docs/frameworks/static-site-generation)
- [Configuration JSON de Vercel](https://vercel.com/docs/configuration)

---

**Dernière mise à jour**: 15 janvier 2026
