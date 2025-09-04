-- Triggers (triggers.sql)

1. Actualización automática del stock en ventas

> Cada vez que se inserte un registro en la tabla `ventas_detalle`, el sistema debe **descontar automáticamente** la cantidad de productos vendidos del campo `stock` de la tabla `productos`.

- Si el stock es insuficiente, el trigger debe evitar la operación y lanzar un error con `RAISE EXCEPTION`.

Solucion: 

CREATE OR REPLACE FUNCTION trg_descuento_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_stock INTEGER;
BEGIN
  SELECT stock
  INTO v_stock
  FROM productos
  WHERE id = NEW.producto_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'El producto % no existe.', NEW.producto_id;
  END IF;

  IF v_stock < NEW.cantidad THEN
    RAISE EXCEPTION 'Stock insuficiente para producto %. Disponible: %, solicitado: %.',
      NEW.producto_id, v_stock, NEW.cantidad;
  END IF;

  UPDATE productos
  SET stock = stock - NEW.cantidad
  WHERE id = NEW.producto_id;

  RETURN NEW;
END;
$$;

-- Llamado del trigger

CREATE TRIGGER ventas_detalle_descuenta_stock
BEFORE INSERT ON ventas_detalle
FOR EACH ROW
EXECUTE FUNCTION trg_descuento_stock();

2. Registro de auditoría de ventas

> Al insertar una nueva venta en la tabla `ventas`, se debe generar automáticamente un registro en la tabla `auditoria_ventas` indicando:

- ID de la venta
- Fecha y hora del registro
- Usuario que realizó la transacción (usando `current_user`)

Solucion:

CREATE OR REPLACE FUNCTION trg_auditoria_ventas()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO auditoria_ventas (venta_id, usuario)
  VALUES (NEW.id, current_user);
  RETURN NEW;
END;
$$;

-- Llamado de trigger

CREATE TRIGGER ventas_auditoria
AFTER INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION trg_auditoria_ventas();

3. Notificación de productos agotados

> Cuando el stock de un producto llegue a **0** después de una actualización, se debe registrar en la tabla `alertas_stock` un mensaje indicando:

- ID del producto
- Nombre del producto
- Fecha en la que se agotó

Solucion:

CREATE OR REPLACE FUNCTION trg_alerta_stock_agotado()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.stock = 0 AND OLD.stock > 0 THEN
    INSERT INTO alertas_stock (producto_id, nombre_producto, mensaje)
    VALUES (
      NEW.id,
      NEW.nombre,
      'El producto se ha agotado'
    );
  END IF;
  RETURN NEW;
END;
$$;

-- llamado trigger

CREATE TRIGGER productos_alerta_stock
AFTER UPDATE OF stock ON productos
FOR EACH ROW
EXECUTE FUNCTION trg_alerta_stock_agotado();

4. Validación de datos en clientes

> Antes de insertar un nuevo cliente en la tabla `clientes`, se debe validar que el campo `correo` no esté vacío y que no exista ya en la base de datos (unicidad).

- Si la validación falla, se debe impedir la inserción y lanzar un mensaje de error.

Solucion:

CREATE OR REPLACE FUNCTION trg_validar_cliente()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.correo IS NULL OR NEW.correo = '' THEN
    RAISE EXCEPTION 'El correo no puede estar vacío.';
  END IF;

  IF EXISTS (SELECT 1 FROM clientes WHERE correo = NEW.correo) THEN
    RAISE EXCEPTION 'El correo ya existe.';
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER clientes_validacion
BEFORE INSERT ON clientes
FOR EACH ROW
EXECUTE FUNCTION trg_validar_cliente();

5. Historial de cambios de precio

> Cada vez que se actualice el campo `precio` en la tabla `productos`, el trigger debe guardar el valor anterior y el nuevo en una tabla `historial_precios` con la fecha y hora de la modificación.

Solucion:

CREATE OR REPLACE FUNCTION trg_historial_precios()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.precio <> OLD.precio THEN
    INSERT INTO historial_precios (producto_id, precio_anterior, precio_nuevo)
    VALUES (OLD.id, OLD.precio, NEW.precio);
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER productos_historial_precios
AFTER UPDATE OF precio ON productos
FOR EACH ROW
EXECUTE FUNCTION trg_historial_precios();

6. Bloqueo de eliminación de proveedores con productos activos

> Antes de eliminar un proveedor en la tabla `proveedores`, se debe verificar si existen productos asociados a dicho proveedor.

- Si existen productos, se debe bloquear la eliminación y notificar con un error.

Solucion:

CREATE OR REPLACE FUNCTION trg_bloquear_eliminacion_proveedor()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM productos WHERE proveedor_id = OLD.id) THEN
    RAISE EXCEPTION 'No se puede eliminar el proveedor %, tiene productos asociados.', OLD.id;
  END IF;
  RETURN OLD;
END;
$$;

CREATE TRIGGER proveedores_bloqueo_eliminacion
BEFORE DELETE ON proveedores
FOR EACH ROW
EXECUTE FUNCTION trg_bloquear_eliminacion_proveedor();

7. Control de fechas en ventas

> Antes de insertar un registro en la tabla `ventas`, el trigger debe validar que la fecha de la venta no sea mayor a la fecha actual (`NOW()`).

- Si se detecta una fecha futura, la inserción debe ser cancelada.

Solucion: 

CREATE OR REPLACE FUNCTION trg_validar_fecha_venta()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.fecha > NOW() THEN
    RAISE EXCEPTION 'La fecha de la venta no puede ser futura.';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER ventas_validar_fecha
BEFORE INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION trg_validar_fecha_venta();

8. Registro de clientes inactivos

> Si un cliente no ha realizado compras en los últimos 6 meses y se intenta registrar una nueva venta a su nombre, el trigger debe actualizar su estado en la tabla `clientes` a **"activo"**.

Solucion:

CREATE OR REPLACE FUNCTION trg_reactivar_cliente()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM clientes c
    WHERE c.id = NEW.cliente_id
      AND c.estado = 'inactivo'
      AND NOT EXISTS (
        SELECT 1
        FROM ventas v
        WHERE v.cliente_id = c.id
          AND v.fecha >= NOW() - INTERVAL '6 months'
      )
  ) THEN
    UPDATE clientes
    SET estado = 'activo'
    WHERE id = NEW.cliente_id;
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER ventas_reactivar_cliente
BEFORE INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION trg_reactivar_cliente();


