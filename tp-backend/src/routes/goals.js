const express = require('express');
const {
  createGoal,
  getUserGoals,
  getGoal,
  updateGoal,
  deleteGoal,
  updateProgress
} = require('../controllers/goalController');
const { authMiddleware } = require('../middlewares/auth');
const requestLogger = require('../middlewares/logger');

const router = express.Router();
router.use(authMiddleware);
router.use(requestLogger);

router.post('/', createGoal);
router.get('/', getUserGoals);
router.get('/:id', getGoal);
router.put('/:id', updateGoal);
router.delete('/:id', deleteGoal);
router.post('/:id/progress', updateProgress);

module.exports = router;

