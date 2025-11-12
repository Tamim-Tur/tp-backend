import { useState, useEffect } from 'react';
import api from '../services/api';

function Users() {
  const [users, setUsers] = useState([]);
  const [pagination, setPagination] = useState({ page: 1, limit: 10, total: 0 });
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    loadUsers();
  }, [pagination.page, search]);

  const loadUsers = async () => {
    setLoading(true);
    setError('');
    try {
      const data = await api.getUsers(pagination.page, pagination.limit, search);
      setUsers(data.users);
      setPagination(data.pagination);
    } catch (err) {
      setError(err.message || 'Erreur lors du chargement des utilisateurs');
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = (e) => {
    e.preventDefault();
    setPagination({ ...pagination, page: 1 });
    loadUsers();
  };

  const handleDelete = async (userId) => {
    if (!window.confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) {
      return;
    }

    try {
      await api.deleteUser(userId);
      loadUsers();
    } catch (err) {
      setError(err.message || 'Erreur lors de la suppression');
    }
  };

  return (
    <div className="users-container">
      <h2>Gestion des Utilisateurs (Admin)</h2>

      <form onSubmit={handleSearch} className="search-form">
        <input
          type="text"
          placeholder="Rechercher par email..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
        <button type="submit">Rechercher</button>
        {search && (
          <button type="button" onClick={() => {
            setSearch('');
            setPagination({ ...pagination, page: 1 });
          }}>
            Effacer
          </button>
        )}
      </form>

      {error && <div className="error">{error}</div>}

      {loading ? (
        <div>Chargement...</div>
      ) : (
        <>
          <div className="users-list">
            {users.length === 0 ? (
              <p>Aucun utilisateur trouvé</p>
            ) : (
              users.map((user) => (
                <div key={user.id} className="user-card">
                  <div className="user-info">
                    <p><strong>Email:</strong> {user.email}</p>
                    <p><strong>Rôle:</strong> {user.role}</p>
                    {user.created_at && (
                      <p><strong>Créé le:</strong> {new Date(user.created_at).toLocaleDateString('fr-FR')}</p>
                    )}
                  </div>
                  <button
                    onClick={() => handleDelete(user.id)}
                    className="delete-btn"
                  >
                    Supprimer
                  </button>
                </div>
              ))
            )}
          </div>

          {pagination.pages > 1 && (
            <div className="pagination">
              <button
                onClick={() => setPagination({ ...pagination, page: pagination.page - 1 })}
                disabled={pagination.page === 1}
              >
                Précédent
              </button>
              <span>
                Page {pagination.page} sur {pagination.pages}
              </span>
              <button
                onClick={() => setPagination({ ...pagination, page: pagination.page + 1 })}
                disabled={pagination.page >= pagination.pages}
              >
                Suivant
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}

export default Users;

