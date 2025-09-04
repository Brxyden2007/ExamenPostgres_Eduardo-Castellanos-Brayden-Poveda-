# 📦 Sistema de Gestión de Ventas en PostgreSQL

Este proyecto implementa un **modelo de base de datos para la gestión de ventas** utilizando **PostgreSQL 16**. Incluye tablas principales, relaciones, procedimientos almacenados y triggers que aseguran la integridad de los datos y automatizan procesos clave.

---

<img width="1545" height="1036" alt="Untitled" src="https://github.com/user-attachments/assets/bbe5b9d4-8025-4297-9ec7-ebaf8273aa0f" />


## 🗂️ Estructura de Tablas

- **proveedores**: almacena los datos de proveedores.
- **productos**: catálogo de productos, con control de stock y precios.
- **clientes**: datos de clientes, con control de estado (activo/inactivo).
- **ventas**: cabecera de las ventas realizadas.
- **ventas_detalle**: detalle de los productos vendidos en cada venta.
- **historial_precios**: registro histórico de cambios en precios de productos.
- **auditoria_ventas**: registro de ventas insertadas con usuario y fecha.
- **alertas_stock**: notificaciones cuando un producto se agota.

---

## ⚙️ Procedimientos Almacenados

### `registrar_venta(cliente_id, producto_id, cantidad)`
- Valida que el cliente exista.
- Verifica que el stock sea suficiente.
- Si no hay stock suficiente → **RAISE EXCEPTION**.
- Si todo es correcto → crea la venta, descuenta stock e inserta el detalle.

---

## 🔔 Triggers Implementados

1. **Descuento automático de stock**  
  
2. **Auditoría de ventas**  

3. **Notificación de productos agotados**  

4. **Validación de clientes**  

5. **Historial de cambios de precio**  

6. **Bloqueo de eliminación de proveedores con productos activos**  

7. **Validación de fechas en ventas**  
 
8. **Reactivación automática de clientes inactivos**  


---

## ⚙️ Instrucciones de Importación y Ejecución

### 1. Instalar PostgreSQL
Asegúrate de tener instalado **PostgreSQL 16** y la herramienta **pgAdmin 4** (opcional, pero recomendada).

### 2. Crear la Base de Datos
Conéctate a PostgreSQL (en consola o pgAdmin) y ejecuta:

## 📂 Descripción de los Scripts

### 1. `db.sql`
- Crea la estructura de la base de datos.
- Define las tablas principales:
  - **proveedores**
  - **productos**
  - **clientes**
  - **ventas**
  - **ventas_detalle**
  - **historial_precios**
  - **auditoria_ventas**
  - **alertas_stock**
- Establece relaciones, llaves primarias, llaves foráneas y restricciones de integridad.

---

### 2. `insert.sql`
- Inserta datos iniciales en las tablas.
- Ejemplos:
  - 15 proveedores con diferentes nombres.
  - 15 productos con categorías, precios y stocks iniciales.
  - Clientes de prueba para registrar ventas.
- Facilita las pruebas de procedimientos y triggers.

---

### 3. `queries.sql`
- Contiene consultas útiles para trabajar con el sistema:
  - Listar productos y su stock actual.
  - Consultar ventas realizadas por un cliente.
  - Revisar el historial de precios de un producto.
  - Ver alertas de productos agotados.
  - Consultar registros en la tabla de auditoría.
- Sirve como conjunto de ejemplos para verificar el correcto funcionamiento del sistema.

---

### 4. `procedure.sql`
- Define procedimientos almacenados y triggers que automatizan reglas de negocio:
  - **Procedimiento `registrar_venta`**
    - Valida cliente.
    - Verifica stock.
    - Registra venta y descuenta stock.
  - **Triggers:**
    - Descuento automático de stock en `ventas_detalle`.
    - Auditoría de ventas en `auditoria_ventas`.
    - Registro de cambios de precio en `historial_precios`.
    - Notificación de productos agotados en `alertas_stock`.
    - Validación de datos en clientes.
    - Bloqueo de eliminación de proveedores con productos asociados.
    - Validación de fechas en ventas.
    - Reactivación de clientes inactivos.

---

## 🚀 Cómo Probar

1. Crear la base de datos en PostgreSQL 16.
2. Ejecutar los scripts de creación de tablas.
3. Insertar datos de prueba en `proveedores`, `productos` y `clientes`.
4. Probar los procedimientos y triggers con sentencias `INSERT` y `CALL`.}

-- 

# ▶️ Ejecución de Consultas y Procedimiento en PostgreSQL

A continuación se muestran ejemplos prácticos de cómo ejecutar las consultas y el procedimiento almacenado en el sistema de ventas.

---

## 🔍 Consultas de ejemplo

```sql
-- Listar todos los productos con su stock
SELECT id, nombre, categoria, precio, stock
FROM productos;

-- Consultar ventas de un cliente específico
SELECT v.id AS venta_id, v.fecha, c.nombre AS cliente
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
WHERE c.id = 1;

-- Revisar historial de precios de un producto
SELECT producto_id, precio_anterior, precio_nuevo, cambiado_en
FROM historial_precios
WHERE producto_id = 2;

-- Ver alertas de productos agotados
SELECT producto_id, nombre_producto, mensaje, generado_en
FROM alertas_stock;

-- Consultar registros de auditoría de ventas
SELECT venta_id, usuario, registrado_en
FROM auditoria_ventas;

-- Procedimientos almacenados
Registrar una venta (cliente 1 compra 3 unidades del producto 2)
CALL registrar_venta(1, 2, 3);
```

_______________________________________
## AUTORES:
- Brayden Poveda
- Eduardo Castellanos
