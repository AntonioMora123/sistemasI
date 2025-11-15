CALL agregar_empleado(
  'Juan',
  'Pérez',
  'juan@example.com',
  '3120001122',
  'HASH123',
  '1995-01-01',
  'Calle 123',
  'M',
  'Soltero',
  'CURP123456789',
  'Mesero',
  7500.00
);

CALL agregar_administrador(
  'Ana',
  'Gómez',
  'ana@example.com',
  '3112201100',
  'HASH001',
  '1990-05-10'
);

CALL editar_empleado(
  1,
  'Juan Modificado',
  'Pérez',
  'juan2@example.com',
  '3119990000',
  '1995-01-01',
  'Calle Nueva 55',
  'M',
  'Casado',
  'CURP7777',
  'Cocinero',
  8500.00,
  1
);

CALL editar_administrador(
  2,
  'Ana',
  'Gómez',
  'ana2@example.com',
  '3001112200',
  '1990-05-10',
  1
);

CALL desactivar_usuario(1);

CALL activar_usuario(1);

CALL agregar_proveedor(
  'Proveedor ABC',
  'Calle 8 123',
  'prove@abc.com',
  '3221122334'
);

CALL editar_proveedor(
  1,
  'Proveedor Mod',
  'Nueva Dirección',
  'nuevo@mail.com',
  '3111111111',
  'Activo'
);

CALL eliminar_proveedor(1);

CALL obtener_proveedores(1);

CALL agregar_producto_almacen(
  'Carne molida',
  'kg',
  '2025-01-01',
  120.00,
  1
);

CALL editar_producto_almacen(
  1,
  'Carne molida Premium',
  'kg',
  '2025-02-01',
  130.00,
  1,
  'Activo'
);


CALL desactivar_producto_almacen(1);

CALL agregar_ingrediente(1);

CALL editar_ingrediente(1, 1, 1);

CALL desactivar_ingrediente(1);

CALL agregar_receta('Hamburguesa Sencilla', 45.00);

CALL editar_receta(1, 'Hamburguesa Doble', 65.00, 1);

CALL desactivar_receta(1);

CALL agregar_ingrediente_a_receta(1, 1, 0.25);

CALL editar_ingrediente_en_receta(1, 1, 0.30);

CALL eliminar_ingrediente_de_receta(1, 1);

CALL agregar_movimiento_inventario(1, 'Entrada', 10, 1);

CALL obtener_stock_producto(1);

CALL crear_orden_compra(1, '2025-01-01', 0, 'Pendiente');

CALL agregar_detalle_orden(1, 1, 5, 120.00);

