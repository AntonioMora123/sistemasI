const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;

console.log('🚀 Iniciando servidor Express...');

// Middleware básico
app.use(express.json());

// Ruta de prueba
app.get('/', (req, res) => {
  console.log('✅ Solicitud recibida en /');
  res.json({
    message: 'Backend funcionando correctamente',
    timestamp: new Date().toISOString(),
    port: PORT
  });
});

// Ruta de salud
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date() });
});

// Iniciar servidor
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🌐 Servidor corriendo en puerto ${PORT}`);
  console.log(`📍 Accesible en: http://localhost:${PORT}`);
});

// Manejo de errores
process.on('uncaughtException', (err) => {
  console.error('💥 Error no capturado:', err);
  process.exit(1);
});

process.on('unhandledRejection', (err) => {
  console.error('💥 Promesa rechazada:', err);
  process.exit(1);
});