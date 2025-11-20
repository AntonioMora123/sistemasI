import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';

const Navbar = () => {
  const { user, logout, isAdmin } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <nav style={navStyles.navbar}>
      <div style={navStyles.container}>
        <div style={navStyles.brand}>
          <h2 style={navStyles.brandText}>🍽️ Restaurante</h2>
        </div>

        <div style={navStyles.userSection}>
          <div style={navStyles.userInfo}>
            <span style={navStyles.userName}>
              {user?.nombre}
            </span>
            <span style={navStyles.userRole}>
              {isAdmin() ? '👨‍💼 Administrador' : '👨‍🍳 Empleado'}
            </span>
          </div>
          
          <button 
            onClick={handleLogout}
            style={navStyles.logoutButton}
          >
            Cerrar Sesión
          </button>
        </div>
      </div>
    </nav>
  );
};

const navStyles = {
  navbar: {
    backgroundColor: '#2d3748',
    color: 'white',
    padding: '1rem 0',
    boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
  },
  container: {
    maxWidth: '1200px',
    margin: '0 auto',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '0 20px'
  },
  brand: {
    display: 'flex',
    alignItems: 'center'
  },
  brandText: {
    margin: 0,
    fontSize: '1.5rem',
    fontWeight: 'bold'
  },
  userSection: {
    display: 'flex',
    alignItems: 'center',
    gap: '20px'
  },
  userInfo: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'flex-end'
  },
  userName: {
    fontWeight: 'bold',
    fontSize: '1rem'
  },
  userRole: {
    fontSize: '0.9rem',
    color: '#cbd5e0',
    marginTop: '2px'
  },
  logoutButton: {
    backgroundColor: '#e53e3e',
    color: 'white',
    border: 'none',
    padding: '8px 16px',
    borderRadius: '6px',
    cursor: 'pointer',
    fontSize: '0.9rem',
    fontWeight: 'bold',
    transition: 'background-color 0.2s'
  }
};

export default Navbar;