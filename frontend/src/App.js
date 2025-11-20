import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import ProtectedRoute from './components/common/ProtectedRoute';
import Login from './components/Login';
import Register from './components/auth/Register';
import AdminDashboard from './components/dashboards/AdminDashboard';
import EmployeeDashboard from './components/dashboards/EmployeeDashboard';
import './App.css';

/*
function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="App">
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            
            <Route 
              path="/admin" 
              element={
                <ProtectedRoute requiredRole={1}>
                  <AdminDashboard />
                </ProtectedRoute>
              } 
            />
            
            <Route 
              path="/employee" 
              element={
                <ProtectedRoute requiredRole={2}>
                  <EmployeeDashboard />
                </ProtectedRoute>
              } 
            />
            
            <Route path="/" element={<Navigate to="/login" replace />} />
          </Routes>
        </div>
      </Router>
    </AuthProvider>
  );
}*/

function App() {
  return (
    <div>
      <h1>🍽️ Sistema de Restaurante</h1>
      <p>¡Funcionando correctamente!</p>
    </div>
  );
}
export default App;