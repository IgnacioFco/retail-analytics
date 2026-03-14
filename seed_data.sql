-- ============================================================
--  Retail Analytics — Datos de ejemplo
-- ============================================================
USE retail_analytics;

-- REGIONES
INSERT INTO regiones (nombre, pais) VALUES
  ('CABA',    'Argentina'),
  ('GBA',     'Argentina'),
  ('Córdoba', 'Argentina'),
  ('Rosario', 'Argentina'),
  ('Mendoza', 'Argentina');

-- CATEGORÍAS
INSERT INTO categorias (nombre, descripcion) VALUES
  ('Electrónica',  'Dispositivos y gadgets electrónicos'),
  ('Oficina',      'Mobiliario y equipamiento de oficina'),
  ('Periféricos',  'Teclados, mouse, monitores y similares'),
  ('Accesorios',   'Cables, adaptadores y complementos'),
  ('Otros',        'Productos varios');

-- PRODUCTOS
INSERT INTO productos (nombre, id_categoria, precio_unitario, stock) VALUES
  ('Auriculares Pro X',      1, 189.99, 250),
  ('Monitor UltraWide 34"',  3, 549.00, 80),
  ('Silla Ergonómica Z7',    2, 320.00, 120),
  ('Teclado Mecánico K2',    3,  99.99, 300),
  ('Webcam 4K Studio',       1, 149.99, 200),
  ('Mouse Inalámbrico MX',   3,  59.99, 400),
  ('Hub USB-C 7 puertos',    4,  39.99, 500),
  ('Lámpara LED Escritorio', 2,  45.00, 350),
  ('Soporte Notebook Pro',   4,  55.00, 280),
  ('Micrófono Condensador',  1, 210.00, 90);

-- VENDEDORES
INSERT INTO vendedores (nombre, id_region) VALUES
  ('Laura Gómez',    1),
  ('Martín Sosa',    2),
  ('Valeria López',  3),
  ('Diego Fernández',4),
  ('Camila Ruiz',    5);

-- CLIENTES (20 ejemplos)
INSERT INTO clientes (nombre, email, id_region, fecha_registro) VALUES
  ('Ana Torres',      'ana.torres@mail.com',    1, '2022-03-15'),
  ('Juan Pérez',      'juan.perez@mail.com',    2, '2021-07-22'),
  ('Sofía Martínez',  'sofia.m@mail.com',       1, '2023-01-10'),
  ('Carlos Ramos',    'c.ramos@mail.com',        3, '2022-11-05'),
  ('Luciana Flores',  'lu.flores@mail.com',      4, '2021-05-18'),
  ('Tomás Álvarez',   'tomas.a@mail.com',        5, '2023-06-30'),
  ('Marina Díaz',     'marina.d@mail.com',       1, '2022-08-14'),
  ('Pablo Suárez',    'pablo.s@mail.com',        2, '2021-12-01'),
  ('Valentina Ríos',  'valen.rios@mail.com',     3, '2023-03-22'),
  ('Ignacio Morales', 'igna.morales@mail.com',   4, '2022-04-09'),
  ('Florencia Vega',  'flor.vega@mail.com',      1, '2023-09-15'),
  ('Sebastián Luna',  'seba.luna@mail.com',      2, '2021-10-27'),
  ('Rocío Herrera',   'rocio.h@mail.com',        5, '2022-02-03'),
  ('Matías Castro',   'mati.castro@mail.com',    3, '2023-07-11'),
  ('Jimena Ortiz',    'jime.ortiz@mail.com',     1, '2021-08-19'),
  ('Leandro Silva',   'lean.silva@mail.com',     4, '2022-06-25'),
  ('Paola Medina',    'paola.m@mail.com',        2, '2023-04-08'),
  ('Rodrigo Vargas',  'rodri.v@mail.com',        5, '2021-11-14'),
  ('Elena Romero',    'elena.r@mail.com',        1, '2022-09-30'),
  ('Facundo Giménez', 'facu.g@mail.com',         3, '2023-02-17');

-- VENTAS + DETALLE (muestra representativa)
INSERT INTO ventas (id_cliente, id_vendedor, fecha_venta, estado) VALUES
  (1,  1, '2024-01-08',  'completada'),
  (2,  2, '2024-01-15',  'completada'),
  (3,  1, '2024-02-03',  'completada'),
  (4,  3, '2024-02-20',  'completada'),
  (5,  4, '2024-03-11',  'completada'),
  (6,  5, '2024-03-28',  'cancelada'),
  (7,  1, '2024-04-05',  'completada'),
  (8,  2, '2024-04-22',  'completada'),
  (9,  3, '2024-05-10',  'completada'),
  (10, 4, '2024-05-30',  'completada'),
  (11, 1, '2024-06-14',  'completada'),
  (12, 2, '2024-07-02',  'completada'),
  (13, 5, '2024-07-19',  'completada'),
  (14, 3, '2024-08-08',  'completada'),
  (15, 4, '2024-09-01',  'completada'),
  (1,  1, '2024-09-18',  'completada'),  -- recompra cliente 1
  (2,  2, '2024-10-07',  'completada'),  -- recompra cliente 2
  (16, 1, '2024-10-25',  'completada'),
  (17, 2, '2024-11-12',  'completada'),
  (18, 5, '2024-11-29',  'completada'),
  (19, 1, '2024-12-10',  'completada'),
  (20, 3, '2024-12-20',  'completada');

INSERT INTO detalle_ventas (id_venta, id_producto, cantidad, precio_unitario, descuento_pct) VALUES
  (1,  1, 1, 189.99, 0.00),
  (1,  4, 1,  99.99, 5.00),
  (2,  3, 1, 320.00, 0.00),
  (3,  2, 1, 549.00,10.00),
  (4,  5, 2, 149.99, 0.00),
  (5,  6, 1,  59.99, 0.00),
  (5,  7, 2,  39.99, 0.00),
  (7,  1, 1, 189.99, 0.00),
  (7,  9, 1,  55.00, 0.00),
  (8,  3, 1, 320.00, 5.00),
  (9,  4, 2,  99.99, 0.00),
  (10, 10, 1, 210.00, 0.00),
  (11, 2,  1, 549.00, 0.00),
  (12, 5,  1, 149.99, 0.00),
  (12, 8,  1,  45.00, 0.00),
  (13, 1,  2, 189.99, 8.00),
  (14, 6,  1,  59.99, 0.00),
  (15, 3,  1, 320.00, 0.00),
  (16, 4,  1,  99.99, 0.00),  -- recompra
  (17, 10, 1, 210.00, 0.00),  -- recompra
  (18, 2,  1, 549.00,12.00),
  (19, 1,  1, 189.99, 0.00),
  (20, 9,  2,  55.00, 0.00),
  (21, 5,  1, 149.99, 0.00),
  (22, 7,  3,  39.99, 5.00);
