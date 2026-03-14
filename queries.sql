-- ============================================================
--  Retail Analytics — Queries analíticas
--  Cada query demuestra una habilidad distinta de SQL
-- ============================================================
USE retail_analytics;

-- ============================================================
-- 1. INGRESOS TOTALES POR MES Y AÑO
--    Habilidad: DATE_FORMAT, GROUP BY, ORDER BY
-- ============================================================
SELECT
  DATE_FORMAT(v.fecha_venta, '%Y-%m') AS mes,
  COUNT(DISTINCT v.id_venta)          AS cantidad_ordenes,
  ROUND(
    SUM(dv.cantidad * dv.precio_unitario * (1 - dv.descuento_pct / 100)),
    2
  )                                   AS ingresos_netos
FROM ventas v
JOIN detalle_ventas dv ON v.id_venta = dv.id_venta
WHERE v.estado = 'completada'
GROUP BY mes
ORDER BY mes;


-- ============================================================
-- 2. TOP 5 PRODUCTOS POR INGRESO (con % del total)
--    Habilidad: subquery, window function (SUM OVER)
-- ============================================================
SELECT
  p.nombre                                     AS producto,
  c.nombre                                     AS categoria,
  ROUND(SUM(dv.cantidad * dv.precio_unitario * (1 - dv.descuento_pct / 100)), 2) AS ingresos,
  ROUND(
    SUM(dv.cantidad * dv.precio_unitario * (1 - dv.descuento_pct / 100)) * 100.0
    / SUM(SUM(dv.cantidad * dv.precio_unitario * (1 - dv.descuento_pct / 100))) OVER (),
    1
  )                                             AS pct_del_total
FROM detalle_ventas dv
JOIN ventas    v ON dv.id_venta    = v.id_venta
JOIN productos p ON dv.id_producto = p.id_producto
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE v.estado = 'completada'
GROUP BY p.id_producto, p.nombre, c.nombre
ORDER BY ingresos DESC
LIMIT 5;


-- ============================================================
-- 3. RANKING DE VENDEDORES (DENSE_RANK)
--    Habilidad: window functions RANK / DENSE_RANK
-- ============================================================
SELECT
  vend.nombre                                                        AS vendedor,
  r.nombre                                                           AS region,
  COUNT(DISTINCT v.id_venta)                                         AS ventas_realizadas,
  ROUND(SUM(dv.cantidad * dv.precio_unitario * (1 - dv.descuento_pct / 100)), 2) AS ingresos_generados,
  DENSE_RANK() OVER (ORDER BY SUM(dv.cantidad * dv.precio_unitario * (1 - dv.descuento_pct / 100)) DESC) AS ranking
FROM ventas v
JOIN vendedores   vend ON v.id_vendedor = vend.id_vendedor
JOIN regiones     r    ON vend.id_region = r.id_region
JOIN detalle_ventas dv ON v.id_venta    = dv.id_venta
WHERE v.estado = 'completada'
GROUP BY vend.id_vendedor, vend.nombre, r.nombre
ORDER BY ranking;


-- ============================================================
-- 4. TASA DE RECOMPRA DE CLIENTES
--    Habilidad: subquery, CASE, porcentajes
-- ============================================================
SELECT
  ROUND(
    COUNT(CASE WHEN total_compras > 1 THEN 1 END) * 100.0 / COUNT(*),
    1
  ) AS tasa_recompra_pct,
  COUNT(CASE WHEN total_compras > 1 THEN 1 END) AS clientes_recurrentes,
  COUNT(*)                                       AS total_clientes
FROM (
  SELECT id_cliente, COUNT(id_venta) AS total_compras
  FROM ventas
  WHERE estado = 'completada'
  GROUP BY id_cliente
) sub;


-- ============================================================
-- 5. TICKET PROMEDIO POR REGIÓN
--    Habilidad: JOIN múltiple, AVG, GROUP BY
-- ============================================================
SELECT
  r.nombre                                                                   AS region,
  COUNT(DISTINCT v.id_venta)                                                 AS ordenes,
  ROUND(AVG(orden_total.total), 2)                                           AS ticket_promedio,
  ROUND(SUM(orden_total.total), 2)                                           AS ingresos_totales
FROM ventas v
JOIN clientes  cl ON v.id_cliente = cl.id_cliente
JOIN regiones  r  ON cl.id_region = r.id_region
JOIN (
  SELECT id_venta, SUM(cantidad * precio_unitario * (1 - descuento_pct / 100)) AS total
  FROM detalle_ventas
  GROUP BY id_venta
) orden_total ON v.id_venta = orden_total.id_venta
WHERE v.estado = 'completada'
GROUP BY r.id_region, r.nombre
ORDER BY ingresos_totales DESC;


-- ============================================================
-- 6. CRECIMIENTO MES A MES (LAG)
--    Habilidad: window function LAG, CTE
-- ============================================================
WITH ingresos_mensuales AS (
  SELECT
    DATE_FORMAT(v.fecha_venta, '%Y-%m')  AS mes,
    ROUND(SUM(dv.cantidad * dv.precio_unitario * (1 - dv.descuento_pct / 100)), 2) AS ingresos
  FROM ventas v
  JOIN detalle_ventas dv ON v.id_venta = dv.id_venta
  WHERE v.estado = 'completada'
  GROUP BY mes
)
SELECT
  mes,
  ingresos,
  LAG(ingresos) OVER (ORDER BY mes)    AS ingresos_mes_anterior,
  ROUND(
    (ingresos - LAG(ingresos) OVER (ORDER BY mes))
    / LAG(ingresos) OVER (ORDER BY mes) * 100,
    1
  )                                     AS variacion_pct
FROM ingresos_mensuales
ORDER BY mes;


-- ============================================================
-- 7. CLIENTES SIN ACTIVIDAD EN LOS ÚLTIMOS 90 DÍAS
--    Habilidad: LEFT JOIN, DATEDIFF, filtro por NULL
-- ============================================================
SELECT
  cl.id_cliente,
  cl.nombre,
  cl.email,
  MAX(v.fecha_venta)                      AS ultima_compra,
  DATEDIFF(CURDATE(), MAX(v.fecha_venta)) AS dias_inactivo
FROM clientes cl
LEFT JOIN ventas v ON cl.id_cliente = v.id_cliente AND v.estado = 'completada'
GROUP BY cl.id_cliente, cl.nombre, cl.email
HAVING ultima_compra IS NULL OR dias_inactivo > 90
ORDER BY dias_inactivo DESC;


-- ============================================================
-- 8. VISTA: resumen ejecutivo por producto
--    Habilidad: CREATE VIEW, columnas calculadas
-- ============================================================
CREATE OR REPLACE VIEW vw_resumen_productos AS
SELECT
  p.id_producto,
  p.nombre                                                             AS producto,
  c.nombre                                                             AS categoria,
  SUM(dv.cantidad)                                                     AS unidades_vendidas,
  ROUND(SUM(dv.cantidad * dv.precio_unitario * (1 - dv.descuento_pct / 100)), 2) AS ingresos_netos,
  ROUND(AVG(dv.descuento_pct), 1)                                      AS descuento_promedio_pct,
  COUNT(DISTINCT v.id_cliente)                                         AS clientes_distintos
FROM detalle_ventas dv
JOIN ventas     v  ON dv.id_venta    = v.id_venta
JOIN productos  p  ON dv.id_producto = p.id_producto
JOIN categorias c  ON p.id_categoria = c.id_categoria
WHERE v.estado = 'completada'
GROUP BY p.id_producto, p.nombre, c.nombre;

-- Consultar la vista:
-- SELECT * FROM vw_resumen_productos ORDER BY ingresos_netos DESC;
