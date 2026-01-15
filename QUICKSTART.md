# ⚡ GUIDE RAPIDE - 5 MINUTES

## 🎯 Objectif
Déployer votre site WordPress statique sur Vercel en 5 minutes.

---

## 🚀 Déploiement Rapide

### Sur macOS/Linux:
```bash
cd simply-static-1-1768496043
./deploy.sh --prod
```

### Sur Windows:
```cmd
cd simply-static-1-1768496043
deploy.bat --prod
```

### Ou manuellement (tous les OS):
```bash
cd simply-static-1-1768496043

# 1. Corriger les URLs
npm run fix

# 2. Vérifier les fichiers
npm run check

# 3. Déployer
vercel --prod
```

---

## ✅ Vérification Post-Déploiement

**1. Accéder au site**
- Ouvrir l'URL donnée par Vercel
- Vérifier que la page s'affiche correctement

**2. Vérifier les ressources**
- Aller à: `https://votre-site.vercel.app/diagnostic.html`
- Cliquer sur "Lancer la vérification complète"
- Chercher les fichiers en ✗ (manquants)

**3. Vérifier dans F12**
- Ouvrir F12 → Onglet "Network"
- Recharger la page (Ctrl+R)
- Chercher les erreurs 404 (rouge)

---

## 🆘 Si Ça Ne Marche Pas

### Les styles ne s'affichent pas
```bash
# Vérifier les fichiers CSS
ls -la wp-content/plugins/
ls -la wp-content/themes/

# Réappliquer les corrections
npm run fix
npm run check
```

### Page blanche
1. Ouvrir F12 → Console
2. Chercher les erreurs rouges
3. Noter l'URL qui cause le problème
4. Vérifier si le fichier existe: `ls -la [fichier]`

### Erreur 404 sur /wp-content/
- Vérifier que le dossier existe: `ls -la wp-content/`
- S'il est vide, le site WordPress n'a pas été exporté correctement

---

## 📋 Checklist Rapide

- [ ] Exécuter `./deploy.sh --prod` (ou `deploy.bat --prod`)
- [ ] Vérifier que le déploiement est réussi (vert ✓)
- [ ] Ouvrir l'URL du site
- [ ] Tester `/diagnostic.html`
- [ ] Ouvrir F12 → Network → pas d'erreurs 404
- [ ] Tester sur mobile

---

## 🔗 Ressources

- **Vercel Dashboard**: https://vercel.com/dashboard
- **Page Diagnostic**: `/diagnostic.html`
- **Documentation**: `DEPLOYMENT.md`
- **Problèmes**: `FIXES.md`

---

## ⚡ Commandes Utiles

```bash
# Tester localement
npm start

# Vérifier les fichiers manquants
npm run check

# Corriger les URLs manuellement
npm run fix

# Voir le dernier déploiement Vercel
vercel list

# Redéployer la version actuelle
vercel --prod

# Voir les logs de déploiement
vercel logs
```

---

## 💡 Conseils

1. **Avant de déployer**: Toujours exécuter `npm run check`
2. **Si problème**: Aller à `/diagnostic.html`
3. **Cache problématique**: Hard refresh: Ctrl+Shift+R (ou Cmd+Shift+R)
4. **Production**: Toujours utiliser `--prod` pour éviter les doublons

---

**Besoin d'aide?** Consulter `DEPLOYMENT.md` pour le guide complet.

*Créé: 15 janvier 2026*
