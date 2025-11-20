const express = require('express');
const authRoutes = require('./authRoutes');

const router = express.Router();

router.use('/auth', authRoutes);

router.get('/', (req, res) => {
  res.json({
    message: '🍽️ API del Sistema de Restaurante',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      login: '/api/auth/login',
      register: '/api/auth/register',
      profile: '/api/auth/profile'
    }
  });
});

module.exports = router;