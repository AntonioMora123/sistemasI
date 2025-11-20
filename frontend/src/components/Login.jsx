import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    
    setTimeout(() => {
      const isAdmin = email.includes('admin');
      const userData = {
        id: 1,
        nombre: isAdmin ? 'Administrador' : 'Empleado',
        email: email,
        rol: isAdmin ? 1 : 2
      };

      login(userData);
      
      if (isAdmin) {
        navigate('/admin');
      } else {
        navigate('/employee');
      }
      
      setLoading(false);
    }, 1000);
  };

  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      fontFamily: 'Arial, sans-serif'
    }}>
      <div style={{
        background: 'white',
        padding: '50px',
        borderRadius: '20px',
        boxShadow: '0 20px 40px rgba(0,0,0,0.15)',
        width: '400px'
      }}>
        <div style={{ textAlign: 'center', marginBottom: '40px' }}>
          <h1 style={{ color: '#333', fontSize: '2rem', marginBottom: '10px' }}>
            🍽️ Sistema de Restaurante
          </h1>
          <h2 style={{ color: '#666', fontSize: '1.2rem', fontWeight: 'normal' }}>
            Iniciar Sesión
          </h2>
        </div>

        <form onSubmit={handleSubmit}>
          <div style={{ marginBottom: '25px' }}>
            <label style={{ 
              display: 'block', 
              marginBottom: '8px', 
              fontWeight: 'bold',
              color: '#333'
            }}>
              Email:
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@test.com o empleado@test.com"
              style={{
                width: '100%',
                padding: '15px',
                border: '2px solid #e1e5e9',
                borderRadius: '10px',
                fontSize: '16px',
                boxSizing: 'border-box'
              }}
              required
            />
          </div>

          <div style={{ marginBottom: '30px' }}>
            <label style={{ 
              display: 'block', 
              marginBottom: '8px', 
              fontWeight: 'bold',
              color: '#333'
            }}>
              Contraseña:
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Cualquier contraseña"
              style={{
                width: '100%',
                padding: '15px',
                border: '2px solid #e1e5e9',
                borderRadius: '10px',
                fontSize: '16px',
                boxSizing: 'border-box'
              }}
              required
            />
          </div>

          <button 
            type="submit"
            disabled={loading}
            style={{
              width: '100%',
              padding: '15px',
              background: loading ? '#ccc' : 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
              color: 'white',
              border: 'none',
              borderRadius: '10px',
              fontSize: '18px',
              fontWeight: 'bold',
              cursor: loading ? 'not-allowed' : 'pointer',
              transition: 'all 0.3s ease'
            }}
          >
            {loading ? '🔄 Iniciando sesión...' : 'Iniciar Sesión'}
          </button>
        </form>

        <div style={{ 
          textAlign: 'center', 
          marginTop: '25px',
          padding: '15px',
          background: '#f8f9fa',
          borderRadius: '10px'
        }}>
          <p style={{ 
            margin: 0, 
            fontSize: '14px', 
            color: '#666',
            lineHeight: '1.5'
          }}>
            💡 <strong>Prueba:</strong><br/>
            📧 <code>admin@test.com</code> → Panel Administrador<br/>
            📧 <code>empleado@test.com</code> → Panel Empleado
          </p>
        </div>
      </div>
    </div>
  );
};

export default Login;