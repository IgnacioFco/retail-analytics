-- ============================================================
--  Retail Analytics — Schema MySQL
--  Proyecto de portfolio | github.com/tuusuario/retail-analytics
-- ============================================================

CREATE DATABASE IF NOT EXISTS retail_analytics
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE retail_analytics;

-- ------------------------------------------------------------
-- 1. REGIONES
-- ------------------------------------------------------------
CREATE TABLE regiones (
  id_region   INT           AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(100)  NOT NULL,
  pais        VARCHAR(100)  NOT NULL DEFAULT 'Argentina'
);

-- ------------------------------------------------------------
-- 2. CLIENTES
-- ------------------------------------------------------------
CREATE TABLE clientes (
  id_cliente     INT           AUTO_INCREMENT PRIMARY KEY,
  nombre         VARCHAR(150)  NOT NULL,
  email          VARCHAR(200)  NOT NULL UNIQUE,
  id_region      INT           NOT NULL,
  fecha_registro DATE          NOT NULL,
  activo         TINYINT(1)    NOT NULL DEFAULT 1,
  CONSTRAINT fk_cliente_region FOREIGN KEY (id_region)
    REFERENCES regiones(id_region)
);

-- ------------------------------------------------------------
-- 3. CATEGORÍAS
-- ------------------------------------------------------------
CREATE TABLE categorias (
  id_categoria   INT           AUTO_INCREMENT PRIMARY KEY,
  nombre         VARCHAR(100)  NOT NULL,
  descripcion    TEXT
);

-- ------------------------------------------------------------
-- 4. PRODUCTOS
-- ------------------------------------------------------------
CREATE TABLE productos (
  id_producto    INT             AUTO_INCREMENT PRIMARY KEY,
  nombre         VARCHAR(200)    NOT NULL,
  id_categoria   INT             NOT NULL,
  precio_unitario DECIMAL(10,2)  NOT NULL,
  stock          INT             NOT NULL DEFAULT 0,
  activo         TINYINT(1)      NOT NULL DEFAULT 1,
  CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria)
    REFERENCES categorias(id_categoria)
);

-- ------------------------------------------------------------
-- 5. VENDEDORES
-- ------------------------------------------------------------
CREATE TABLE vendedores (
  id_vendedor  INT           AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(150)  NOT NULL,
  id_region    INT           NOT NULL,
  activo       TINYINT(1)    NOT NULL DEFAULT 1,
  CONSTRAINT fk_vendedor_region FOREIGN KEY (id_region)
    REFERENCES regiones(id_region)
);

-- ------------------------------------------------------------
-- 6. VENTAS (cabecera)
-- ------------------------------------------------------------
CREATE TABLE ventas (
  id_venta     INT           AUTO_INCREMENT PRIMARY KEY,
  id_cliente   INT           NOT NULL,
  id_vendedor  INT           NOT NULL,
  fecha_venta  DATE          NOT NULL,
  estado       ENUM('completada','cancelada','pendiente') NOT NULL DEFAULT 'completada',
  CONSTRAINT fk_venta_cliente  FOREIGN KEY (id_cliente)  REFERENCES clientes(id_cliente),
  CONSTRAINT fk_venta_vendedor FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor)
);

-- ------------------------------------------------------------
-- 7. DETALLE DE VENTAS (líneas)
-- ------------------------------------------------------------
CREATE TABLE detalle_ventas (
  id_detalle      INT             AUTO_INCREMENT PRIMARY KEY,
  id_venta        INT             NOT NULL,
  id_producto     INT             NOT NULL,
  cantidad        INT             NOT NULL,
  precio_unitario DECIMAL(10,2)   NOT NULL,  -- precio al momento de la venta
  descuento_pct   DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
  CONSTRAINT fk_detalle_venta    FOREIGN KEY (id_venta)    REFERENCES ventas(id_venta),
  CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ============================================================
-- ÍNDICES para performance (mostrar en el README)
-- ============================================================
CREATE INDEX idx_ventas_fecha     ON ventas(fecha_venta);
CREATE INDEX idx_ventas_cliente   ON ventas(id_cliente);
CREATE INDEX idx_detalle_producto ON detalle_ventas(id_producto);
CREATE INDEX idx_clientes_region  ON clientes(id_region);
