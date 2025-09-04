-- Consultas (queries.sql)

1️⃣ Listar los productos con stock menor a 5 unidades.

Solucion:

SELECT nombre, categoria, precio, stock 
FROM productos 
WHERE stock < 5;

2️⃣ Calcular ventas totales de un mes específico.

Solucion:

SELECT SUM(vd.cantidad * vd.precio_unitario) AS ventas_totales
FROM ventas v
JOIN ventas_detalle vd ON v.id = vd.venta_id
WHERE EXTRACT(MONTH FROM v.fecha) = 8 
  AND EXTRACT(YEAR FROM v.fecha) = 2024;

3️⃣ Obtener el cliente con más compras realizadas.

Solucion:

SELECT c.id, c.nombre, COUNT(v.id) AS total_compras
FROM clientes c
JOIN ventas v ON c.id = v.cliente_id
GROUP BY c.id
ORDER BY total_compras DESC
LIMIT 1;

4️⃣ Listar los 5 productos más vendidos.

Solucion:

SELECT p.id, p.nombre, p.categoria, SUM(vd.cantidad) AS total_vendido
FROM productos p
JOIN ventas_detalle vd ON p.id = vd.producto_id
GROUP BY p.id
ORDER BY total_vendido DESC
LIMIT 5;

5️⃣ Consultar ventas realizadas en un rango de fechas de tres Días y un Mes.

Solucion:

SELECT v.id, v.cliente_id, v.fecha
FROM ventas v
WHERE v.fecha BETWEEN '2024-08-04' AND '2024-09-04';

-- Explicacion rapida: Lo que entendi yo por tres dias y un mes es que, en mis inserts empieza desde 2024-08-01, por  ende, entonces, desde tres dias seria 2024-08-04 hasta 2024-09-04

6️⃣ Identificar clientes que no han comprado en los últimos 6 meses.

Solucion:

SELECT c.id, c.nombre, c.correo
FROM clientes c
LEFT JOIN ventas v ON c.id = v.cliente_id
GROUP BY c.id
HAVING MAX(v.fecha) < NOW() - INTERVAL '6 months' OR MAX(v.fecha) IS NULL;

-- Explicacion rapida (otra vez): En esta parte, de por si, al hacerlo desde hoy, todos los usuarios estan desde 2024, por ende, llevan 1 año sin pedir algo, asi que saldrian todos los usuarios a excepcion de quienes no han pedido nada.
