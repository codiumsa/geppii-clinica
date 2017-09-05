#Parametros actuales:
# => id 								serial NOT NULL,
# => imei_en_venta_detalle 				boolean,
# => empresa_id 						integer,
# => soporta_sucursales 				boolean DEFAULT false,
# => soporta_multiempresa 				boolean DEFAULT false,
# => vendedor_en_venta 					boolean,
# => tarjeta_credito_en_venta 			boolean,
# => soporta_caja_impresion 			boolean,
# => retencioniva 						integer,
# => soporta_uso_interno 				boolean,
# => soporta_ajuste_inventario 			boolean,
# => soporta_multimoneda 				boolean,
# => moneda_id 							integer,
# => moneda_base_id 					integer,
# => default_empresa 					boolean,
# => recargo_precio_venta 				boolean,
# => ctrl_inventario_set_existencia		boolean,
# => ctrl_inventario_cantidad			boolean,
# => soporta_cajas                      boolean,
# => soporta_medicamentos               boolean,


class ParametrosEmpresa < ActiveRecord::Base
	belongs_to :empresa
	belongs_to :moneda
	belongs_to :moneda_base, class_name: 'Moneda'
    belongs_to :sucursal_default, class_name: 'Sucursal'
  
    
	scope :unpaged, -> { order("id") }

	scope :by_empresa, -> empresa_id { where("empresa_id = ?", empresa_id) }
  	scope :by_empresa_codigo, -> empresa_codigo {joins(:empresa).where("empresas.codigo ilike ?", "%#{empresa_codigo}%" )}
	scope :by_sucursal, -> sucursal_id { where("empresa_id in (select empresa_id from sucursales where id = ?)", sucursal_id)}
    scope :by_soporta_caja_impresion, -> soporta_caja_impresion { where( "soporta_caja_impresion = ?", soporta_caja_impresion)}
    scope :by_soporta_medicamentos, -> soporta_medicamentos { where( "soporta_medicamentos = ?", soporta_medicamentos)}
    scope :by_soporta_ajuste_inventario, -> soporta_ajuste_inventario { where( "soporta_ajuste_inventario = ?", soporta_ajuste_inventario)}
    scope :by_soporta_sucursales, -> soporta_sucursales { where( "soporta_sucursales = ?", soporta_sucursales)}
    scope :by_vendedor_en_venta, -> vendedor_en_venta { where( "vendedor_en_venta = ?", vendedor_en_venta)}
    scope :by_soporta_multimoneda, -> soporta_multimoneda { where( "soporta_multimoneda = ?", soporta_multimoneda)}
    scope :by_imei_en_venta_detalle, -> imei_en_venta_detalle { where( "imei_en_venta_detalle = ?", imei_en_venta_detalle)}
    scope :by_soporta_uso_interno, -> soporta_uso_interno { where( "soporta_uso_interno = ?", soporta_uso_interno)}
    scope :by_ctrl_inventario_set_existencia, -> ctrl_inventario_set_existencia { where( "ctrl_inventario_set_existencia = ?", ctrl_inventario_set_existencia)}
    scope :by_ctrl_inventario_cantidad, -> ctrl_inventario_cantidad { where( "ctrl_inventario_cantidad = ?", ctrl_inventario_cantidad)}
    scope :by_imprimir_remision, -> imprimir_remision { where( "imprimir_remision = ?", imprimir_remision)} 
    scope :default_empresa, -> { where("default_empresa = true") }
    
	scope :by_all_attributes, -> value { joins(:empresa).
		where("empresa.nombre ilike ? " , "%#{value}%").references(:empresas)
	}
	
end
