# 👑 Comment créer un utilisateur Admin

## Méthode 1 : Via la base de données PostgreSQL

1. Connectez-vous à votre base de données PostgreSQL :
   ```bash
   psql -U votre_utilisateur -d votre_base_de_donnees
   ```

2. Mettez à jour le rôle d'un utilisateur existant :
   ```sql
   UPDATE users SET role = 'admin' WHERE email = 'votre-email@example.com';
   ```

3. Ou créez directement un utilisateur admin (nécessite de hasher le mot de passe) :
   ```sql
   -- Note: Vous devez d'abord hasher le mot de passe avec bcrypt
   -- Utilisez plutôt la méthode 2 ou 3
   ```

## Méthode 2 : Via l'API (si vous avez déjà un admin)

Si vous avez déjà un compte admin, vous pouvez modifier un utilisateur via l'API.

## Méthode 3 : Script Node.js (Recommandé)

Créez un fichier `create-admin.js` dans le dossier `tp-backend` :

```javascript
const bcrypt = require('bcryptjs');
const { pgPool } = require('./src/config/database');

async function createAdmin() {
  const email = process.argv[2];
  const password = process.argv[3];

  if (!email || !password) {
    console.log('Usage: node create-admin.js <email> <password>');
    process.exit(1);
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 12);
    
    const result = await pgPool.query(
      'INSERT INTO users (email, password, role) VALUES ($1, $2, $3) RETURNING id, email, role',
      [email, hashedPassword, 'admin']
    );

    console.log('✅ Admin créé avec succès:');
    console.log(result.rows[0]);
    
    await pgPool.end();
    process.exit(0);
  } catch (error) {
    if (error.code === '23505') {
      console.error('❌ Cet email existe déjà');
    } else {
      console.error('❌ Erreur:', error.message);
    }
    await pgPool.end();
    process.exit(1);
  }
}

createAdmin();
```

Puis exécutez :
```bash
cd tp-backend/tp-backend
node create-admin.js admin@example.com motdepasse123
```

## Vérification

Une fois l'admin créé, connectez-vous avec cet email. Vous devriez voir :
- Un bouton "👥 Utilisateurs" dans le menu de navigation
- La page de gestion des utilisateurs avec tous les emails des comptes

