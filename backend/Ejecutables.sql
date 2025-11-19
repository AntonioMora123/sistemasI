USE restaurante;

-- =====================================================
-- EJEMPLOS DE USO DE PROCEDIMIENTOS
-- =====================================================

-- ===========================
-- 1. USUARIOS / EMPLEADOS
-- ===========================

-- Agregar un empleado
CALL agregar_empleado(
    'Juan', 'Pérez', 'juan@example.com', '5551234567',
    'hash123', '1990-05-10',
    'Calle Falsa 123', 'M', 'Soltero',
    'PEPJ900510HDFRRN08', 'Mesero', 8500.00
);

-- Agregar administrador
CALL agregar_administrador(
    'Ana', 'López', 'ana@example.com',
    '5559876543', 'hash456', '1988-11-22'
);

-- Editar empleado
CALL editar_empleado(
    1, 'Juan', 'Pérez', 'juan_p@example.com', '5553334444',
    '1990-05-10', 'Nueva Calle 22', 'M', 'Casado',
    'PEPJ900510HDFRRN08', 'Cajero', 9500.00, 1
);

-- Editar administrador
CALL editar_administrador(
    2, 'Ana', 'López', 'admin_ana@example.com',
    '5550001122', '1988-11-22', 1
);

-- Desactivar usuario
CALL desactivar_usuario(1);

-- Activar usuario
CALL activar_usuario(1);


-- ===========================
-- 2. ROLES Y ASIGNACIÓN
-- ===========================

-- Agregar rol
CALL agregar_rol('Supervisor');

-- Editar rol
CALL editar_rol(3, 'Supervisor General', 1);

-- Desactivar rol
CALL desactivar_rol(3);

-- Asignar rol a usuario
CALL asignar_rol(1, 2);

-- Remover rol a usuario
CALL remover_rol(1, 2);


-- ===========================
-- 3. PROVEEDORES
-- ===========================

-- Agregar proveedor
CALL agregar_proveedor(
    'Distribuidora Don Pepe', 'Calle 45', 'contacto@donpepe.com', '5557778888'
);

-- Editar proveedor
CALL editar_proveedor(
    1, 'Distribuidora Don Pepe SA', 'Calle 45, Col Centro',
    'ventas@donpepe.com', '5557779999', 'Activo'
);

-- Eliminar proveedor
CALL eliminar_proveedor(1);

-- Obtener proveedores (1 = solo activos)
CALL obtener_proveedores(1);


-- ===========================
-- 4. PRODUCTOS EN ALMACÉN
-- ===========================

-- Agregar producto al almacén
CALL agregar_producto_almacen(
    'Tomate',
    'kg',
    '2025-01-10',
    25.50,
    1,          -- idProveedor
    100,        -- cantidad (stock inicial)
    1           -- idUsuario que registra
);


-- Editar producto
CALL editar_producto_almacen(
    1, 'Tomate rojo', 'kg', '2025-01-10',
    26.00, 1, 'Activo'
);

-- Desactivar producto
CALL desactivar_producto_almacen(1);


-- ===========================
-- 5. INGREDIENTES
-- ===========================

-- Agregar ingrediente
CALL agregar_ingrediente(1);

-- Editar ingrediente
CALL editar_ingrediente(1, 2, 1);


-- Desactivar ingrediente
CALL desactivar_ingrediente(1);


-- ===========================
-- 6. RECETAS
-- ===========================

-- Agregar receta
CALL agregar_receta('Ensalada Mixta', 79.00);

-- Editar receta
CALL editar_receta(1, 'Ensalada Especial', 89.00, 1);

-- Desactivar receta
CALL desactivar_receta(1);

-- Agregar ingrediente a receta
CALL agregar_ingrediente_a_receta(1, 1, 0.25);

-- Editar ingrediente en receta
CALL editar_ingrediente_en_receta(1, 1, 0.30);

-- Eliminar ingrediente de una receta
CALL eliminar_ingrediente_de_receta(1, 1);


-- ===========================
-- 7. INVENTARIO
-- ===========================

-- Agregar movimiento de inventario
CALL agregar_movimiento_inventario(1, 'Entrada', 10, 1);

-- Consultar stock
CALL obtener_stock_producto(1);


-- ===========================
-- 8. ÓRDENES DE COMPRA
-- ===========================

-- Crear orden de compra
CALL crear_orden_compra(
    1,               -- idProveedor
    '2025-02-12',    -- fecha
    1500.00,         -- total
    'Pendiente'      -- estado
);


-- Agregar detalle a orden
CALL agregar_detalle_orden(1, 1, 20, 25.50);


-- ===========================
-- 9. VENTAS
-- ===========================

-- Crear venta
CALL crear_venta(1, 'Tarjeta');

-- Agregar detalle venta
CALL agregar_detalle_venta(1, 1, 2);


-- ===========================
-- 10. CIERRE DE CAJA
-- ===========================

CALL crear_cierre_caja('2025-02-12', 1200.50, 800.00, 2000.50, 1);


-- ===========================
-- 11. NOTIFICACIONES
-- ===========================

CALL crear_notificacion(1, 'Stock bajo', 'El tomate está por agotarse', 'Inventario');

CALL marcar_notificacion_leida(1);
