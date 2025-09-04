-- Procedimientos Almacenados (procedureAndFunctions.sql)

1. Un procedimiento almacenado para registrar una venta, validar que el cliente exista, verificar que el stock sea suficiente antes de procesar la venta, si no hay stock suficiente, notificar por medio de un mensaje en consola usando RAISE, si hay stock, se realiza el registro de la venta.

CREATE OR REPLACE PROCEDURE registrar_venta(
  p_cliente_id  INTEGER,
  p_producto_id INTEGER,
  p_cantidad    INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_venta_id INTEGER;
  v_stock    INTEGER;
  v_precio   NUMERIC(12,2);
BEGIN
  IF NOT EXISTS (SELECT 1 FROM clientes WHERE id = p_cliente_id) THEN
    RAISE EXCEPTION 'El cliente % no existe.', p_cliente_id;
  END IF;

  SELECT stock, precio INTO v_stock, v_precio
  FROM productos
  WHERE id = p_producto_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'El producto % no existe.', p_producto_id;
  END IF;

  IF v_stock < p_cantidad THEN
    RAISE EXCEPTION 'Stock insuficiente para producto %. Disponible: %, solicitado: %.',
      p_producto_id, v_stock, p_cantidad;
  END IF;

  INSERT INTO ventas (cliente_id)
  VALUES (p_cliente_id)
  RETURNING id INTO v_venta_id;

  UPDATE productos
  SET stock = stock - p_cantidad
  WHERE id = p_producto_id;

  INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario)
  VALUES (v_venta_id, p_producto_id, p_cantidad, v_precio);
END;
$$;

CALL registrar_venta(1,2,3);
