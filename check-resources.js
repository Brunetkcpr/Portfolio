#!/usr/bin/env node

/**
 * Script de vérification et correction des chemins WordPress statiques
 * Valide que tous les fichiers CSS/JS référencés existent réellement
 */

const fs = require('fs');
const path = require('path');

const COLORS = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
};

function log(message, color = 'reset') {
  console.log(`${COLORS[color]}${message}${COLORS.reset}`);
}

function checkFile(filePath) {
  const fullPath = path.join(__dirname, filePath);
  const exists = fs.existsSync(fullPath);
  
  if (exists) {
    log(`✓ ${filePath}`, 'green');
  } else {
    log(`✗ MANQUANT: ${filePath}`, 'red');
  }
  
  return exists;
}

function extractResourcePaths(htmlContent) {
  const paths = {
    css: [],
    js: [],
    images: [],
  };
  
  // Extraire les fichiers CSS
  const cssRegex = /href="([^"]*\.css[^"]*)"/g;
  let match;
  while ((match = cssRegex.exec(htmlContent)) !== null) {
    if (!match[1].startsWith('http')) {
      paths.css.push(match[1]);
    }
  }
  
  // Extraire les fichiers JS
  const jsRegex = /src="([^"]*\.js[^"]*)"/g;
  while ((match = jsRegex.exec(htmlContent)) !== null) {
    if (!match[1].startsWith('http')) {
      paths.js.push(match[1]);
    }
  }
  
  // Extraire les images
  const imgRegex = /src="([^"]*\.(?:png|jpg|jpeg|gif|svg|webp)[^"]*)"/g;
  while ((match = imgRegex.exec(htmlContent)) !== null) {
    if (!match[1].startsWith('http') && !match[1].startsWith('data:')) {
      paths.images.push(match[1]);
    }
  }
  
  return paths;
}

async function main() {
  log('\n=== Vérification des ressources WordPress statiques ===\n', 'blue');
  
  const htmlPath = path.join(__dirname, 'index.html');
  
  if (!fs.existsSync(htmlPath)) {
    log('❌ index.html non trouvé!', 'red');
    process.exit(1);
  }
  
  const htmlContent = fs.readFileSync(htmlPath, 'utf-8');
  const resources = extractResourcePaths(htmlContent);
  
  let totalFiles = 0;
  let missingFiles = 0;
  
  log('📋 Fichiers CSS:', 'yellow');
  resources.css.forEach(file => {
    totalFiles++;
    if (!checkFile(file)) missingFiles++;
  });
  
  log('\n📋 Fichiers JavaScript:', 'yellow');
  resources.js.forEach(file => {
    totalFiles++;
    if (!checkFile(file)) missingFiles++;
  });
  
  log('\n📋 Fichiers Image:', 'yellow');
  resources.images.slice(0, 10).forEach(file => {
    totalFiles++;
    if (!checkFile(file)) missingFiles++;
  });
  if (resources.images.length > 10) {
    log(`... et ${resources.images.length - 10} autres images`, 'blue');
  }
  
  log(`\n📊 Résumé: ${totalFiles} fichiers vérifiés, ${missingFiles} manquants\n`, 'blue');
  
  if (missingFiles === 0) {
    log('✅ Tous les fichiers sont présents!', 'green');
  } else {
    log('⚠️ Attention: Certains fichiers manquent. Vérifiez la structure du projet.', 'yellow');
  }
}

main().catch(error => {
  log(`Erreur: ${error.message}`, 'red');
  process.exit(1);
});
