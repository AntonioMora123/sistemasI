import React from 'react';
import { useAuth } from '../../context/AuthContext';
import Navbar from '../common/Navbar';
import '../../styles/Dashboard.css';

const EmployeeDashboard = () => {
  const { user } = useAuth();

  return (
    <div className="dashboard">
      <Navbar />
      
      <div className="dashboard-container">
        <div className="dashboard-header">
          <h1>👨‍🍳 Panel de Empleado</h1>
          <p>Bienvenido, {user?.nombre}</p>
        </div>

        <div className="dashboard-grid">
          <div className="dashboard-card">
            <div className="card-icon">📝</div>
            <h3>Tomar Pedidos</h3>
            <p>Registrar nuevos pedidos</p>
            <button className="btn-card">Nuevo Pedido</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">🍽️</div>
            <h3>Pedidos Activos</h3>
            <p>Ver pedidos en proceso</p>
            <button className="btn-card">Ver Pedidos</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">💳</div>
            <h3>Procesar Pagos</h3>
            <p>Cobrar y procesar pagos</p>
            <button className="btn-card">Procesar</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">📋</div>
            <h3>Menú del Día</h3>
            <p>Ver platos disponibles</p>
            <button className="btn-card">Ver Menú</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">👤</div>
            <h3>Mi Perfil</h3>
            <p>Ver y editar información personal</p>
            <button className="btn-card">Ver Perfil</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">📈</div>
            <h3>Mis Ventas</h3>
            <p>Ver mis ventas del día</p>
            <button className="btn-card">Ver Ventas</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EmployeeDashboard;