const express = require('express');
const { register, login, refresh } = require('../controllers/authController');
const { registerValidation } = require('../middlewares/validation');
const requestLogger = require('../middlewares/logger');

const router = express.Router();
router.use(requestLogger); // Logger pour toutes les routes auth
router.post('/register', registerValidation, register);
router.post('/login', login);
router.post('/refresh', refresh);

module.exports = router;