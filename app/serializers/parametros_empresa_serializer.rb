class ParametrosEmpresaSerializer < ActiveModel::Serializer
  attributes  :id, :imei_en_venta_detalle, :soporta_sucursales, :soporta_multiempresa,
              :vendedor_en_venta, :tarjeta_credito_en_venta, :soporta_caja_impresion, :retencioniva,
              :soporta_uso_interno, :soporta_ajuste_inventario, :soporta_multimoneda, :ctrl_inventario_cantidad,
              :ctrl_inventario_set_existencia, :recargo_precio_venta, :imprimir_remision, :soporta_cajas,
              :soporta_impresion_recibo, :soporta_parametro_caliente, :monto_alivio,
              :soporta_produccion, :soporta_garante_venta, :soporta_impresion_factura_venta, :max_detalles_ventas, :cierre_automatico_caja,:permite_promociones

  has_one :empresa, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
  has_one :moneda_base, embed: :id, include: false
  has_one :sucursal_default, embed: :id, include: false

end
