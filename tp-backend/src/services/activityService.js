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

  static async getUserStats(userId, period = 'all') {
    let dateFilter = '';
    const values = [userId];
    
    if (period !== 'all') {
      switch (period) {
        case 'week':
          dateFilter = "AND date >= NOW() - INTERVAL '7 days'";
          break;
        case 'month':
          dateFilter = "AND date >= NOW() - INTERVAL '30 days'";
          break;
        case 'year':
          dateFilter = "AND date >= NOW() - INTERVAL '365 days'";
          break;
      }
    }

    // Utiliser une requête optimisée avec agrégation SQL
    const statsQuery = `
      SELECT 
        COUNT(*) as total_activities,
        COALESCE(SUM(duration), 0) as total_duration,
        COALESCE(SUM(calories), 0) as total_calories,
        COALESCE(SUM(distance), 0) as total_distance,
        COALESCE(AVG(duration), 0) as avg_duration
      FROM activities 
      WHERE user_id = $1 ${dateFilter}
    `;

    const typeQuery = `
      SELECT 
        type,
        COUNT(*) as count,
        SUM(duration) as total_duration,
        SUM(calories) as total_calories,
        SUM(distance) as total_distance
      FROM activities 
      WHERE user_id = $1 ${dateFilter}
      GROUP BY type
      ORDER BY count DESC
    `;

    const { pgPool } = require('../config/database');
    const [statsResult, typeResult] = await Promise.all([
      pgPool.query(statsQuery, values),
      pgPool.query(typeQuery, values)
    ]);

    const stats = statsResult.rows[0];
    const activitiesByType = {};
    
    typeResult.rows.forEach(row => {
      activitiesByType[row.type] = {
        count: parseInt(row.count),
        totalDuration: parseInt(row.total_duration) || 0,
        totalCalories: parseInt(row.total_calories) || 0,
        totalDistance: parseFloat(row.total_distance) || 0
      };
    });

    return {
      period,
      totalActivities: parseInt(stats.total_activities) || 0,
      totalDuration: parseInt(stats.total_duration) || 0,
      totalCalories: parseInt(stats.total_calories) || 0,
      totalDistance: parseFloat(stats.total_distance) || 0,
      avgDuration: parseFloat(stats.avg_duration) || 0,
      activitiesByType
    };
  }
}

module.exports = ActivityService;