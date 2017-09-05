CREATE EXTENSION postgres_fdw;

CREATE SERVER src_srv FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'bodega', port '5432');

CREATE USER MAPPING FOR postgres SERVER src_srv OPTIONS ( user 'postgres', password 'postgres' );

CREATE SCHEMA imported;
IMPORT FOREIGN SCHEMA public FROM SERVER src_srv INTO imported;


CREATE SEQUENCE public.sucursal_851860984_nro_transferencia_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE public.sucursal_851860984_nro_transferencia_seq
  OWNER TO postgres;

--colocar el valor inicial
CREATE SEQUENCE public.sucursal_851860984_nro_factura_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE public.sucursal_851860984_nro_factura_seq
  OWNER TO postgres;

--insert categorias

INSERT INTO public.categorias(
            id, nombre, created_at, updated_at, comision)
SELECT id, nombre, created_at, updated_at, 0
  FROM imported.categorias;

SELECT setval('categorias_id_seq', max_val) from (select max(id) as max_val from categorias) as t;

--insert productos

truncate table public.productos CASCADE ;

INSERT INTO public.productos(
            id, codigo_barra, descripcion, unidad, margen, created_at, updated_at,
            iva, precio_compra, precio, stock_minimo, precio_promedio, activo,
            pack, cantidad, producto_id, moneda_id, servicio)
SELECT id, codigo_barra, descripcion, unidad, margen, created_at, updated_at,
  iva, precio_compra, precio, stock_minimo, precio_promedio, activo, 
  false as pack, 0 as cantidad, null as producto_id, 951786924 as moneda_id, false as servicio
  FROM imported.productos;

SELECT setval('productos_id_seq', max_val) from (select max(id) as max_val from productos) as t;

-- categorias productos
INSERT INTO public.categorias_productos(
            id, producto_id, categoria_id, created_at, updated_at)
SELECT id, producto_id, categoria_id, created_at, updated_at
  FROM imported.categorias_productos;

SELECT setval('categorias_productos_id_seq', max_val) from (select max(id) as max_val from categorias_productos) as t;

-- promociones
INSERT INTO public.promociones(
            id, descripcion, fecha_vigencia_desde, fecha_vigencia_hasta, 
            porcentaje_descuento, created_at, updated_at, permanente, exclusiva, 
            cantidad_general, tarjeta_id, con_tarjeta)
SELECT id, descripcion, fecha_vigencia_desde, fecha_vigencia_hasta, 
porcentaje_descuento, created_at, updated_at, false, false, 0, null, false
  FROM imported.promociones;

SELECT setval('promociones_id_seq', max_val) from (select max(id) as max_val from promociones) as t;

-- promocion productos
INSERT INTO public.promocion_productos(
            id, cantidad, created_at, updated_at, promocion_id, producto_id, 
            precio_descuento, porcentaje, moneda_id, caliente)
SELECT id, cantidad, created_at, updated_at, promocion_id, producto_id,
  precio_descuento, porcentaje, 951786924 as moneda_id, caliente
  FROM imported.promocion_productos;

SELECT setval('promocion_productos_id_seq', max_val) from (select max(id) as max_val from promocion_productos) as t;


-- productos depositos
INSERT INTO public.producto_depositos(
            id, producto_id, deposito_id, existencia, created_at, updated_at)
SELECT id, producto_id, 430958227 as deposito_id, existencia, created_at, updated_at
  FROM imported.producto_sucursales;

SELECT setval('producto_depositos_id_seq', max_val) from (select max(id) as max_val from producto_depositos) as t;

-- inventarios
INSERT INTO public.inventarios(
            id, fecha_inicio, fecha_fin, descripcion, created_at, updated_at, 
            usuario_id, deposito_id, control, procesado)
SELECT id, fecha_inicio, fecha_fin, descripcion, created_at, updated_at, 
usuario_id, 430958227 as deposito_id, false as control, true as procesado
  FROM imported.inventarios;

SELECT setval('inventarios_id_seq', max_val) from (select max(id) as max_val from inventarios) as t;


--inventarios productos
INSERT INTO public.inventario_productos(
            id, existencia, created_at, updated_at, inventario_id, producto_id, 
            existencia_previa)
SELECT id, existencia, created_at, updated_at, inventario_id, producto_id, 
0 as existencia_previa
  FROM imported.inventario_productos;

SELECT setval('inventario_productos_id_seq', max_val) from (select max(id) as max_val from inventario_productos) as t;

-- proveedores
INSERT INTO public.proveedores(
            id, razon_social, ruc, direccion, telefono, email, persona_contacto, 
            telefono_contacto, created_at, updated_at)
SELECT id, razon_social, ruc, direccion, telefono, email, persona_contacto, 
telefono_contacto, created_at, updated_at
  FROM imported.proveedores;

SELECT setval('proveedores_id_seq', max_val) from (select max(id) as max_val from proveedores) as t;


--compras
INSERT INTO public.compras(
            id, sucursal_id, proveedor_id, total, iva10, iva5, credito, pagado, 
            cantidad_cuotas, nro_factura, created_at, updated_at, tipo_credito_id, 
            fecha_registro, deuda, deposito_id, retencioniva, moneda_id, 
            cotizacion_id, monto_cotizacion)
SELECT id, 851860984 as sucursal_id, proveedor_id, total, iva10, iva5, credito, pagado, 
cantidad_cuotas, nro_factura, created_at, updated_at, tipo_credito_id, 
fecha_registro, deuda, 430958227 as deposito_id, 0,951786924 as moneda_id,
951786924 as cotizacion_id, 1 as monto_cotizacion
  FROM imported.compras;

SELECT setval('compras_id_seq', max_val) from (select max(id) as max_val from compras) as t;

--compras detalles
INSERT INTO public.compra_detalles(
            id, compra_id, producto_id, cantidad, precio_compra, created_at, 
            updated_at)
SELECT id, compra_id, producto_id, cantidad, precio_compra, created_at, 
updated_at
  FROM imported.compra_detalles;

SELECT setval('compra_detalles_id_seq', max_val) from (select max(id) as max_val from compra_detalles) as t;

-- precios
INSERT INTO public.precios(
            id, fecha, precio_compra, compra_detalle_id, created_at, updated_at)
SELECT id, fecha, precio_compra, compra_detalle_id, created_at, updated_at
  FROM imported.precios;

SELECT setval('precios_id_seq', max_val) from (select max(id) as max_val from precios) as t;

-- ventas
INSERT INTO public.ventas(
            id, cliente_id, descuento, total, iva10, iva5, credito, pagado, 
            nro_factura, cantidad_cuotas, created_at, updated_at, fecha_registro, 
            tipo_credito_id, sucursal_id, deuda, ganancia, anulado,
            uso_interno, descuento_redondeo, tarjeta_credito, 
            vendedor_id, moneda_id, medio_pago_id, 
            porcentaje_recargo, usuario_id)
SELECT id, cliente_id, descuento, total, iva10, iva5, credito, pagado, 
nro_factura, cantidad_cuotas, created_at, updated_at, fecha_registro, 
tipo_credito_id, 851860984 as sucursal_id, deuda, ganancia, false as anulado, 
false as uso_interno, 0 as descuento_redondeo, false as tarjeta_credito,
857336801 as vendedor_id, 951786924 as moneda_id, 349699778 as medio_pago_id, 
null as porcentaje_recargo, 83469602 as usuario_id
  FROM imported.ventas;

SELECT setval('ventas_id_seq', max_val) from (select max(id) as max_val from ventas) as t;
SELECT setval('sucursal_851860984_nro_factura_seq', max_val) from (select max(nro_factura::bigint) as max_val from ventas) as t;

--ventas detalle
INSERT INTO public.venta_detalles(
            id, venta_id, producto_id, cantidad, precio, created_at, updated_at, 
            descuento, caliente, promocion_id, cotizacion_id, monto_cotizacion, 
            moneda_id)
SELECT id, venta_id, producto_id, cantidad, precio, created_at, updated_at, 
descuento, caliente, promocion_id as promocion_id, 951786924 as cotizacion_id, 1 as monto_cotizacion,
951786924 as moneda_id
  FROM imported.venta_detalles;

update  public.venta_detalles 
set promocion_id = null
from (select det.id as detalle_id from
  public.venta_detalles det
       LEFT JOIN public.promociones p
              ON det.promocion_id = p.id 
  WHERE  p.id IS NULL) ids
where id = ids.detalle_id;

SELECT setval('venta_detalles_id_seq', max_val) from (select max(id) as max_val from venta_detalles) as t;

UPDATE public.usuarios
   SET  password_digest=old_password_digest
FROM (select password_digest as old_password_digest from imported.usuarios u WHERE u.username = 'administrador') t
 WHERE username = 'administrador';


update promociones set por_unidad = false;


update categorias_productos set categoria_id = 851718665 where categoria_id = 851718664;
delete from categorias where id = 851718664;

update categorias_productos set categoria_id = 851718667 where categoria_id = 851718666;
delete from categorias where id = 851718666;

DELETE FROM categorias_productos USING categorias_productos alias 
  WHERE categorias_productos.categoria_id = alias.categoria_id AND categorias_productos.producto_id = alias.producto_id AND
    categorias_productos.id < alias.id;

DROP USER MAPPING FOR postgres SERVER src_srv;
DROP SERVER src_srv CASCADE;
DROP SCHEMA imported;
