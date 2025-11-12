import { useState, useEffect } from 'react';
import Login from './components/Login';
import Register from './components/Register';
import Profile from './components/Profile';
import Activities from './components/Activities';
import Dashboard from './components/Dashboard';
import Users from './components/Users';
import api from './services/api';
import './App.css';

function App() {
  const [user, setUser] = useState(null);
  const [currentView, setCurrentView] = useState('login');
  const [showRegister, setShowRegister] = useState(false);

  useEffect(() => {
    // Vérifier si l'utilisateur est déjà connecté
    if (api.token) {
      checkAuth();
    }
  }, []);

  const checkAuth = async () => {
    try {
      const profile = await api.getProfile();
      setUser(profile);
      setCurrentView('activities');
    } catch (err) {
      api.setToken(null);
      setCurrentView('login');
    }
  };

  const handleLogin = (data) => {
    setUser(data.user);
    setCurrentView('dashboard');
  };

  const handleLogout = () => {
    setUser(null);
    setCurrentView('login');
  };

  const handleRegister = () => {
    setShowRegister(true);
  };

  return (
    <div className="app">
      <header className="app-header">
        <div className="header-content">
          <h1>🏃 Sport App</h1>
          {user && (
            <nav className="nav-menu">
              <button
                onClick={() => setCurrentView('dashboard')}
                className={currentView === 'dashboard' ? 'active' : ''}
              >
                📊 Tableau de bord
              </button>
              <button
                onClick={() => setCurrentView('activities')}
                className={currentView === 'activities' ? 'active' : ''}
              >
                🏋️ Activités
              </button>
              <button
                onClick={() => setCurrentView('profile')}
                className={currentView === 'profile' ? 'active' : ''}
              >
                👤 Profil
              </button>
              {user.role === 'admin' && (
                <button
                  onClick={() => setCurrentView('users')}
                  className={currentView === 'users' ? 'active' : ''}
                >
                  👥 Utilisateurs
                </button>
              )}
            </nav>
          )}
        </div>
      </header>

      <main className="app-main">
        {!user ? (
          <div className="auth-section">
            {!showRegister ? (
              <>
                <Login onLogin={handleLogin} />
                <p className="auth-switch">
                  Pas encore de compte ?{' '}
                  <button onClick={handleRegister} className="link-btn">
                    S'inscrire
                  </button>
                </p>
              </>
            ) : (
              <>
                <Register onRegister={() => setShowRegister(false)} />
                <p className="auth-switch">
                  Déjà un compte ?{' '}
                  <button onClick={() => setShowRegister(false)} className="link-btn">
                    Se connecter
                  </button>
                </p>
              </>
            )}
          </div>
        ) : (
          <>
            {currentView === 'dashboard' && <Dashboard />}
            {currentView === 'activities' && <Activities />}
            {currentView === 'profile' && <Profile onLogout={handleLogout} />}
            {currentView === 'users' && user.role === 'admin' && <Users />}
          </>
        )}
      </main>
    </div>
  );
}

export default App;
