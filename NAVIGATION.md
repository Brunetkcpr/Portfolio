# 🔗 PROBLÈME DE NAVIGATION - EXPLICATIONS

## ❌ Le Problème

Votre site WordPress a **seulement 1 page HTML exportée** (`index.html`).

Quand vous essayez de naviguer vers d'autres pages, vous obtenez des erreurs 404 car:
- Les autres pages n'existent pas
- Les liens pointent vers des URLs qui ne sont pas statiques

## 🔍 Diagnostic

```
Fichiers HTML détectés:
✓ index.html       (page d'accueil)
✓ diagnostic.html  (outil diagnostic)
✓ guide.html       (guide de déploiement)
✓ 404.html         (page d'erreur)
✗ about.html       (MANQUANT)
✗ portfolio.html   (MANQUANT)
✗ services.html    (MANQUANT)
✗ contact.html     (MANQUANT)
```

## 💡 Causes Possibles

### 1. **Simply Static n'a pas exporté toutes les pages**
- Simply Static a peut-être ignoré certaines pages
- Vérifier dans WordPress: Simply Static → Settings → Pages à exporter

### 2. **Les pages n'existent pas dans WordPress**
- Vérifier si vous avez d'autres pages/posts
- Vérifier si elles sont publiées

### 3. **Les pages sont dynamiques**
- WordPress génère les pages à la demande
- Un site statique ne peut pas supporter ça

## ✅ Solutions

### Solution 1: Réexporter le Site Complet (Recommandé)

**Étapes:**
1. Aller dans WordPress admin
2. Plugins → Simply Static
3. Settings → Vérifier que toutes les pages sont cochées
4. "Generate Static Files"
5. Remplacer les fichiers dans le dossier `simply-static-1-XXXXX`
6. Redéployer sur Vercel

**Code exemple:**
```bash
# 1. Télécharger l'export Simply Static depuis WordPress
# 2. Extraire et copier les fichiers
cp -r ~/Downloads/simply-static/* ./

# 3. Committer
git add .
git commit -m "refactor: Re-export complete WordPress site with all pages"

# 4. Pousser
git push origin main

# 5. Vercel redéploiera automatiquement
```

### Solution 2: Site d'Une Seule Page

Si vous voulez seulement la page d'accueil:

**Corriger les liens dans `index.html`:**
```html
<!-- Avant -->
<a href="/about/">À propos</a>

<!-- Après -->
<a href="/#about">À propos (section locale)</a>
```

**Ou créer des redirections:**
```bash
# Ajouter dans vercel.json
"redirects": [
  {
    "source": "/about",
    "destination": "/",
    "permanent": false
  },
  {
    "source": "/services",
    "destination": "/",
    "permanent": false
  }
]
```

### Solution 3: Créer les Pages Manuellement

Créer des fichiers HTML pour chaque page:

```bash
# about.html
<!DOCTYPE html>
<html>
<head><title>À Propos</title></head>
<body>
  <h1>À Propos</h1>
  <p>Contenu de la page À Propos</p>
  <a href="/">Retour</a>
</body>
</html>
```

## 🔧 Fichier de Configuration Vercel

Pour supporter plusieurs pages, mettez à jour `vercel.json`:

```json
{
  "buildCommand": "npm run build",
  "installCommand": "npm install",
  "outputDirectory": ".",
  "headers": [
    {
      "source": "/wp-content/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    },
    {
      "source": "/wp-includes/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    }
  ],
  "redirects": [
    {
      "source": "/about",
      "destination": "/about.html"
    },
    {
      "source": "/portfolio",
      "destination": "/portfolio.html"
    },
    {
      "source": "/services",
      "destination": "/services.html"
    }
  ],
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

## 🎯 Recommandation

**Pour un site WordPress statique complet:**

1. **Étape 1:** Vérifier dans WordPress qu'il y a bien plusieurs pages/posts
2. **Étape 2:** Réexporter avec Simply Static en cochant toutes les pages
3. **Étape 3:** Remplacer les fichiers locaux
4. **Étape 4:** Committer et pousser: `git push origin main`
5. **Étape 5:** Vercel redéploiera automatiquement

## 📊 État Actuel

| Page | Status | Fichier |
|------|--------|---------|
| Accueil | ✓ OK | index.html |
| À propos | ✗ Manquant | about.html |
| Portfolio | ✗ Manquant | portfolio.html |
| Services | ✗ Manquant | services.html |
| Contact | ✗ Manquant | contact.html |
| 404 | ✓ OK | 404.html |

## 💡 Conseil

La meilleure approche est de **réexporter complètement le site WordPress** avec Simply Static.

Cela garantira que:
- Toutes les pages sont présentes
- Les assets sont correctement copiés
- Les liens sont cohérents
- Le site fonctionne correctement en statique

## 🔗 Ressources

- [Documentation Simply Static](https://wordpress.org/plugins/simply-static/)
- [Guide Vercel - Static Sites](https://vercel.com/docs/frameworks/static-site-generation)
- [Page 404.html créée](./404.html)

---

**Page créée**: 15 janvier 2026
**Status**: Site incomplet - Action requise
