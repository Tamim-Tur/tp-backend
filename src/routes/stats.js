const express = require('express');
const { getGlobalStats, getUserActivitiesStats, getLeaderboard } = require('../controllers/statsController');
const { authMiddleware, adminMiddleware } = require('../middlewares/auth');
const requestLogger = require('../middlewares/logger');

const router = express.Router();

router.use(authMiddleware);
router.use(requestLogger);
router.get('/personal', getUserActivitiesStats);
router.get('/leaderboard', getLeaderboard);
router.get('/global', adminMiddleware, getGlobalStats);

module.exports = router;