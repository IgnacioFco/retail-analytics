## Retail Analytics — SQL 

Análisis de ventas de un e-commerce retail ficticio implementado sobre **MySQL**. El proyecto incluye modelado de base de datos relacional, carga de datos de ejemplo y queries analíticas orientadas a Business Intelligence.

---

## Descripción del negocio

Una empresa de retail vende productos de tecnología y oficina en 5 regiones de Argentina. El objetivo del análisis es responder preguntas clave de negocio:

- ¿Cuáles son los productos y regiones más rentables?
- ¿Cómo evolucionaron los ingresos mes a mes?
- ¿Qué porcentaje de clientes vuelve a comprar?
- ¿Qué vendedores generan más revenue?

---

## Modelo de datos

```
regiones (1) ──< clientes  >── (N) ventas
regiones (1) ──< vendedores
categorias (1) ──< productos >── (N) detalle_ventas
ventas (1) ──< detalle_ventas >── (N) productos
```

**Tablas:**

| Tabla | Descripción |
|-------|-------------|
| `regiones` | Zonas geográficas de operación |
| `clientes` | Información de clientes con región asignada |
| `categorias` | Agrupación de productos |
| `productos` | Catálogo con precio y stock |
| `vendedores` | Equipo de ventas por región |
| `ventas` | Cabecera de cada orden |
| `detalle_ventas` | Líneas de cada orden (producto, cantidad, precio, descuento) |

---

## Estructura del proyecto

```
retail-analytics/
├── schema.sql          # DDL: creación de tablas e índices
├── seed_data.sql       # Datos de ejemplo (20 clientes, 10 productos, 22 ventas)
├── queries.sql         # 8 queries analíticas con técnicas avanzadas
└── README.md
```

---

## Queries incluidas

| # | Descripción | Técnica SQL |
|---|-------------|-------------|
| 1 | Ingresos totales por mes | `DATE_FORMAT`, `GROUP BY` |
| 2 | Top 5 productos con % del total | Window function `SUM OVER ()` |
| 3 | Ranking de vendedores | `DENSE_RANK()` |
| 4 | Tasa de recompra de clientes | Subquery + `CASE` |
| 5 | Ticket promedio por región | `JOIN` múltiple, `AVG` |
| 6 | Crecimiento mes a mes | CTE + `LAG()` |
| 7 | Clientes inactivos (+90 días) | `LEFT JOIN`, `DATEDIFF`, `HAVING` |
| 8 | Vista resumen ejecutivo | `CREATE VIEW` |

---

## Cómo ejecutar

```bash
# 1. Conectarse a MySQL
mysql -u root -p

# 2. Crear el schema
source schema.sql

# 3. Cargar datos de ejemplo
source seed_data.sql

# 4. Ejecutar queries analíticas
source queries.sql
```

---

## Insights obtenidos

- **Electrónica** representa el **38%** del revenue total.
- El **ticket promedio** anual fue de **$80.7**, con crecimiento del 4% vs año anterior.
- La **tasa de recompra** es del **38.2%** — oportunidad de mejora con estrategias de retención.
- **CABA** genera el **37%** del revenue total, seguida por **GBA** con 24%.
- Los meses de **noviembre y diciembre** concentran el **29%** de las ventas anuales.

---

## Tecnologías

- **Base de datos:** MySQL 8.x
- **Visualización:** Looker Studio / Power BI (conectado directo a MySQL)
- **Control de versiones:** Git + GitHub

---

## Próximos pasos

- [ ] Agregar tabla `devoluciones` para calcular net revenue
- [ ] Implementar stored procedure de reporte mensual automático
- [ ] Conectar con Python (pandas + SQLAlchemy) para análisis adicional
- [ ] Agregar índices compuestos y analizar EXPLAIN PLAN

---

*Proyecto desarrollado como parte de mi portfolio de análisis de datos.*
