const mysql = require('mysql2/promise');

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'user',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_NAME || 'restaurante',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

const pool = mysql.createPool(dbConfig);

const testConnection = async () => {
  try {
    const connection = await pool.getConnection();
    console.log(' Conexión exitosa a MySQL');
    connection.release();
  } catch (error) {
    console.error(' Error conectando a la base de datos:', error.message);
  }
};

module.exports = {
  pool,
  testConnection
};