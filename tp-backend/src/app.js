const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger');
require('dotenv').config();

const app = express();

app.use(helmet());
const allowedOrigins = process.env.FRONTEND_URL 
  ? [process.env.FRONTEND_URL]
  : ['http://localhost:3000', 'http://localhost:5173', 'http://localhost:5174'];

app.use(cors({
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(null, true); // En développement, accepter toutes les origines
    }
  },
  credentials: true
}));

// Rate limiting général (plus permissif en développement)
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: process.env.NODE_ENV === 'production' ? 100 : 1000, // Plus permissif en dev
  message: 'Trop de requêtes, veuillez réessayer plus tard.',
  standardHeaders: true,
  legacyHeaders: false,
});

// Rate limiting spécifique pour l'authentification (plus permissif)
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: process.env.NODE_ENV === 'production' ? 5 : 50, // 5 tentatives en prod, 50 en dev
  message: 'Trop de tentatives de connexion, veuillez réessayer dans 15 minutes.',
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true, // Ne pas compter les requêtes réussies
});

app.use(express.json());

// Appliquer le rate limiting général à toutes les routes sauf auth
app.use((req, res, next) => {
  if (req.path.startsWith('/api/auth')) {
    return next(); // Skip pour les routes auth
  }
  limiter(req, res, next);
});

// Appliquer le rate limiting spécifique aux routes auth
app.use('/api/auth', authLimiter);

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.use('/api/auth', require('./routes/auth'));
app.use('/api/users', require('./routes/users'));
app.use('/api/activities', require('./routes/activites'));
app.use('/api/goals', require('./routes/goals'));

app.use((err, req, res, next) => {
  console.error('=== ERREUR SERVEUR ===');
  console.error('Message:', err.message);
  console.error('Stack:', err.stack);
  console.error('URL:', req.originalUrl);
  console.error('Method:', req.method);
  console.error('Body:', req.body);
  console.error('========================');
  res.status(500).json({ 
    message: 'Erreur serveur', 
    error: process.env.NODE_ENV === 'production' ? {} : {
      message: err.message,
      stack: err.stack
    }
  });
});

app.use('*', (req, res) => {
  res.status(404).json({ message: 'Route non trouvée' });
});




module.exports = app;