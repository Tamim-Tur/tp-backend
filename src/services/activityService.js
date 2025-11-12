const Activity = require('../models/Activity');

class ActivityService {
  static async createActivity(activityData, userId) {
    return await Activity.create({
      ...activityData,
      userId
    });
  }

  static async getUserActivities(userId) {
    return await Activity.findByUserId(userId);
  }

  static async getActivityById(id, userId) {
    const activity = await Activity.findById(id);
    if (!activity) {
      throw new Error('Activité non trouvée');
    }
    if (activity.user_id !== userId) {
      throw new Error('Accès non autorisé');
    }
    return activity;
  }

  static async deleteActivity(id, userId) {
    const activity = await Activity.findById(id);
    if (!activity) {
      throw new Error('Activité non trouvée');
    }
    if (activity.user_id !== userId) {
      throw new Error('Accès non autorisé');
    }
    await Activity.delete(id, userId);
  }

  static async getUserStats(userId) {
    const activities = await Activity.findByUserId(userId);
    
    const totalDuration = activities.reduce((sum, activity) => sum + activity.duration, 0);
    const totalCalories = activities.reduce((sum, activity) => sum + activity.calories, 0);
    const totalDistance = activities.reduce((sum, activity) => sum + (activity.distance || 0), 0);
    
    const activitiesByType = activities.reduce((acc, activity) => {
      acc[activity.type] = (acc[activity.type] || 0) + 1;
      return acc;
    }, {});

    return {
      totalActivities: activities.length,
      totalDuration,
      totalCalories,
      totalDistance,
      activitiesByType
    };
  }
}

module.exports = ActivityService;