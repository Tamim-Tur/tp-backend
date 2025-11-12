import { useState, useEffect } from 'react';
import api from '../services/api';

function Activities() {
  const [activities, setActivities] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    type: 'running',
    duration: '',
    calories: '',
    distance: '',
    notes: '',
  });

  useEffect(() => {
    loadActivities();
    loadStats();
  }, []);

  const loadActivities = async () => {
    setLoading(true);
    setError('');
    try {
      const data = await api.getActivities();
      setActivities(data);
    } catch (err) {
      setError(err.message || 'Erreur lors du chargement des activités');
    } finally {
      setLoading(false);
    }
  };

  const loadStats = async () => {
    try {
      const data = await api.getActivityStats();
      setStats(data);
    } catch (err) {
      console.error('Erreur stats:', err);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const activityData = {
        type: formData.type,
        duration: parseInt(formData.duration),
        calories: formData.calories ? parseInt(formData.calories) : undefined,
        distance: formData.distance ? parseFloat(formData.distance) : undefined,
        notes: formData.notes || undefined,
      };

      await api.createActivity(activityData);
      setShowForm(false);
      setFormData({
        type: 'running',
        duration: '',
        calories: '',
        distance: '',
        notes: '',
      });
      loadActivities();
      loadStats();
    } catch (err) {
      setError(err.message || 'Erreur lors de la création');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Êtes-vous sûr de vouloir supprimer cette activité ?')) {
      return;
    }

    try {
      await api.deleteActivity(id);
      loadActivities();
      loadStats();
    } catch (err) {
      setError(err.message || 'Erreur lors de la suppression');
    }
  };

  return (
    <div className="activities-container">
      <div className="header-section">
        <h2>Mes Activités</h2>
        <button onClick={() => setShowForm(!showForm)}>
          {showForm ? 'Annuler' : '+ Nouvelle activité'}
        </button>
      </div>

      {stats && (
        <div className="stats-section">
          <h3>Statistiques</h3>
          <div className="stats-grid">
            <div className="stat-card">
              <div className="stat-label">Total activités</div>
              <div className="stat-value">{stats.totalActivities}</div>
            </div>
            <div className="stat-card">
              <div className="stat-label">Durée totale</div>
              <div className="stat-value">{stats.totalDuration} min</div>
            </div>
            <div className="stat-card">
              <div className="stat-label">Calories brûlées</div>
              <div className="stat-value">{stats.totalCalories}</div>
            </div>
            <div className="stat-card">
              <div className="stat-label">Distance totale</div>
              <div className="stat-value">{stats.totalDistance} km</div>
            </div>
          </div>
        </div>
      )}

      {showForm && (
        <form onSubmit={handleSubmit} className="activity-form">
          <h3>Nouvelle activité</h3>
          <div className="form-group">
            <label>Type:</label>
            <select
              value={formData.type}
              onChange={(e) => setFormData({ ...formData, type: e.target.value })}
              required
            >
              <option value="running">Course</option>
              <option value="cycling">Vélo</option>
              <option value="swimming">Natation</option>
              <option value="walking">Marche</option>
              <option value="gym">Salle de sport</option>
            </select>
          </div>
          <div className="form-group">
            <label>Durée (minutes):</label>
            <input
              type="number"
              value={formData.duration}
              onChange={(e) => setFormData({ ...formData, duration: e.target.value })}
              required
              min="1"
            />
          </div>
          <div className="form-group">
            <label>Calories:</label>
            <input
              type="number"
              value={formData.calories}
              onChange={(e) => setFormData({ ...formData, calories: e.target.value })}
              min="0"
            />
          </div>
          <div className="form-group">
            <label>Distance (km):</label>
            <input
              type="number"
              step="0.1"
              value={formData.distance}
              onChange={(e) => setFormData({ ...formData, distance: e.target.value })}
              min="0"
            />
          </div>
          <div className="form-group">
            <label>Notes:</label>
            <textarea
              value={formData.notes}
              onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
              maxLength={500}
            />
          </div>
          {error && <div className="error">{error}</div>}
          <button type="submit" disabled={loading}>
            {loading ? 'Création...' : 'Créer'}
          </button>
        </form>
      )}

      {error && !showForm && <div className="error">{error}</div>}

      {loading && !showForm ? (
        <div>Chargement...</div>
      ) : (
        <div className="activities-list">
          {activities.length === 0 ? (
            <p>Aucune activité pour le moment</p>
          ) : (
            activities.map((activity) => (
              <div key={activity.id} className="activity-card">
                <div className="activity-header">
                  <h4>{activity.type}</h4>
                  <button
                    onClick={() => handleDelete(activity.id)}
                    className="delete-btn"
                  >
                    Supprimer
                  </button>
                </div>
                <div className="activity-details">
                  <p><strong>Durée:</strong> {activity.duration} minutes</p>
                  {activity.calories && (
                    <p><strong>Calories:</strong> {activity.calories}</p>
                  )}
                  {activity.distance && (
                    <p><strong>Distance:</strong> {activity.distance} km</p>
                  )}
                  {activity.notes && (
                    <p><strong>Notes:</strong> {activity.notes}</p>
                  )}
                  <p className="activity-date">
                    {new Date(activity.date || activity.created_at).toLocaleDateString('fr-FR')}
                  </p>
                </div>
              </div>
            ))
          )}
        </div>
      )}
    </div>
  );
}

export default Activities;

