# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'API'
  inflect.irregular 'venta', 'ventas'
  inflect.irregular 'cuota', 'cuotas'
  inflect.irregular 'curso', 'cursos'
  inflect.irregular 'viaje', 'viajes'
  inflect.irregular 'curso_colaborador', 'curso_colaboradores'
  inflect.irregular 'viaje_colaborador', 'viaje_colaboradores'
  inflect.irregular 'categoria', 'categorias'
  inflect.irregular 'promocion', 'promociones'
  inflect.irregular 'proveedor', 'proveedores'
  inflect.irregular 'empresa', 'empresas'
  inflect.irregular 'produccion', 'producciones'
  inflect.irregular 'produccion_detalle', 'produccion_detalles'
  inflect.irregular 'sucursal', 'sucursales'
  inflect.irregular 'compra', 'compras'
  inflect.irregular 'venta_detalle', 'venta_detalles'
  inflect.irregular 'producto_detalle', 'producto_detalles'
  inflect.irregular 'operacion_caja', 'operaciones_caja'
  inflect.irregular 'flujo_caja', 'flujo_cajas'
  inflect.irregular 'tipo_credito', 'tipo_creditos'
  inflect.irregular 'categoria_producto', 'categorias_productos'
  inflect.irregular 'rol', 'roles'
  inflect.irregular 'contenedor', 'contenedores'
  inflect.irregular 'recurso', 'recursos'
  inflect.irregular 'precio', 'precios'
  inflect.irregular 'producto_sucursal', 'producto_sucursales'
  inflect.irregular 'usuario_surcursal', 'usuarios_sucursales'
  inflect.irregular 'compra_cuota', 'compra_cuotas'
  inflect.irregular 'campanha_sponsor', 'campanha_sponsors'
  inflect.irregular 'sucursal_usuario', 'sucursales_usuarios'
  inflect.irregular 'registro_produccion', 'registros_produccion'
  inflect.irregular 'categoria_cliente','categoria_clientes'
  inflect.irregular 'categoria_cliente_promocion','categoria_clientes_promociones'
  inflect.irregular 'transferencia_deposito','transferencias_deposito'
  inflect.irregular 'inventario','inventarios'
  inflect.irregular 'parametros_empresa','parametros_empresas'
  inflect.irregular 'vendedor','vendedores'
  inflect.irregular 'caja_impresion','cajas_impresion'
  inflect.irregular 'ajuste_inventario', 'ajuste_inventarios'
  inflect.irregular 'ajuste_inventario_detalle', 'ajuste_inventario_detalles'
  inflect.irregular 'moneda', 'monedas'
  inflect.irregular 'cuenta', 'cuentas'
  inflect.irregular 'compra_medio', 'compra_medios'
  inflect.irregular 'cotizacion', 'cotizaciones'
  inflect.irregular 'medio_pago', 'medio_pagos'
  inflect.irregular 'tipo_salida', 'tipo_salidas'
  inflect.irregular 'tarjeta', 'tarjetas'
  inflect.irregular 'recargo', 'recargos'
  inflect.irregular 'sucursal_vendedor', 'sucursales_vendedores'
  inflect.irregular 'tipo_movimiento', 'tipos_movimiento'
  inflect.irregular 'tipo_producto', 'tipo_productos'
  inflect.irregular 'tipo_operacion', 'tipos_operacion'
  inflect.irregular 'tipo_operacion_detalle', 'tipo_operacion_detalles'
  inflect.irregular 'operacion', 'operaciones'
  inflect.irregular 'tipo_caja', 'tipo_cajas'
  inflect.irregular 'movimiento', 'movimientos'
  inflect.irregular 'persona', 'personas'
  inflect.irregular 'inventario_lote', 'inventario_lotes'
  inflect.irregular 'motivos_inventario', 'motivos_inventarios'
  inflect.irregular 'categoria_operacion', 'categoria_operaciones'
  inflect.irregular 'evento', 'eventos'
  inflect.irregular 'lote', 'lotes'
  inflect.irregular 'lote_deposito', 'lote_depositos'
  inflect.irregular 'especialidad', 'especialidades'
  inflect.irregular 'calificacion', 'calificaciones'
  inflect.irregular 'ciudad', 'ciudades'
  inflect.irregular 'tipo_documento', 'tipo_documentos'
  inflect.irregular 'documento', 'documentos'
  inflect.irregular 'referencia', 'referencias'
  inflect.irregular 'vinculo_familiar', 'vinculo_familiares'
  inflect.irregular 'ingreso_familiar', 'ingreso_familiares'
  inflect.irregular 'conyugue', 'conyugues'
  inflect.irregular 'tipo_campanha', 'tipos_campanhas'
  inflect.irregular 'tipo_colaborador', 'tipo_colaboradores'
  inflect.irregular 'campanha', 'campanhas'
  inflect.irregular 'colaborador', 'colaboradores'
  inflect.irregular 'consulta', 'consultas'
  inflect.irregular 'consulta_detalle', 'consulta_detalles'
  inflect.irregular 'campanha_colaborador', 'campanhas_colaboradores'
  inflect.irregular 'sponsor', 'sponsors'
  inflect.irregular 'tipo_sponsor', 'tipo_sponsors'
  inflect.irregular 'contacto', 'contactos'
  inflect.irregular 'contacto_detalle', 'contacto_detalles'
  inflect.irregular 'tipo_contacto', 'tipo_contactos'
  inflect.irregular 'ficha_fonoaudiologia', 'fichas_fonoaudiologia';
  inflect.irregular 'ficha_cirugia', 'fichas_cirugia';
  inflect.irregular 'ficha_odontologia', 'fichas_odontologia';
  inflect.irregular 'ficha_psicologia', 'fichas_psicologia';
  inflect.irregular 'ficha_nutricion', 'fichas_nutricion'
  inflect.irregular 'proyeccion', 'proyecciones';
  inflect.irregular 'candidatura', 'candidaturas';
end