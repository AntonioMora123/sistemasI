import React from 'react';
import { useAuth } from '../../context/AuthContext';
import Navbar from '../common/Navbar';
import '../../styles/Dashboard.css';

const AdminDashboard = () => {
  const { user } = useAuth();

  return (
    <div className="dashboard">
      <Navbar />
      
      <div className="dashboard-container">
        <div className="dashboard-header">
          <h1>🏢 Panel de Administración</h1>
          <p>Bienvenido, {user?.nombre}</p>
        </div>

        <div className="dashboard-grid">
          <div className="dashboard-card">
            <div className="card-icon">👥</div>
            <h3>Gestión de Usuarios</h3>
            <p>Administrar empleados y roles</p>
            <button className="btn-card">Gestionar</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">🍽️</div>
            <h3>Menú del Restaurante</h3>
            <p>Administrar platos y categorías</p>
            <button className="btn-card">Gestionar</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">📊</div>
            <h3>Reportes</h3>
            <p>Ver estadísticas y reportes</p>
            <button className="btn-card">Ver Reportes</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">💰</div>
            <h3>Facturación</h3>
            <p>Gestionar ventas y pagos</p>
            <button className="btn-card">Ver Ventas</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">⚙️</div>
            <h3>Configuración</h3>
            <p>Ajustes del sistema</p>
            <button className="btn-card">Configurar</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">🏪</div>
            <h3>Restaurante</h3>
            <p>Información del establecimiento</p>
            <button className="btn-card">Editar Info</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;