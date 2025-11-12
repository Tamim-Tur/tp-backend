const { Pool } = require('pg');
const mongoose = require('mongoose');

// Configuration PostgreSQL avec pool optimisé
const pgPool = new Pool({
  user: process.env.PG_USER || 'postgres',
  host: process.env.PG_HOST || 'localhost',
  database: process.env.PG_DATABASE || 'sportapp',
  password: process.env.PG_PASSWORD || 'password',
  port: process.env.PG_PORT || 5432,
  max: 20, // Nombre maximum de clients dans le pool
  idleTimeoutMillis: 30000, // Fermer les clients inactifs après 30s
  connectionTimeoutMillis: 2000, // Timeout de connexion
});

// Gestion des erreurs du pool PostgreSQL
pgPool.on('error', (err) => {
  console.error('Erreur PostgreSQL pool:', err);
});

// Test de connexion PostgreSQL
const testPostgreSQL = async () => {
  try {
    const result = await pgPool.query('SELECT NOW()');
    console.log('✅ Connecté à PostgreSQL');
    return true;
  } catch (error) {
    console.error('❌ Erreur connexion PostgreSQL:', error.message);
    return false;
  }
};

// Configuration MongoDB optimisée
const connectMongoDB = async () => {
  try {
    const mongoOptions = {
      maxPoolSize: 10,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    };

    await mongoose.connect(
      process.env.MONGO_URI || 'mongodb://localhost:27017/sportapp',
      mongoOptions
    );
    console.log('✅ Connecté à MongoDB');
    return true;
  } catch (error) {
    console.error('❌ Erreur connexion MongoDB:', error.message);
    // Ne pas faire planter l'app si MongoDB n'est pas disponible
    if (process.env.NODE_ENV === 'production') {
      throw error;
    }
    return false;
  }
};

// Initialisation des connexions
const initializeDatabases = async () => {
  const pgConnected = await testPostgreSQL();
  const mongoConnected = await connectMongoDB();
  
  if (!pgConnected) {
    throw new Error('PostgreSQL est requis pour le fonctionnement de l\'application');
  }
  
  return { pgConnected, mongoConnected };
};

module.exports = { 
  pgPool, 
  connectMongoDB, 
  testPostgreSQL,
  initializeDatabases 
};