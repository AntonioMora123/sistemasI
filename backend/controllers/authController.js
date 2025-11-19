const bcrypt = require('bcrypt');
const db = require('../config/database');
const { generateToken } = require('../config/jwt');

const authController = {
  // Login
  login: async (req, res) => {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Email y contraseña son requeridos'
        });
      }

      // Buscar usuario y obtener su rol principal
      const query = `
        SELECT u.idUsuario, u.nombres, u.apellidos, u.email, u.password, u.activo,
               ur.idRol, r.nombreRol
        FROM usuarios u
        LEFT JOIN usuarios_roles ur ON u.idUsuario = ur.idUsuario
        LEFT JOIN roles r ON ur.idRol = r.idRol
        WHERE u.email = ? AND u.activo = 1
        ORDER BY ur.idRol ASC
        LIMIT 1
      `;

      const [users] = await db.execute(query, [email]);

      if (users.length === 0) {
        return res.status(401).json({
          success: false,
          message: 'Credenciales inválidas'
        });
      }

      const user = users[0];

      // Verificar contraseña
      const isValidPassword = await bcrypt.compare(password, user.password);
      if (!isValidPassword) {
        return res.status(401).json({
          success: false,
          message: 'Credenciales inválidas'
        });
      }

      // Generar token
      const tokenPayload = {
        userId: user.idUsuario,
        email: user.email,
        roleId: user.idRol || 2, // Por defecto empleado si no tiene rol
        roleName: user.nombreRol || 'Empleado'
      };

      const token = generateToken(tokenPayload);

      // Determinar ruta de redirección
      let redirectPath = '/employee';
      if (user.idRol === 1) {
        redirectPath = '/admin';
      }

      res.json({
        success: true,
        message: 'Login exitoso',
        token,
        user: {
          id: user.idUsuario,
          nombres: user.nombres,
          apellidos: user.apellidos,
          email: user.email,
          roleId: user.idRol || 2,
          roleName: user.nombreRol || 'Empleado'
        },
        redirectPath
      });

    } catch (error) {
      console.error('Error en login:', error);
      res.status(500).json({
        success: false,
        message: 'Error interno del servidor'
      });
    }
  },

  // Registro de empleado
  register: async (req, res) => {
    try {
      const {
        nombres, apellidos, email, telefono, password,
        fechaNacimiento, direccion, genero, estadoCivil,
        curp, puesto, salario
      } = req.body;

      // Validaciones básicas
      if (!nombres || !apellidos || !email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Campos obligatorios faltantes'
        });
      }

      // Verificar si el email ya existe
      const [existingUsers] = await db.execute(
        'SELECT idUsuario FROM usuarios WHERE email = ?',
        [email]
      );

      if (existingUsers.length > 0) {
        return res.status(409).json({
          success: false,
          message: 'El email ya está registrado'
        });
      }

      // Hash de la contraseña
      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash(password, saltRounds);

      // Llamar al procedimiento almacenado para agregar empleado
      await db.execute('CALL agregar_empleado(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [
        nombres,
        apellidos,
        email,
        telefono || null,
        hashedPassword,
        fechaNacimiento || null,
        direccion || null,
        genero || 'M',
        estadoCivil || 'Soltero',
        curp || null,
        puesto || 'Empleado',
        salario || 8000.00
      ]);

      // Obtener el ID del usuario recién creado
      const [newUsers] = await db.execute(
        'SELECT idUsuario FROM usuarios WHERE email = ?',
        [email]
      );

      const newUserId = newUsers[0].idUsuario;

      // Asignar rol de empleado (ID 2)
      await db.execute('CALL asignar_rol(?, ?)', [newUserId, 2]);

      res.status(201).json({
        success: true,
        message: 'Usuario registrado exitosamente',
        userId: newUserId
      });

    } catch (error) {
      console.error('Error en registro:', error);
      res.status(500).json({
        success: false,
        message: 'Error interno del servidor'
      });
    }
  },

  // Verificar token
  verifyToken: async (req, res) => {
    res.json({
      success: true,
      user: req.user
    });
  },

  // Logout (lado cliente)
  logout: (req, res) => {
    res.json({
      success: true,
      message: 'Logout exitoso'
    });
  }
};

module.exports = authController;