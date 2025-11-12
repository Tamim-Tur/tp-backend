const express = require('express');
const { 
  createActivity, 
  getUserActivities, 
  getActivity, 
  updateActivity,
  deleteActivity, 
  getStats 
} = require('../controllers/activityController');
const { authMiddleware } = require('../middlewares/auth');
const { activityValidation } = require('../middlewares/validation');
const requestLogger = require('../middlewares/logger');

const router = express.Router();
router.use(authMiddleware);
router.use(requestLogger);
router.post('/', activityValidation, createActivity);
router.get('/', getUserActivities);
router.get('/stats', getStats);
router.get('/:id', getActivity);
router.put('/:id', activityValidation, updateActivity);
router.delete('/:id', deleteActivity);

module.exports = router;

