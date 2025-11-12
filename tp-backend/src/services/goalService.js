const Goal = require('../models/Goal');
const Activity = require('../models/Activity');

class GoalService {
  static async createGoal(goalData, userId) {
    return await Goal.create({
      ...goalData,
      userId
    });
  }

  static async getUserGoals(userId, status = null) {
    return await Goal.findByUserId(userId, status);
  }

  static async getGoalById(id, userId) {
    const goal = await Goal.findById(id);
    if (!goal) {
      throw new Error('Objectif non trouvé');
    }
    if (goal.user_id !== userId) {
      throw new Error('Accès non autorisé');
    }
    return goal;
  }

  static async updateGoal(id, userId, updates) {
    const goal = await Goal.findById(id);
    if (!goal) {
      throw new Error('Objectif non trouvé');
    }
    if (goal.user_id !== userId) {
      throw new Error('Accès non autorisé');
    }
    return await Goal.update(id, userId, updates);
  }

  static async deleteGoal(id, userId) {
    const goal = await Goal.findById(id);
    if (!goal) {
      throw new Error('Objectif non trouvé');
    }
    if (goal.user_id !== userId) {
      throw new Error('Accès non autorisé');
    }
    await Goal.delete(id, userId);
  }

  static async updateGoalProgress(goalId, userId) {
    const goal = await Goal.findById(goalId);
    if (!goal || goal.user_id !== userId) {
      throw new Error('Objectif non trouvé');
    }

    // Calculer la progression basée sur les activités
    const activities = await Activity.findByUserId(userId);
    let currentValue = 0;

    const startDate = new Date(goal.start_date);
    const endDate = new Date(goal.end_date);
    
    const relevantActivities = activities.filter(activity => {
      const activityDate = new Date(activity.date || activity.created_at);
      return activityDate >= startDate && activityDate <= endDate;
    });

    switch (goal.type) {
      case 'duration':
        currentValue = relevantActivities.reduce((sum, act) => sum + (act.duration || 0), 0);
        break;
      case 'distance':
        currentValue = relevantActivities.reduce((sum, act) => sum + (act.distance || 0), 0);
        break;
      case 'calories':
        currentValue = relevantActivities.reduce((sum, act) => sum + (act.calories || 0), 0);
        break;
      case 'activities_count':
        currentValue = relevantActivities.length;
        break;
    }

    return await Goal.updateProgress(goalId, userId, currentValue);
  }
}

module.exports = GoalService;

