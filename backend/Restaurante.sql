CREATE DATABASE restaurante;
USE restaurante;


-- =====================
-- TABLA: USUARIOS
-- =====================
CREATE TABLE usuarios (
  idUsuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100),
  correo VARCHAR(150) UNIQUE NOT NULL,
  telefono VARCHAR(20),
  password_hash VARCHAR(255) NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  fecha_nacimiento DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =====================
-- TABLA: EMPLEADOS
-- =====================
CREATE TABLE empleados (
  idEmpleado INT AUTO_INCREMENT PRIMARY KEY,
  idUsuario INT NOT NULL,
  domicilio VARCHAR(255),
  sexo ENUM('M','F','Otro'),
  estado_civil VARCHAR(50),
  curp VARCHAR(18),
  puesto VARCHAR(100),
  salario DECIMAL(10,2),
  FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
) ENGINE=InnoDB;

-- =====================
-- TABLAS DE ROLES
-- =====================
CREATE TABLE roles (
  idRol INT AUTO_INCREMENT PRIMARY KEY,
  nombre_rol VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE usuarios_roles (
  idUsuarioRol INT AUTO_INCREMENT PRIMARY KEY,
  idUsuario INT NOT NULL,
  idRol INT NOT NULL,
  rol_activo BOOLEAN DEFAULT TRUE,
  fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario),
  FOREIGN KEY (idRol) REFERENCES roles(idRol)
) ENGINE=InnoDB;

-- =====================
-- TABLA: PROVEEDORES
-- =====================
CREATE TABLE proveedores (
  idProveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  direccion VARCHAR(255),
  correo VARCHAR(100),
  telefono VARCHAR(20),
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  estatus ENUM('Activo','Inactivo') DEFAULT 'Activo'
) ENGINE=InnoDB;

-- =====================
-- TABLA: PRODUCTOS EN ALMACÉN
-- =====================
CREATE TABLE productos_almacen (
  idProductoAlmacen INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  unidad_medida VARCHAR(20),
  fecha_caducidad DATE,
  precio_unitario DECIMAL(10,2),
  estado ENUM('Activo','Inactivo') DEFAULT 'Activo',
  idProveedor INT,
  FOREIGN KEY (idProveedor) REFERENCES proveedores(idProveedor)
) ENGINE=InnoDB;

-- =====================
-- TABLA: INGREDIENTES
-- =====================
CREATE TABLE ingredientes (
  idIngrediente INT AUTO_INCREMENT PRIMARY KEY,
  idProductoAlmacen INT NOT NULL,
  FOREIGN KEY (idProductoAlmacen) REFERENCES productos_almacen(idProductoAlmacen)
) ENGINE=InnoDB;

-- =====================
-- TABLA: RECETAS
-- =====================
CREATE TABLE recetas (
  idReceta INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- RELACIÓN N:N ENTRE RECETAS E INGREDIENTES
CREATE TABLE recetas_ingredientes (
  idReceta INT,
  idIngrediente INT,
  cantidad DOUBLE NOT NULL,
  PRIMARY KEY (idReceta, idIngrediente),
  FOREIGN KEY (idReceta) REFERENCES recetas(idReceta),
  FOREIGN KEY (idIngrediente) REFERENCES ingredientes(idIngrediente)
) ENGINE=InnoDB;

-- =====================
-- TABLA: MOVIMIENTOS DE INVENTARIO
-- =====================
CREATE TABLE movimientos_inventario (
  idMovimiento INT AUTO_INCREMENT PRIMARY KEY,
  idProductoAlmacen INT NOT NULL,
  tipo_movimiento ENUM('Entrada','Salida','Merma','Ajuste') NOT NULL,
  cantidad DOUBLE NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  idUsuario INT,
  FOREIGN KEY (idProductoAlmacen) REFERENCES productos_almacen(idProductoAlmacen),
  FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
) ENGINE=InnoDB;

-- =====================
-- TABLAS DE ÓRDENES DE COMPRA
-- =====================
CREATE TABLE orden_compra (
  idOrden INT AUTO_INCREMENT PRIMARY KEY,
  idProveedor INT NOT NULL,
  fechaOrden DATE NOT NULL,
  total DECIMAL(10,2),
  estado ENUM('Pendiente','Recibido','Cancelado') DEFAULT 'Pendiente',
  FOREIGN KEY (idProveedor) REFERENCES proveedores(idProveedor)
) ENGINE=InnoDB;

CREATE TABLE orden_detalle (
  idDetalle INT AUTO_INCREMENT PRIMARY KEY,
  idOrden INT NOT NULL,
  idProductoAlmacen INT NOT NULL,
  cantidad DOUBLE NOT NULL,
  precio_unitario DECIMAL(10,2),
  FOREIGN KEY (idOrden) REFERENCES orden_compra(idOrden),
  FOREIGN KEY (idProductoAlmacen) REFERENCES productos_almacen(idProductoAlmacen)
) ENGINE=InnoDB;

-- =====================
-- TABLAS DE VENTAS
-- =====================
CREATE TABLE ventas (
  idVenta INT AUTO_INCREMENT PRIMARY KEY,
  idUsuario INT NOT NULL,
  fechaVenta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2),
  iva DECIMAL(10,2),
  ieps DECIMAL(10,2),
  metodo_pago ENUM('Efectivo','Tarjeta','Transferencia'),
  FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
) ENGINE=InnoDB;

CREATE TABLE detalle_venta (
  idDetalleVenta INT AUTO_INCREMENT PRIMARY KEY,
  idVenta INT NOT NULL,
  idReceta INT NOT NULL,
  cantidad INT NOT NULL,
  subtotal DECIMAL(10,2),
  FOREIGN KEY (idVenta) REFERENCES ventas(idVenta),
  FOREIGN KEY (idReceta) REFERENCES recetas(idReceta)
) ENGINE=InnoDB;

-- =====================
-- TABLA: CIERRE DE CAJA / FINANZAS
-- =====================
CREATE TABLE cierre_caja (
  idCierre INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  total_efectivo DECIMAL(10,2),
  total_tarjeta DECIMAL(10,2),
  total_general DECIMAL(10,2),
  idUsuarioCierre INT,
  FOREIGN KEY (idUsuarioCierre) REFERENCES usuarios(idUsuario)
) ENGINE=InnoDB;

-- =====================
-- TABLA: NOTIFICACIONES
-- =====================
CREATE TABLE notificaciones (
  idNotificacion INT AUTO_INCREMENT PRIMARY KEY,
  idUsuario INT,
  titulo VARCHAR(150),
  mensaje TEXT,
  tipo ENUM('Sistema','Inventario','General'),
  leido BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
) ENGINE=InnoDB;

ALTER TABLE empleados ADD activo BOOLEAN DEFAULT TRUE;
ALTER TABLE roles ADD activo BOOLEAN DEFAULT TRUE;
ALTER TABLE ingredientes ADD activo BOOLEAN DEFAULT TRUE;
ALTER TABLE recetas ADD activo BOOLEAN DEFAULT TRUE;
ALTER TABLE productos_almacen ADD stock DOUBLE DEFAULT 0;





—-------------------------------------------------------------------------------------------------------------------









USE restaurante;

-- BORRAR procedimientos previos (opcional pero recomendable)
DROP PROCEDURE IF EXISTS agregar_empleado;
DROP PROCEDURE IF EXISTS agregar_administrador;
DROP PROCEDURE IF EXISTS editar_empleado;
DROP PROCEDURE IF EXISTS editar_administrador;
DROP PROCEDURE IF EXISTS desactivar_usuario;
DROP PROCEDURE IF EXISTS activar_usuario;
DROP PROCEDURE IF EXISTS agregar_proveedor;
DROP PROCEDURE IF EXISTS editar_proveedor;
DROP PROCEDURE IF EXISTS eliminar_proveedor;
DROP PROCEDURE IF EXISTS obtener_proveedores;
DROP PROCEDURE IF EXISTS agregar_producto_almacen;
DROP PROCEDURE IF EXISTS editar_producto_almacen;
DROP PROCEDURE IF EXISTS desactivar_producto_almacen;
DROP PROCEDURE IF EXISTS agregar_ingrediente;
DROP PROCEDURE IF EXISTS editar_ingrediente;
DROP PROCEDURE IF EXISTS desactivar_ingrediente;
DROP PROCEDURE IF EXISTS agregar_receta;
DROP PROCEDURE IF EXISTS editar_receta;
DROP PROCEDURE IF EXISTS desactivar_receta;
DROP PROCEDURE IF EXISTS agregar_ingrediente_a_receta;
DROP PROCEDURE IF EXISTS editar_ingrediente_en_receta;
DROP PROCEDURE IF EXISTS eliminar_ingrediente_de_receta;
DROP PROCEDURE IF EXISTS agregar_rol;
DROP PROCEDURE IF EXISTS editar_rol;
DROP PROCEDURE IF EXISTS desactivar_rol;
DROP PROCEDURE IF EXISTS asignar_rol;
DROP PROCEDURE IF EXISTS remover_rol;
DROP PROCEDURE IF EXISTS agregar_movimiento_inventario;
DROP PROCEDURE IF EXISTS obtener_stock_producto;
DROP PROCEDURE IF EXISTS crear_orden_compra;
DROP PROCEDURE IF EXISTS agregar_detalle_orden;
DROP PROCEDURE IF EXISTS crear_venta;
DROP PROCEDURE IF EXISTS agregar_detalle_venta;
DROP PROCEDURE IF EXISTS crear_cierre_caja;
DROP PROCEDURE IF EXISTS crear_notificacion;
DROP PROCEDURE IF EXISTS marcar_notificacion_leida;

DELIMITER $$

/*
  USUARIOS / EMPLEADOS
  - Parámetros ENUM -> VARCHAR y validación interna
  - Soft delete (activo = FALSE) para usuarios/empleados
*/

CREATE PROCEDURE agregar_empleado (
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_correo VARCHAR(150),
    IN p_telefono VARCHAR(20),
    IN p_password_hash VARCHAR(255),
    IN p_fecha_nacimiento DATE,
    IN p_domicilio VARCHAR(255),
    IN p_sexo VARCHAR(10),
    IN p_estado_civil VARCHAR(50),
    IN p_curp VARCHAR(18),
    IN p_puesto VARCHAR(100),
    IN p_salario DECIMAL(10,2)
)
BEGIN
    DECLARE v_idUsuario INT;
    -- validaciones básicas
    IF p_correo IS NULL OR TRIM(p_correo) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Correo requerido';
    END IF;

    START TRANSACTION;
      INSERT INTO usuarios (nombre, apellido, correo, telefono, password_hash, fecha_nacimiento, activo)
      VALUES (p_nombre, p_apellido, p_correo, p_telefono, p_password_hash, p_fecha_nacimiento, TRUE);

      SET v_idUsuario = LAST_INSERT_ID();

      INSERT INTO empleados (idUsuario, domicilio, sexo, estado_civil, curp, puesto, salario, activo)
      VALUES (v_idUsuario, p_domicilio, p_sexo, p_estado_civil, p_curp, p_puesto, p_salario, TRUE);

      -- Asignar rol empleado (si no existe el rol 2, no falla pero registrará)
      INSERT INTO usuarios_roles (idUsuario, idRol, rol_activo) VALUES (v_idUsuario, 2, TRUE);

    COMMIT;

    SELECT v_idUsuario AS idUsuario_creado;
END$$


CREATE PROCEDURE agregar_administrador (
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_correo VARCHAR(150),
    IN p_telefono VARCHAR(20),
    IN p_password_hash VARCHAR(255),
    IN p_fecha_nacimiento DATE
)
BEGIN
    DECLARE v_idUsuario INT;

    IF p_correo IS NULL OR TRIM(p_correo) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Correo requerido';
    END IF;

    START TRANSACTION;
      INSERT INTO usuarios (nombre, apellido, correo, telefono, password_hash, fecha_nacimiento, activo)
      VALUES (p_nombre, p_apellido, p_correo, p_telefono, p_password_hash, p_fecha_nacimiento, TRUE);

      SET v_idUsuario = LAST_INSERT_ID();

      INSERT INTO usuarios_roles (idUsuario, idRol, rol_activo) VALUES (v_idUsuario, 1, TRUE);
    COMMIT;

    SELECT v_idUsuario AS idUsuario_creado;
END$$


CREATE PROCEDURE editar_empleado (
    IN p_idUsuario INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_correo VARCHAR(150),
    IN p_telefono VARCHAR(20),
    IN p_fecha_nacimiento DATE,
    IN p_domicilio VARCHAR(255),
    IN p_sexo VARCHAR(10),
    IN p_estado_civil VARCHAR(50),
    IN p_curp VARCHAR(18),
    IN p_puesto VARCHAR(100),
    IN p_salario DECIMAL(10,2),
    IN p_activo TINYINT -- 1 activo, 0 inactivo
)
BEGIN
    -- Validar existencia
    IF (SELECT COUNT(*) FROM usuarios WHERE idUsuario = p_idUsuario) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;

    START TRANSACTION;
      UPDATE usuarios
      SET nombre = p_nombre,
          apellido = p_apellido,
          correo = p_correo,
          telefono = p_telefono,
          fecha_nacimiento = p_fecha_nacimiento,
          activo = (p_activo = 1)
      WHERE idUsuario = p_idUsuario;

      UPDATE empleados
      SET domicilio = p_domicilio,
          sexo = p_sexo,
          estado_civil = p_estado_civil,
          curp = p_curp,
          puesto = p_puesto,
          salario = p_salario,
          activo = (p_activo = 1)
      WHERE idUsuario = p_idUsuario;
    COMMIT;

    SELECT ROW_COUNT() AS registros_afectados;
END$$


CREATE PROCEDURE editar_administrador (
    IN p_idUsuario INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_correo VARCHAR(150),
    IN p_telefono VARCHAR(20),
    IN p_fecha_nacimiento DATE,
    IN p_activo TINYINT
)
BEGIN
    IF (SELECT COUNT(*) FROM usuarios WHERE idUsuario = p_idUsuario) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;

    UPDATE usuarios
    SET nombre = p_nombre,
        apellido = p_apellido,
        correo = p_correo,
        telefono = p_telefono,
        fecha_nacimiento = p_fecha_nacimiento,
        activo = (p_activo = 1)
    WHERE idUsuario = p_idUsuario;

    SELECT ROW_COUNT() AS registros_afectados;
END$$


CREATE PROCEDURE desactivar_usuario (IN p_idUsuario INT)
BEGIN
    IF (SELECT COUNT(*) FROM usuarios WHERE idUsuario = p_idUsuario) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;

    UPDATE usuarios SET activo = FALSE WHERE idUsuario = p_idUsuario;
    -- opcional: también desactivar empleado y roles asociados
    UPDATE empleados SET activo = FALSE WHERE idUsuario = p_idUsuario;
    UPDATE usuarios_roles SET rol_activo = FALSE WHERE idUsuario = p_idUsuario;
    SELECT ROW_COUNT() AS registros_afectados;
END$$


CREATE PROCEDURE activar_usuario (IN p_idUsuario INT)
BEGIN
    IF (SELECT COUNT(*) FROM usuarios WHERE idUsuario = p_idUsuario) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;

    UPDATE usuarios SET activo = TRUE WHERE idUsuario = p_idUsuario;
    SELECT ROW_COUNT() AS registros_afectados;
END$$


/*
  ROLES y USUARIOS_ROLES
*/
CREATE PROCEDURE agregar_rol (
    IN p_nombre_rol VARCHAR(50)
)
BEGIN
    INSERT INTO roles (nombre_rol, activo) VALUES (p_nombre_rol, TRUE);
    SELECT LAST_INSERT_ID() AS idRol_creado;
END$$

CREATE PROCEDURE editar_rol (
    IN p_idRol INT,
    IN p_nombre_rol VARCHAR(50),
    IN p_activo TINYINT
)
BEGIN
    IF (SELECT COUNT(*) FROM roles WHERE idRol = p_idRol) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rol no existe';
    END IF;

    UPDATE roles
    SET nombre_rol = p_nombre_rol,
        activo = (p_activo = 1)
    WHERE idRol = p_idRol;

    SELECT ROW_COUNT() AS registros_afectados;
END$$

CREATE PROCEDURE desactivar_rol (IN p_idRol INT)
BEGIN
    IF (SELECT COUNT(*) FROM roles WHERE idRol = p_idRol) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rol no existe';
    END IF;

    UPDATE roles SET activo = FALSE WHERE idRol = p_idRol;
    -- desactivar asignaciones
    UPDATE usuarios_roles SET rol_activo = FALSE WHERE idRol = p_idRol;
    SELECT ROW_COUNT() AS registros_afectados;
END$$

CREATE PROCEDURE asignar_rol (
    IN p_idUsuario INT,
    IN p_idRol INT
)
BEGIN
    IF (SELECT COUNT(*) FROM usuarios WHERE idUsuario = p_idUsuario) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;
    IF (SELECT COUNT(*) FROM roles WHERE idRol = p_idRol) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rol no existe';
    END IF;

    -- si ya existe, reactiva; si no, inserta
    IF (SELECT COUNT(*) FROM usuarios_roles WHERE idUsuario = p_idUsuario AND idRol = p_idRol) > 0 THEN
        UPDATE usuarios_roles SET rol_activo = TRUE, fecha_asignacion = CURRENT_TIMESTAMP
        WHERE idUsuario = p_idUsuario AND idRol = p_idRol;
    ELSE
        INSERT INTO usuarios_roles (idUsuario, idRol, rol_activo) VALUES (p_idUsuario, p_idRol, TRUE);
    END IF;

    SELECT 'OK' AS resultado;
END$$

CREATE PROCEDURE remover_rol (
    IN p_idUsuario INT,
    IN p_idRol INT
)
BEGIN
    IF (SELECT COUNT(*) FROM usuarios_roles WHERE idUsuario = p_idUsuario AND idRol = p_idRol) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Asignación no existe';
    END IF;

    -- soft remove => rol_activo = FALSE
    UPDATE usuarios_roles SET rol_activo = FALSE WHERE idUsuario = p_idUsuario AND idRol = p_idRol;
    SELECT ROW_COUNT() AS registros_afectados;
END$$


/*
  PROVEEDORES (ya estaban bien, las dejo con validaciones)
*/
CREATE PROCEDURE agregar_proveedor (
    IN p_nombre VARCHAR(150),
    IN p_direccion VARCHAR(255),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(20)
)
BEGIN
    INSERT INTO proveedores (nombre, direccion, correo, telefono, estatus)
    VALUES (p_nombre, p_direccion, p_correo, p_telefono, 'Activo');
    SELECT LAST_INSERT_ID() AS idProveedor_creado;
END$$

CREATE PROCEDURE editar_proveedor (
    IN p_idProveedor INT,
    IN p_nombre VARCHAR(150),
    IN p_direccion VARCHAR(255),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_estatus VARCHAR(20)
)
BEGIN
    IF (SELECT COUNT(*) FROM proveedores WHERE idProveedor = p_idProveedor) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proveedor no existe';
    END IF;

    UPDATE proveedores
    SET nombre = p_nombre,
        direccion = p_direccion,
        correo = p_correo,
        telefono = p_telefono,
        estatus = CASE WHEN p_estatus IN ('Activo','Inactivo') THEN p_estatus ELSE estatus END
    WHERE idProveedor = p_idProveedor;

    SELECT ROW_COUNT() AS registros_afectados;
END$$

CREATE PROCEDURE eliminar_proveedor (IN p_idProveedor INT)
BEGIN
    IF (SELECT COUNT(*) FROM proveedores WHERE idProveedor = p_idProveedor) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proveedor no existe';
    END IF;

    UPDATE proveedores SET estatus = 'Inactivo' WHERE idProveedor = p_idProveedor;
    SELECT ROW_COUNT() AS registros_afectados;
END$$

CREATE PROCEDURE obtener_proveedores (IN p_soloActivos TINYINT)
BEGIN
    IF p_soloActivos = 1 THEN
        SELECT * FROM proveedores WHERE estatus = 'Activo';
    ELSE
        SELECT * FROM proveedores;
    END IF;
END$$


/*
  PRODUCTOS_ALMACEN
*/
CREATE PROCEDURE agregar_producto_almacen (
    IN p_nombre VARCHAR(150),
    IN p_unidad_medida VARCHAR(20),
    IN p_fecha_caducidad DATE,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_idProveedor INT
)
BEGIN
    IF p_idProveedor IS NOT NULL AND (SELECT COUNT(*) FROM proveedores WHERE idProveedor = p_idProveedor) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proveedor no existe';
    END IF;

    INSERT INTO productos_almacen (nombre, unidad_medida, fecha_caducidad, precio_unitario, idProveedor, estado)
    VALUES (p_nombre, p_unidad_medida, p_fecha_caducidad, p_precio_unitario, p_idProveedor, 'Activo');

    SELECT LAST_INSERT_ID() AS idProductoAlmacen_creado;
END$$

CREATE PROCEDURE editar_producto_almacen (
    IN p_idProductoAlmacen INT,
    IN p_nombre VARCHAR(150),
    IN p_unidad_medida VARCHAR(20),
    IN p_fecha_caducidad DATE,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_idProveedor INT,
    IN p_estado VARCHAR(20)
)
BEGIN
    IF (SELECT COUNT(*) FROM productos_almacen WHERE idProductoAlmacen = p_idProductoAlmacen) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no existe';
    END IF;

    IF p_idProveedor IS NOT NULL AND (SELECT COUNT(*) FROM proveedores WHERE idProveedor = p_idProveedor) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proveedor no existe';
    END IF;

    UPDATE productos_almacen
    SET nombre = p_nombre,
        unidad_medida = p_unidad_medida,
        fecha_caducidad = p_fecha_caducidad,
        precio_unitario = p_precio_unitario,
        idProveedor = p_idProveedor,
        estado = CASE WHEN p_estado IN ('Activo','Inactivo') THEN p_estado ELSE estado END
    WHERE idProductoAlmacen = p_idProductoAlmacen;

    SELECT ROW_COUNT() AS registros_afectados;
END$$

CREATE PROCEDURE desactivar_producto_almacen (IN p_idProductoAlmacen INT)
BEGIN
    IF (SELECT COUNT(*) FROM productos_almacen WHERE idProductoAlmacen = p_idProductoAlmacen) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no existe';
    END IF;

    UPDATE productos_almacen SET estado = 'Inactivo' WHERE idProductoAlmacen = p_idProductoAlmacen;
    SELECT ROW_COUNT() AS registros_afectados;
END$$


/*
  INGREDIENTES
  - Soft delete usando activo
  - Verificación de uso en recetas
*/
CREATE PROCEDURE agregar_ingrediente (IN p_idProductoAlmacen INT)
BEGIN
    IF (SELECT COUNT(*) FROM productos_almacen WHERE idProductoAlmacen = p_idProductoAlmacen) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto de almacén no existe';
    END IF;

    INSERT INTO ingredientes (idProductoAlmacen, activo) VALUES (p_idProductoAlmacen, TRUE);
    SELECT LAST_INSERT_ID() AS idIngrediente_creado;
END$$

CREATE PROCEDURE editar_ingrediente (
    IN p_idIngrediente INT,
    IN p_idProductoAlmacen INT,
    IN p_activo TINYINT
)
BEGIN
    IF (SELECT COUNT(*) FROM ingredientes WHERE idIngrediente = p_idIngrediente) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ingrediente no existe';
    END IF;

    IF (SELECT COUNT(*) FROM productos_almacen WHERE idProductoAlmacen = p_idProductoAlmacen) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto en almacén no existe';
    END IF;

    UPDATE ingredientes
    SET idProductoAlmacen = p_idProductoAlmacen,
        activo = (p_activo = 1)
    WHERE idIngrediente = p_idIngrediente;

    SELECT ROW_COUNT() AS registros_afectados;
END$$

CREATE PROCEDURE desactivar_ingrediente (IN p_idIngrediente INT)
BEGIN
    IF (SELECT COUNT(*) FROM ingredientes WHERE idIngrediente = p_idIngrediente) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ingrediente no existe';
    END IF;

    IF (SELECT COUNT(*) FROM recetas_ingredientes WHERE idIngrediente = p_idIngrediente) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ingrediente está ligado a una receta. Desvincule primero.';
    END IF;

    UPDATE ingredientes SET activo = FALSE WHERE idIngrediente = p_idIngrediente;
    SELECT ROW_COUNT() AS registros_afectados;
END$$


/*
  RECETAS y RECETAS_INGREDIENTES
  - Soft delete de recetas
*/
CREATE PROCEDURE agregar_receta (
    IN p_nombre VARCHAR(150),
    IN p_precio DECIMAL(10,2)
)
BEGIN
    INSERT INTO recetas (nombre, precio, activo) VALUES (p_nombre, p_precio, TRUE);
    SELECT LAST_INSERT_ID() AS idReceta_creada;
END$$

CREATE PROCEDURE editar_receta (
    IN p_idReceta INT,
    IN p_nombre VARCHAR(150),
    IN p_precio DECIMAL(10,2),
    IN p_activo TINYINT
)
BEGIN
    IF (SELECT COUNT(*) FROM recetas WHERE idReceta = p_idReceta) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Receta no existe';
    END IF;

    UPDATE recetas
    SET nombre = p_nombre,
        precio = p_precio,
        activo = (p_activo = 1)
    WHERE idReceta = p_idReceta;

    SELECT ROW_COUNT() AS registros_afectados;
END$$

CREATE PROCEDURE desactivar_receta (IN p_idReceta INT)
BEGIN
    IF (SELECT COUNT(*) FROM recetas WHERE idReceta = p_idReceta) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Receta no existe';
    END IF;

    IF (SELECT COUNT(*) FROM detalle_venta WHERE idReceta = p_idReceta) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Receta tiene ventas registradas. No se puede desactivar.';
    END IF;

    UPDATE recetas SET activo = FALSE WHERE idReceta = p_idReceta;
    SELECT ROW_COUNT() AS registros_afectados;
END$$

CREATE PROCEDURE agregar_ingrediente_a_receta (
    IN p_idReceta INT,
    IN p_idIngrediente INT,
    IN p_cantidad DOUBLE
)
BEGIN
    IF (SELECT COUNT(*) FROM recetas WHERE idReceta = p_idReceta AND activo = TRUE) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Receta no existe o no está activa';
    END IF;
    IF (SELECT COUNT(*) FROM ingredientes WHERE idIngrediente = p_idIngrediente AND activo = TRUE) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ingrediente no existe o no está activo';
    END IF;

    INSERT INTO recetas_ingredientes (idReceta, idIngrediente, cantidad)
    VALUES (p_idReceta, p_idIngrediente, p_cantidad);

    SELECT 'Ingrediente agregado correctamente.' AS mensaje;
END$$

CREATE PROCEDURE editar_ingrediente_en_receta (
    IN p_idReceta INT,
    IN p_idIngrediente INT,
    IN p_cantidad DOUBLE
)
BEGIN
    IF (SELECT COUNT(*) FROM recetas_ingredientes WHERE idReceta = p_idReceta AND idIngrediente = p_idIngrediente) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Combinación receta-ingrediente no existe';
    END IF;

    UPDATE recetas_ingredientes
    SET cantidad = p_cantidad
    WHERE idReceta = p_idReceta AND idIngrediente = p_idIngrediente;
END$$

CREATE PROCEDURE eliminar_ingrediente_de_receta (
    IN p_idReceta INT,
    IN p_idIngrediente INT
)
BEGIN
    DELETE FROM recetas_ingredientes
    WHERE idReceta = p_idReceta AND idIngrediente = p_idIngrediente;
END$$


/*
  MOVIMIENTOS DE INVENTARIO
  - tipo_movimiento: Entrada, Salida, Merma, Ajuste (se valida por texto)
  - Al registrar Salida se puede validar stock (opcional)
*/
CREATE PROCEDURE agregar_movimiento_inventario (
    IN p_idProductoAlmacen INT,
    IN p_tipo_movimiento VARCHAR(20),
    IN p_cantidad DOUBLE,
    IN p_idUsuario INT
)
BEGIN
    DECLARE v_total_double DOUBLE;
    IF (SELECT COUNT(*) FROM productos_almacen WHERE idProductoAlmacen = p_idProductoAlmacen AND estado = 'Activo') = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no existe o está inactivo';
    END IF;

    IF p_tipo_movimiento NOT IN ('Entrada','Salida','Merma','Ajuste') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de movimiento inválido';
    END IF;

    IF p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad debe ser mayor que 0';
    END IF;

    -- Inserta movimiento (no se mantiene un campo stock en tabla, se calcula con SUM de movimientos)
    INSERT INTO movimientos_inventario (idProductoAlmacen, tipo_movimiento, cantidad, idUsuario)
    VALUES (p_idProductoAlmacen, p_tipo_movimiento, p_cantidad, p_idUsuario);

    SELECT LAST_INSERT_ID() AS idMovimiento_creado;
END$$

CREATE PROCEDURE obtener_stock_producto (IN p_idProductoAlmacen INT)
BEGIN
    IF (SELECT COUNT(*) FROM productos_almacen WHERE idProductoAlmacen = p_idProductoAlmacen) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no existe';
    END IF;

    SELECT
      p.idProductoAlmacen,
      p.nombre,
      COALESCE((SELECT SUM(CASE WHEN tipo_movimiento IN ('Entrada') THEN cantidad WHEN tipo_movimiento IN ('Salida','Merma') THEN -cantidad WHEN tipo_movimiento = 'Ajuste' THEN cantidad ELSE 0 END)
                FROM movimientos_inventario m WHERE m.idProductoAlmacen = p.idProductoAlmacen),0) AS stock_actual
    FROM productos_almacen p
    WHERE p.idProductoAlmacen = p_idProductoAlmacen;
END$$


/*
  ORDENES DE COMPRA
  - crear orden y su detalle (operaciones separadas para flexibilidad)
*/
CREATE PROCEDURE crear_orden_compra (
    IN p_idProveedor INT,
    IN p_fechaOrden DATE,
    IN p_total DECIMAL(10,2),
    IN p_estado VARCHAR(20)
)
BEGIN
    IF (SELECT COUNT(*) FROM proveedores WHERE idProveedor = p_idProveedor AND estatus = 'Activo') = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proveedor no existe o está inactivo';
    END IF;

    IF p_estado NOT IN ('Pendiente','Recibido','Cancelado') THEN
        SET p_estado = 'Pendiente';
    END IF;

    INSERT INTO orden_compra (idProveedor, fechaOrden, total, estado) VALUES (p_idProveedor, p_fechaOrden, p_total, p_estado);
    SELECT LAST_INSERT_ID() AS idOrden_creada;
END$$

CREATE PROCEDURE agregar_detalle_orden (
    IN p_idOrden INT,
    IN p_idProductoAlmacen INT,
    IN p_cantidad DOUBLE,
    IN p_precio_unitario DECIMAL(10,2)
)
BEGIN
    IF (SELECT COUNT(*) FROM orden_compra WHERE idOrden = p_idOrden) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Orden no existe';
    END IF;
    IF (SELECT COUNT(*) FROM productos_almacen WHERE idProductoAlmacen = p_idProductoAlmacen) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no existe';
    END IF;

    INSERT INTO orden_detalle (idOrden, idProductoAlmacen, cantidad, precio_unitario)
    VALUES (p_idOrden, p_idProductoAlmacen, p_cantidad, p_precio_unitario);

    -- Actualizar total de orden (recalculo simple)
    UPDATE orden_compra
    SET total = (SELECT COALESCE(SUM(cantidad * precio_unitario),0) FROM orden_detalle WHERE idOrden = p_idOrden)
    WHERE idOrden = p_idOrden;

    SELECT ROW_COUNT() AS registros_afectados;
END$$


/*
  CIERRE DE CAJA
*/
CREATE PROCEDURE crear_cierre_caja (
    IN p_fecha DATE,
    IN p_total_efectivo DECIMAL(10,2),
    IN p_total_tarjeta DECIMAL(10,2),
    IN p_total_general DECIMAL(10,2),
    IN p_idUsuarioCierre INT
)
BEGIN
    IF (SELECT COUNT(*) FROM usuarios WHERE idUsuario = p_idUsuarioCierre) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario de cierre no existe';
    END IF;

    INSERT INTO cierre_caja (fecha, total_efectivo, total_tarjeta, total_general, idUsuarioCierre)
    VALUES (p_fecha, p_total_efectivo, p_total_tarjeta, p_total_general, p_idUsuarioCierre);

    SELECT LAST_INSERT_ID() AS idCierre_creado;
END$$


/*
  NOTIFICACIONES
*/
CREATE PROCEDURE crear_notificacion (
    IN p_idUsuario INT,
    IN p_titulo VARCHAR(150),
    IN p_mensaje TEXT,
    IN p_tipo VARCHAR(20)
)
BEGIN
    IF p_tipo NOT IN ('Sistema','Inventario','General') THEN
        SET p_tipo = 'General';
    END IF;

    INSERT INTO notificaciones (idUsuario, titulo, mensaje, tipo, leido)
    VALUES (p_idUsuario, p_titulo, p_mensaje, p_tipo, FALSE);

    SELECT LAST_INSERT_ID() AS idNotificacion_creada;
END$$

CREATE PROCEDURE marcar_notificacion_leida (IN p_idNotificacion INT)
BEGIN
    IF (SELECT COUNT(*) FROM notificaciones WHERE idNotificacion = p_idNotificacion) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Notificación no existe';
    END IF;

    UPDATE notificaciones SET leido = TRUE WHERE idNotificacion = p_idNotificacion;
    SELECT ROW_COUNT() AS registros_afectados;
END$$

DELIMITER ;








DROP PROCEDURE IF EXISTS agregar_producto_almacen;
DELIMITER $$

CREATE PROCEDURE agregar_producto_almacen (
    IN p_nombre VARCHAR(150),
    IN p_unidad_medida VARCHAR(20),
    IN p_fecha_caducidad DATE,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_idProveedor INT,
    IN p_cantidad DOUBLE,
    IN p_idUsuario INT
)
BEGIN
    -- Validar proveedor
    IF p_idProveedor IS NOT NULL AND (SELECT COUNT(*) FROM proveedores WHERE idProveedor = p_idProveedor) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proveedor no existe';
    END IF;

    -- Insertar producto
    INSERT INTO productos_almacen (nombre, unidad_medida, fecha_caducidad, precio_unitario, idProveedor, estado, stock)
    VALUES (p_nombre, p_unidad_medida, p_fecha_caducidad, p_precio_unitario, p_idProveedor, 'Activo', p_cantidad);

    SET @idProducto := LAST_INSERT_ID();

    -- Registrar movimiento (entrada inicial)
    INSERT INTO movimientos_inventario (idProductoAlmacen, tipo_movimiento, cantidad, idUsuario)
    VALUES (@idProducto, 'Entrada', p_cantidad, p_idUsuario);

    SELECT @idProducto AS idProductoAlmacen_creado;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE crear_venta (
    IN p_idUsuario INT,
    IN p_metodo_pago VARCHAR(20)
)
BEGIN
    INSERT INTO ventas (idUsuario, metodo_pago, total, iva, ieps)
    VALUES (p_idUsuario, p_metodo_pago, 0, 0, 0);

    SELECT LAST_INSERT_ID() AS idVenta_creada;
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE agregar_detalle_venta (
    IN p_idVenta INT,
    IN p_idReceta INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_iva DECIMAL(10,2);
    DECLARE v_ieps DECIMAL(10,2);

    -- precio de receta
    SELECT precio INTO v_precio
    FROM recetas
    WHERE idReceta = p_idReceta;

    IF v_precio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La receta no existe';
    END IF;

    SET v_subtotal = v_precio * p_cantidad;
    SET v_iva = v_subtotal * 0.16;
    SET v_ieps = v_subtotal * 0.05;

    -- insertar detalle
    INSERT INTO detalle_venta (idVenta, idReceta, cantidad, subtotal)
    VALUES (p_idVenta, p_idReceta, p_cantidad, v_subtotal);

    -- actualizar totales
    UPDATE ventas
    SET total = total + v_subtotal + v_iva + v_ieps,
        iva = iva + v_iva,
        ieps = ieps + v_ieps
    WHERE idVenta = p_idVenta;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_descuento_inventario
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idIngrediente INT;
    DECLARE v_cantidadNecesaria DOUBLE;
    DECLARE cur CURSOR FOR
        SELECT idIngrediente, cantidad
        FROM recetas_ingredientes
        WHERE idReceta = NEW.idReceta;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_idIngrediente, v_cantidadNecesaria;
        IF done THEN LEAVE read_loop; END IF;

        -- obtener producto del almacén
        UPDATE productos_almacen AS p
        JOIN ingredientes AS i ON p.idProductoAlmacen = i.idProductoAlmacen
        SET p.stock = p.stock - (v_cantidadNecesaria * NEW.cantidad)
        WHERE i.idIngrediente = v_idIngrediente;

        -- registrar movimiento
        INSERT INTO movimientos_inventario (
            idProductoAlmacen, tipo_movimiento, cantidad, idUsuario
        )
        SELECT i.idProductoAlmacen, 'Salida', (v_cantidadNecesaria * NEW.cantidad), NULL
        FROM ingredientes i
        WHERE i.idIngrediente = v_idIngrediente;
    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;



