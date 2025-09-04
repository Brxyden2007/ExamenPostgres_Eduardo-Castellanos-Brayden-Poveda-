-- DML sql (insert.sql)

INSERT INTO proveedores (nombre) VALUES
('Proveedor 1'),
('Proveedor 2'),
('Proveedor 3'),
('Proveedor 4'),
('Proveedor 5'),
('Proveedor 6'),
('Proveedor 7'),
('Proveedor 8'),
('Proveedor 9'),
('Proveedor 10'),
('Proveedor 11'),
('Proveedor 12'),
('Proveedor 13'),
('Proveedor 14'),
('Proveedor 15');

INSERT INTO productos (nombre, categoria, precio, stock, proveedor_id) VALUES
('Producto 1', 'Electrónica', 100.00, 4, 1),
('Producto 2', 'Ropa', 25.00, 100, 2),
('Producto 3', 'Muebles', 150.00, 2, 3),
('Producto 4', 'Electrónica', 200.00, 10, 1),
('Producto 5', 'Alimentos', 5.00, 200, 4),
('Producto 6', 'Alimentos', 3.00, 500, 4),
('Producto 7', 'Electrónica', 300.00, 15, 1),
('Producto 8', 'Juguetes', 20.00, 2, 5),
('Producto 9', 'Electrónica', 50.00, 80, 1),
('Producto 10', 'Muebles', 250.00, 25, 3),
('Producto 11', 'Ropa', 35.00, 120, 2),
('Producto 12', 'Juguetes', 15.00, 100, 5),
('Producto 13', 'Alimentos', 10.00, 1, 4),
('Producto 14', 'Electrónica', 120.00, 45, 1),
('Producto 15', 'Muebles', 200.00, 40, 3);

INSERT INTO clientes (nombre, correo, telefono, estado) VALUES
('Juan Pérez', 'juanperez@gmail.com', '123456789', 'activo'),
('María García', 'mariag@gmail.com', '987654321', 'activo'),
('Pedro Gómez', 'pedrog@gmail.com', '543216789', 'inactivo'),
('Ana Martínez', 'anamartinez@yahoo.com', '112233445', 'activo'),
('Carlos Fernández', 'carlosf@outlook.com', '998877665', 'activo'),
('Laura Sánchez', 'lauras@googlemail.com', '555444333', 'inactivo'),
('Luis Ruiz', 'luisruiz@hotmail.com', '333444555', 'activo'),
('Raquel Torres', 'raqueltorres@gmail.com', '666777888', 'activo'),
('Jorge Díaz', 'jorge.diaz@aol.com', '444555666', 'activo'),
('Sofía Hernández', 'sofiahernandez@yahoo.com', '777888999', 'inactivo'),
('Victor Gómez', 'victorgomez@gmail.com', '111222333', 'activo'),
('Pablo Rodríguez', 'pabloro@outlook.com', '222333444', 'activo'),
('Elena López', 'elenalopez@aol.com', '888999000', 'activo'),
('Tomás Pérez', 'tomasperez@gmail.com', '999000111', 'activo'),
('Beatriz Martínez', 'beatriz.martinez@yahoo.com', '444555666', 'inactivo');

INSERT INTO ventas (cliente_id, fecha) VALUES
(1, '2024-08-01 10:00:00'),
(2, '2024-08-02 14:30:00'),
(3, '2024-08-03 16:00:00'),
(4, '2024-08-04 09:15:00'),
(5, '2024-08-05 11:45:00'),
(1, '2024-08-06 13:30:00'),
(7, '2024-08-07 10:20:00'),
(8, '2024-08-08 15:00:00'),
(9, '2024-08-09 12:25:00'),
(10, '2024-08-10 18:00:00'),
(11, '2024-08-11 14:45:00'),
(12, '2024-08-12 16:30:00'),
(13, '2024-08-13 10:10:00'),
(14, '2024-08-14 11:55:00'),
(15, '2024-08-15 17:20:00');

INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 2, 100.00),
(2, 2, 1, 25.00),
(3, 3, 3, 150.00),
(4, 4, 1, 200.00),
(5, 5, 10, 5.00),
(1, 6, 5, 3.00),
(7, 7, 2, 300.00),
(8, 8, 4, 20.00),
(9, 9, 3, 50.00),
(10, 10, 1, 250.00),
(11, 11, 2, 35.00),
(12, 12, 6, 15.00),
(13, 13, 3, 10.00),
(14, 14, 1, 120.00),
(15, 15, 2, 200.00);

INSERT INTO historial_precios (producto_id, precio_anterior, precio_nuevo) VALUES
(1, 90.00, 100.00),
(2, 20.00, 25.00),
(3, 140.00, 150.00),
(4, 180.00, 200.00),
(5, 4.00, 5.00),
(6, 2.50, 3.00),
(7, 280.00, 300.00),
(8, 18.00, 20.00),
(9, 45.00, 50.00),
(10, 230.00, 250.00),
(11, 30.00, 35.00),
(12, 12.00, 15.00),
(13, 8.00, 10.00),
(14, 110.00, 120.00),
(15, 190.00, 200.00);

INSERT INTO auditoria_ventas (venta_id, usuario) VALUES
(1, 'admin1'),
(2, 'admin2'),
(3, 'admin3'),
(4, 'admin4'),
(5, 'admin5'),
(6, 'admin6'),
(7, 'admin7'),
(8, 'admin8'),
(9, 'admin9'),
(10, 'admin10'),
(11, 'admin11'),
(12, 'admin12'),
(13, 'admin13'),
(14, 'admin14'),
(15, 'admin15');

INSERT INTO alertas_stock (producto_id, nombre_producto, mensaje) VALUES
(1, 'Producto 1', 'El stock de Producto 1 está bajo'),
(2, 'Producto 2', 'El stock de Producto 2 está bajo'),
(3, 'Producto 3', 'El stock de Producto 3 está bajo'),
(4, 'Producto 4', 'El stock de Producto 4 está bajo'),
(5, 'Producto 5', 'El stock de Producto 5 está bajo'),
(6, 'Producto 6', 'El stock de Producto 6 está bajo'),
(7, 'Producto 7', 'El stock de Producto 7 está bajo'),
(8, 'Producto 8', 'El stock de Producto 8 está bajo'),
(9, 'Producto 9', 'El stock de Producto 9 está bajo'),
(10, 'Producto 10', 'El stock de Producto 10 está bajo'),
(11, 'Producto 11', 'El stock de Producto 11 está bajo'),
(12, 'Producto 12', 'El stock de Producto 12 está bajo'),
(13, 'Producto 13', 'El stock de Producto 13 está bajo'),
(14, 'Producto 14', 'El stock de Producto 14 está bajo'),
(15, 'Producto 15', 'El stock de Producto 15 está bajo');

-- Agregue inserts de prueba en algunas cosas para probar casos y los deje ahi
