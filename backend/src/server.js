require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { testConnection } = require('../config/database');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Ruta de prueba
app.get('/', (req, res) => {
  res.json({ 
    message: '🚀 Servidor de restaurante funcionando correctamente',
    timestamp: new Date().toISOString()
  });
});

// Ruta de salud de la base de datos
app.get('/health/db', async (req, res) => {
  try {
    await testConnection();
    res.json({ status: 'success', message: 'Base de datos conectada' });
  } catch (error) {
    res.status(500).json({ status: 'error', message: 'Error de base de datos' });
  }
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🌐 Servidor corriendo en puerto ${PORT}`);
  testConnection();
});

module.exports = app;