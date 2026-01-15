#!/usr/bin/env node

/**
 * Script pour corriger les URLs WordPress dans les fichiers statiques
 * Nettoie les références à /index.php et autres URLs cassées
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

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

const replacements = [
  // Supprimer /index.php des URLs
  {
    regex: /\/index\.php\//g,
    replacement: '/',
    description: 'Suppression de /index.php des URLs'
  },
  {
    regex: /\/index\.php\?/g,
    replacement: '?',
    description: 'Suppression de /index.php des URLs avec paramètres'
  },
  // Corriger les URLs wp-admin
  {
    regex: /\/wp-admin\/admin-ajax\.php/g,
    replacement: '/api/ajax',
    description: 'Remplacement des URLs AJAX WordPress'
  },
  // Assurer que /wp-content/ est correct
  {
    regex: /href="wp-content\//g,
    replacement: 'href="/wp-content/',
    description: 'Correction des chemins CSS relatifs'
  },
  {
    regex: /src="wp-content\//g,
    replacement: 'src="/wp-content/',
    description: 'Correction des chemins JS relatifs'
  },
];

async function processFile(filePath) {
  try {
    let content = fs.readFileSync(filePath, 'utf-8');
    let modified = false;
    
    for (const replacement of replacements) {
      if (replacement.regex.test(content)) {
        content = content.replace(replacement.regex, replacement.replacement);
        modified = true;
        log(`  ✓ ${replacement.description}`, 'green');
      }
    }
    
    if (modified) {
      fs.writeFileSync(filePath, content, 'utf-8');
      return true;
    }
    return false;
  } catch (error) {
    log(`  ✗ Erreur: ${error.message}`, 'red');
    return false;
  }
}

async function findHtmlFiles(dir, fileList = []) {
  const files = fs.readdirSync(dir);
  
  for (const file of files) {
    const fullPath = path.join(dir, file);
    const stat = fs.statSync(fullPath);
    
    if (stat.isDirectory()) {
      // Ignorer certains dossiers
      if (!['.git', 'node_modules', '.vercel'].includes(file)) {
        await findHtmlFiles(fullPath, fileList);
      }
    } else if (file.endsWith('.html') || file.endsWith('.htm')) {
      fileList.push(fullPath);
    }
  }
  
  return fileList;
}

async function main() {
  log('\n=== Correction des URLs WordPress statiques ===\n', 'blue');
  
  const projectRoot = __dirname;
  const htmlFiles = await findHtmlFiles(projectRoot);
  
  if (htmlFiles.length === 0) {
    log('❌ Aucun fichier HTML trouvé!', 'red');
    process.exit(1);
  }
  
  log(`📝 ${htmlFiles.length} fichier(s) HTML trouvé(s)\n`, 'yellow');
  
  let filesModified = 0;
  
  for (const file of htmlFiles) {
    const relativePath = path.relative(projectRoot, file);
    log(`Traitement: ${relativePath}`, 'blue');
    
    if (await processFile(file)) {
      filesModified++;
    } else {
      log('  ✓ Aucune modification nécessaire', 'green');
    }
  }
  
  log(`\n✅ Opération terminée: ${filesModified} fichier(s) modifié(s)\n`, 'green');
}

main().catch(error => {
  log(`❌ Erreur: ${error.message}`, 'red');
  process.exit(1);
});
