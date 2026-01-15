# Portfolio Brunet Ethan - Version Statique

## Structure du Projet

Ce projet est une version statique d'un site WordPress déployée sur Vercel.

```
simply-static-1-1768496043/
├── index.html                 # Page d'accueil
├── wp-content/                # Assets du WordPress (CSS, JS, images)
├── wp-includes/               # Fichiers WordPress inclus
├── package.json               # Configuration npm pour Vercel
├── vercel.json                # Configuration Vercel
├── .htaccess                  # Configuration Apache (optionnel)
└── README.md                  # Ce fichier
```

## Déploiement sur Vercel

### Prérequis
- Un compte Vercel (vercel.com)
- Git configuré sur votre machine

### Étapes de déploiement

1. **Initialiser le repository Git** (si ce n'est pas fait)
```bash
cd simply-static-1-1768496043
git init
git add .
git commit -m "Initial commit: Static WordPress site"
```

2. **Déployer sur Vercel**
```bash
npm install -g vercel
vercel
```

3. **Configuration lors du déploiement**
- Sélectionnez le répertoire du projet
- Framework: Static Site
- Output Directory: . (point, répertoire courant)

## Dépannage

### Erreur 404 sur les pages

Si vous recevez une erreur 404, c'est généralement dû à:
1. **Chemins cassés** - Les fichiers CSS/JS doivent être accessible via `/wp-content/` et `/wp-includes/`
2. **Structure manquante** - Assurez-vous que les dossiers `wp-content` et `wp-includes` sont présents

### Les styles ne s'affichent pas

- Vérifiez que les fichiers CSS sont présents dans `wp-content/plugins/` et `wp-content/themes/`
- Ouvrez la console du navigateur (F12) pour voir les erreurs 404
- Vérifiez les chemins dans l'inspecteur réseau

### JavaScript ne fonctionne pas

- Assurez-vous que tous les fichiers `.js` sont présents dans `wp-content/` et `wp-includes/js/`
- Vérifiez les erreurs de console dans le navigateur

## Optimisations Appliquées

✅ **Caching des assets** - Les fichiers CSS, JS, images sont en cache pour 1 an
✅ **Compression GZIP** - Activation automatique sur Vercel
✅ **Réécriture d'URLs** - Les routes non trouvées redirection vers index.html
✅ **Headers de sécurité** - Configuration dans vercel.json

## Support

Pour plus d'informations:
- Documentation Vercel: https://vercel.com/docs
- Configuration statique: https://vercel.com/docs/frameworks/static-site-generation

---

Généré avec Simply Static le 15 janvier 2026
