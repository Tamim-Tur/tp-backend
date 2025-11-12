const express = require('express');
const { getUserProfile, updateUserProfile, getUsers, deleteUser } = require('../controllers/userController');
const { authMiddleware, adminMiddleware } = require('../middlewares/auth');
const requestLogger = require('../middlewares/logger');

const router = express.Router();

router.use(authMiddleware);
router.use(requestLogger);
router.get('/profile', getUserProfile);
router.put('/profile', updateUserProfile);
router.get('/', adminMiddleware, getUsers);
router.delete('/:id', adminMiddleware, deleteUser);

module.exports = router;