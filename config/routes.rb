Bodega::Application.routes.draw do
  #match '*path', :controller => 'application', :action => 'handle_options_request', via: :options
  resources :tipos_movimiento, :controller => "ember", :action => 'start'
  resources :clientes, :controller => "ember", :action => 'start'
  resources :usuarios, :controller => "ember", :action => 'start'
  resources :ventaCuotas, :controller => "ember", :action => 'start'
  resources :ventaDetalles, :controller => "ember", :action => 'start'
  resources :ventaMedios, :controller => "ember", :action => 'start'
  resources :campanhaSponsors, :controller => "ember", :action => 'start'
  resources :productoDetalles, :controller => "ember", :action => 'start'
  resources :ventas, :controller => "ember", :action => 'start'
  resources :productos, :controller => "ember", :action => 'start'
  resources :produccionDetalles, :controller => "ember", :action => 'start'
  resources :apiKeys, :controller => "ember", :action => 'start'
  resources :cajas, :controller => "ember", :action => 'start'
  resources :cursos, :controller => "ember", :action => 'start'
  resources :viajes, :controller => "ember", :action => 'start'
  resources :cursoColaboradores, :controller => "ember", :action => 'start'
  resources :viajeColaboradores, :controller => "ember", :action => 'start'
  resources :empresas, :controller => "ember", :action => 'start'
  resources :sucursales, :controller => "ember", :action => 'start'
  resources :categorias, :controller => "ember", :action => 'start'
  resources :categoriasProductos, :controller => "ember", :action => 'start'
  resources :promociones, :controller => "ember", :action => 'start'
  resources :promocionProductos, :controller => "ember", :action => 'start'
  resources :proveedores, :controller => "ember", :action => 'start'
  resources :compraDetalles, :controller => "ember", :action => 'start'
  resources :promociones, :controller => "ember", :action => 'start'
  resources :operacionesCaja, :controller => "ember", :action => 'start'
  resources :sesionCajas, :controller => "ember", :action => 'start'
  resources :tipoCreditos, :controller => "ember", :action => 'start'
  resources :precios, :controller => "ember", :action => 'start'
  resources :recursosRoles, :controller => "ember", :action => 'start'
  resources :rolesUsuarios, :controller => "ember", :action => 'start'
  resources :motivosInventarios, :controller => "ember", :action => 'start'
  resources :recursos, :controller => "ember", :action => 'start'
  resources :consultorios, :controller => "ember", :action => 'start'
  resources :roles, :controller => "ember", :action => 'start'
  resources :compras, :controller => "ember", :action => 'start'
  resources :sucursalUsuarios, :controller => "ember", :action => 'start'
  resources :compraCuotas, :controller => "ember", :action => 'start'
  resources :registrosProduccion, :controller => "ember", :action => 'start'
  resources :procesoDetalles, :controller => "ember", :action => 'start'
  resources :procesos, :controller => "ember", :action => 'start'
  resources :producciones, :controller => "ember", :action => 'start'
  resources :produccionDetalles, :controller => "ember", :action => 'start'
  resources :catclientes, :controller => "ember", :action => 'start'
  resources :categoriaClientes, :controller => "ember", :action => 'start'
  resources :categoriaClientesPromociones, :controller => "ember", :action => 'start'
  resources :depositos, :controller => "ember", :action => 'start'
  resources :loteDepositos, :controller => "ember", :action => 'start'
  resources :transferenciasDeposito, :controller => "ember", :action => 'start'
  resources :parametrosEmpresas, :controller => "ember", :action => 'start'
  resources :vendedores, :controller => "ember", :action => 'start'
  resources :cajasImpresion, :controller => "ember", :action => 'start'
  resources :cotizaciones, :controller => "ember", :action => 'start'
  resources :monedas, :controller => "ember", :action => 'start'
  resources :tarjetas, :controller => "ember", :action => 'start'
  resources :medio_pagos, :controller => "ember", :action => 'start'
  resources :medioPagos, :controller => "ember", :action => 'start'
  resources :recargos, :controller => "ember", :action => 'start'
  resources :cuentas, :controller => "ember", :action => 'start'
  resources :compraMedios, :controller => "ember", :action => 'start'
  resources :sucursalesVendedores, :controller => "ember", :action => 'start'
  resources :operaciones, :controller => "ember", :action => 'start'
  resources :tipos_operacion, :controller => "ember", :action => 'start'
  resources :tipo_operacion_detalles, :controller => "ember", :action => 'start'
  resources :tipos_movimiento, :controller => "ember", :action => 'start'
  resources :tipo_productos, :controller => "ember", :action => 'start'
  resources :lotes, :controller => "ember", :action => 'start'
  resources :contenedores, :controller => "ember", :action => 'start'
  resources :inventarios, :controller => "ember", :action => 'start'
  resources :controlInventarios, :controller => "ember", :action => 'start'
  resources :ajusteInventarioDetalles, :controller => "ember", :action => 'start'
  resources :ajusteInventarios, :controller => "ember", :action => 'start'
  resources :inventarioLotes, :controller => "ember", :action => 'start'
  resources :movimientos, :controller => "ember", :action => 'start'
  resources :categoriaOperaciones, :controller => "ember", :action => 'start'
  resources :inventario_lotes, :controller => "ember", :action => 'start'
  resources :especialidades, :controller => "ember", :action => 'start'
  resources :tipoProductos, :controller => "ember", :action => 'start'
  resources :tipoSalidas, :controller => "ember", :action => 'start'
  resources :tipo_salidas, :controller => "ember", :action => 'start'
  resources :pacientes, :controller => "ember", :action => 'start'
  resources :tratamientos,:controller => "ember", :action => 'start'
  resources :calificaciones, :controller => "ember", :action => 'start'
  resources :ingreso_familiares, :controller => "ember", :action => 'start'
  resources :vinculo_familiares, :controller => "ember", :action => 'start'
  resources :referencias, :controller => "ember", :action => 'start'
  resources :documentos, :controller => "ember", :action => 'start'
  resources :tipo_documentos, :controller => "ember", :action => 'start'
  resources :personas, :controller => "ember", :action => 'start'
  resources :conyugues, :controller => "ember", :action => 'start'
  resources :fichasPsicologia, :controller => "ember", :action => 'start'
  resources :fichas_psicologia, :controller => "ember", :action => 'start'
  resources :fichas_fonoaudiologia, :controller => "ember", :action => 'start'
  resources :fichasFonoaudiologia, :controller => "ember", :action => 'start'
  resources :fichasOdontologia, :controller => "ember", :action => 'start'
  resources :fichas_odontologia, :controller => "ember", :action => 'start'
  resources :fichas_cirugia, :controller => "ember", :action => 'start'
  resources :fichasCirugia, :controller => "ember", :action => 'start'
  #TODO: Verificar si es _ o camelizado
  resources :tipo_campanhas, :controller => "ember", :action => 'start'
  resources :campanhas, :controller => "ember", :action => 'start'
  resources :colaboradores, :controller => "ember", :action => 'start'
  resources :tipo_colaboradores , :controller => "ember", :action => 'start'
  resources :tipoColaboradores, :controller => "ember", :action => 'start'
  resources :consultas, :controller => "ember", :action => 'start'
  resources :consultaDetalles, :controller => "ember", :action => 'start'
  resources :campanhas_colaboradores, :controller => "ember", :action => 'start'
  resources :tipoContactos, :controller => "ember", :action => 'start'
  resources :contactos, :controller => "ember", :action => 'start'
  resources :contactoDetalles, :controller => "ember", :action => 'start'
  resources :sponsors, :controller => "ember", :action => 'start'
  resources :tipo_sponsors, :controller => "ember", :action => 'start'
  resources :fichas_nutricion, :controller => "ember", :action => 'start'
  resources :fichasNutricion, :controller => "ember", :action => 'start'
  resources :candidaturas, :controller => "ember", :action => 'start'
  get "/sessions/new" => "ember#start"
  get "/sessions/destroy" => "ember#start"
  get "/reporte_compras" => "ember#start"
  get "/reporte_informacion_voluntarios" => "ember#start"
  get "/reporte_participacion_voluntarios" => "ember#start"
  get "/reporte_pacientes_nuevos" => "ember#start"
  get "/reporte_candidatura_tratamientos" => "ember#start"
  get "/reporte_cantidad_tratamientos" => "ember#start"
  get "/reporte_cantidad_consultas" => "ember#start"
  get "/reporte_asistencia_pacientes_consultas" => "ember#start"
  get "/reporte_cantidad_pacientes_atendidos" => "ember#start"
  get "/reporte_ajustes_inventario" => "ember#start"
  get "/reporte_viajes" => "ember#start"
  get "/reporte_cursos" => "ember#start"
  get "/reporte_pacientes" => "ember#start"
  get "/reporte_patrocinadores" => "ember#start"
  get "/reporte_listado_voluntarios" => "ember#start"
  get "/fichas" => "ember#start"
  get "/reporte_valoracion_inventario" => "ember#start"
  get "/reporte_existencia_inventario" => "ember#start"
  get "/reporte_cuentas_pagar" => "ember#start"
  get "/reporte_cuentas_cobrar" => "ember#start"
  get "/reporte_ventas" => "ember#start"
  get "/reporte_sesion_cajas" => "ember#start"
  get "/reporte_legajo_paciente" => "ember#start"
  get "/reporte_inventarios" => "ember#start"
  get "/reporte_movimiento_venta" => "ember#start"
  get "/reporte_ganancias" => "ember#start"
  get "/reporte_producto_deposito" => "ember#start"
  get "/reporte_producto_lote" => "ember#start"
  get "/reporte_producto_recargo" => "ember#start"
  get "/reporte_movimiento_caja" => "ember#start"
  get "/reporte_final_caja" => "ember#start"
  get "/reporte_caja_medio_pago" => "ember#start"
  get "/reporte_caja_usuario" => "ember#start"
  get "/reporte_precios_venta" => "ember#start"
  get "/reporte_ventas_medio_pago" => "ember#start"
  get "/reporte_salida_campanha" => "ember#start"
  get "/reporte_extracto_cliente" => "ember#start"
  get "/ventas/:id/duplicar" => "ember#start"
  get "/ventas/:id/cuotas" => "ember#start"
  get "/ventas/:id/cuotas/:id_cuota/edit" => "ember#start"
  get "/compras/:id/cuotas" => "ember#start"
  get "/compras/:id/cuotas/:id_cuota/edit" => "ember#start"
  get "/ventas/:id/pagos" => "ember#start"
  get "/ventas/:id/pagos/new" => "ember#start"
  get "/ventas/:id/pago/:pago_id" => "ember#start"
  get "/compras/:id/pagos" => "ember#start"
  get "/compras/:id/pagos/new" => "ember#start"
  get "/compras/:id/pago/:pago_id" => "ember#start"
  get "/images/productos/:id/small.png" => "ember#start"
  get "/tipos_operacion" => "ember#start"
  get "/tipos_movimiento" =>  "ember#start"
  get "/tipo_productos" =>  "ember#start"
  get "/producto_detalles" =>  "ember#start"
  get "/curso_colaboradores" =>  "ember#start"
  get "/viaje_colaboradores" =>  "ember#start"
  get "/producciones" =>  "ember#start"
  get "/tipo_salidas" =>  "ember#start"
  get "/categoria_operaciones" =>  "ember#start"
  get "/reporte_operacion" =>  "ember#start"
  get "/reporte_descuento" =>  "ember#start"
  get "/reporte_evento" =>  "ember#start"
  get "/tratamientos/new" => "ember#start"
  get "/clientes/:id/referencias" => "ember#start"
  get "/clientes/:id/ingresoFamiliares" => "ember#start"
  get "/clientes/:id/documentos" => "ember#start"
  get "/ficha_paciente/new" => "ember#start"
  get "/pacientes/new" => "ember#start"
  post "/pacientes/:id/fonoaudiologia" => "ember#start"
  get "/monitoreo_cajas" =>  "ember#start"
  get "/fichas_fonoaudiologia/new" => "ember#start"
  get "/fichas_psicologia/new" => "ember#start"
  get "/fichas_odontologia/new" => "ember#start"
  get "/fichas_cirugia/new" => "ember#start"
  get "/documentos/:id/adjunto" => "ember#start"

  get "ember/start"

  #get "/operaciones" => "ember#start"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root 'welcome#'
  #root :to => 'application#index'

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :clientes
      resources :usuarios
      resources :venta_cuotas
      resources :venta_detalles
      resources :venta_medios
      resources :ventas  do
        get 'imprimir', on: :member
      end
      resources :productos do
        post 'foto', on: :member
      end
      resources :api_keys
      resources :cajas
      resources :cursos
      resources :curso_colaboradores
      resources :viaje_colaboradores
      resources :operaciones
      resources :proveedores
      resources :empresas
      resources :sucursales
      resources :categorias
      resources :promociones
      resources :promocion_productos
      resources :compras
      resources :compra_detalles
      resources :categorias_productos
      resources :operaciones_caja
      resources :sesion_cajas
      resources :tipo_creditos
      resources :inventarios
      resources :precios
      resources :viajes
      resources :roles
      resources :sucursal_usuarios
      resources :compra_cuotas
      resources :roles_usuarios
      resources :registros_produccion
      resources :proceso_detalles
      resources :procesos
      resources :categoria_clientes
      resources :categoria_clientes_promociones
      resources :depositos
      resources :transferencias_deposito
      resources :transferencia_deposito_detalles
      resources :lote_depositos
      resources :producto_detalles
      resources :parametros_empresas
      resources :vendedores
      resources :caja_impresion
      resources :cajas_impresion
      resources :ajuste_inventario_detalles
      resources :ajuste_inventarios
      resources :inventario_lotes
      resources :monedas
      resources :lotes
      resources :producciones
      resources :producciones_detalles
      resources :contenedores
      resources :compra_medios
      resources :cuentas
      resources :contenedores
      resources :cotizaciones
      resources :tarjetas
      resources :medio_pagos
      resources :recargos
      resources :consultorios
      resources :motivos_inventarios
      resources :pagos
      resources :pago_detalles
      resources :sucursales_vendedores
      resources :tipos_movimiento
      resources :movimientos
      resources :tipo_cajas
      resources :tipo_operacion_detalles
      resources :tipos_operacion
      resources :tipo_salidas
      resources :tipos_movimiento
      resources :tipo_productos
      resources :campanha_sponsors
      resources :categoria_operaciones
      resources :eventos
      resources :especialidades
      resources :pacientes
      resources :pacientes do
        get 'fonoaudiologia', on: :member
      end
      resources :pacientes do
        post 'fonoaudiologia', on: :member
      end

      resources :personas
      resources :tratamientos
      resources :clientes
      resources :ciudades
      resources :calificaciones
      resources :ingreso_familiares
      resources :vinculo_familiares
      resources :referencias
      resources :documentos do
        post 'adjunto', on: :member
      end
      resources :tipo_documentos
      resources :conyugues
      resources :tipo_campanhas
      resources :campanhas
      resources :colaboradores
      resources :tipo_colaboradores
      resources :consultas
      resources :consulta_detalles
      resources :campanhas_colaboradores
      resources :contactos
      resources :contacto_detalles
      resources :tipo_contactos
      resources :sponsors
      resources :tipo_sponsors
      resources :fichas_fonoaudiologia
      resources :fichas_odontologia
      resources :fichas_cirugia
      resources :fichas_nutricion
      resources :fichas_psicologia
      resources :candidaturas
      post 'session' => 'session#create'
    end
  end

  root "ember#start"

end
