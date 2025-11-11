const { Pool } = require('pg');

const pgPool = new Pool({
  user: process.env.PG_USER || 'postgres',
  host: process.env.PG_HOST || 'localhost',
  database: process.env.PG_DATABASE || 'sportapp',
  password: process.env.PG_PASSWORD || 'password',
  port: process.env.PG_PORT || 5432,
});

const mongoose = require('mongoose');

const connectMongoDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/sportapp');
    console.log(' Connecté à MongoDB');
  } catch (error) {
    console.error(' Erreur connexion MongoDB:', error);
    process.exit(1);
  }
};

module.exports = { pgPool, connectMongoDB };