const express = require('express');
const { register, login, refresh } = require('../controllers/authController');
const { registerValidation } = require('../middlewares/validation');

const router = express.Router();
router.post('/register', registerValidation, register);
router.post('/login', login);
router.post('/refresh', refresh);

module.exports = router;