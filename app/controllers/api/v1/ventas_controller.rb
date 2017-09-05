# encoding: utf-8
class API::V1::VentasController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_ventas" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_ventas" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_ventas" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_ventas" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_ventas" end

  has_scope :sucursal
  has_scope :by_persona_id
  has_scope :by_cliente_nombre
  has_scope :by_cliente_apellido
  has_scope :by_vendedor_nombre
  has_scope :by_vendedor_apellido
  has_scope :by_cliente_ruc
  has_scope :by_sucursal_id
  has_scope :by_campanha_id
	has_scope :by_empresa_id
  has_scope :by_nro_factura
  has_scope :by_credito
  has_scope :by_tipo_credito_id
  has_scope :by_fecha_registro_before
  has_scope :by_fecha_registro_after
  has_scope :by_fecha_registro_on
  has_scope :by_total_gt
  has_scope :by_total_lt
  has_scope :by_total_eq
  has_scope :by_codigo_barra
  has_scope :by_imei
  has_scope :by_moneda_id
  has_scope :by_anulados
  has_scope :by_usuario_id
  has_scope :by_producto_id
  has_scope :by_promocion_id
  has_scope :tiene_descuento, :type => :boolean
  has_scope :tiene_descuento_redondeo, :type => :boolean
  has_scope :tiene_descuento_detalle, :type => :boolean
  has_scope :tiene_descuento_detalle_sin_promo, :type => :boolean
  has_scope :tiene_descuento_detalle_con_promo, :type => :boolean
  has_scope :by_tipo_salida
  has_scope :by_all_attributes, allow_blank: true

  PER_PAGE_RECORDS = 15

  def index
    puts "[VENTA_CONTROLLER.RB][INDEX]: ingresando #{params}"
    tipo = params[:tipo]
    content_type = params[:content_type]
    if content_type.eql? "pdf"
      if tipo.eql? "reporte_ventas"
        puts "[VENTA_CONTROLLER.RB][INDEX][REPORTE-VENTAS]: #{params}"
        @ventas = apply_scopes(Venta).order(:fecha_registro).reverse_order
        puts "ventas:: #{@ventas.to_yaml}"
        pdf = VentasReportPdf.new(@ventas,params[:by_anulados])
        send_data pdf.render, filename: 'reporte_salidas.pdf', type: 'application/pdf', disposition: 'attachment'
      end
      if tipo.eql? "factura"
        puts "[VENTA_CONTROLLER.RB][INDEX][FACTURA]: #{params}"
        @venta = Venta.find(params[:venta_id])
        pdf = FacturaReportPdf.new(@venta)
        send_data pdf.render, filename: 'factura' + Time.now.to_s + '.pdf', type: 'application/pdf', disposition: 'inline'
      end
      if tipo.eql? "uso_interno"
        puts "[VENTA_CONTROLLER.RB][INDEX][USO INTERNO]: #{params}"
        @venta = Venta.find(params[:venta_id])
        pdf = UsoInternoReportPdf.new(@venta)
        send_data pdf.render, filename: 'uso_interno.pdf', type: 'application/pdf', disposition: 'inline'
      end
      if tipo.eql? "reporte_venta_medio_pago"
        puts "[VENTA_CONTROLLER.RB][INDEX][venta_medio_pago]: #{params}"
        @ventas = apply_scopes(Venta).all
        pdf = VentasMedioPagoReportPdf.new(@ventas,params[:by_empresa_id],params[:by_fecha_registro_after], params[:by_fecha_registro_on], params[:by_fecha_registro_before])
        send_data pdf.render, filename: 'venta_medio_pago.pdf', type: 'application/pdf', disposition: 'attachment'
      end
      if tipo.eql? "extracto_cliente"
        puts "[VENTA_CONTROLLER.RB][INDEX][REPORTE-EXTRACTO CLIENTE]: #{params}"
        @venta = apply_scopes(Venta).order(:fecha_registro)
        pdf = ExtractoClienteReportPdf.new(@venta, params[:moneda_id])
        send_data pdf.render, filename: 'extracto_cliente_'+params[:by_cliente_ruc]+'.pdf', type: 'application/pdf', disposition: 'attachment'
      end
      if tipo.eql? "movimiento_venta"
        @venta = apply_scopes(Venta).order(:fecha_registro)
        pdf = MovimientoVentaReportPdf.new(@venta, params[:by_fecha_registro_after], params[:by_fecha_registro_on], params[:by_fecha_registro_before],params[:moneda_nombre])
        send_data pdf.render, filename: 'movimiento_venta_'+ if !params[:by_sucursal_id].nil? then params[:by_sucursal_id] else "0" end +'.pdf', type: 'application/pdf', disposition: 'attachment'
      end
      if tipo.eql? "descuento_venta"
        @venta = apply_scopes(Venta).order(:fecha_registro)
        pdf = DescuentoReportPdf.new(@venta, params[:by_fecha_registro_after], params[:by_fecha_registro_on], params[:by_fecha_registro_before], params[:moneda_nombre], params[:tipo_descuento], params[:by_producto_id])
        send_data pdf.render, filename: 'descuentos_'+params[:by_sucursal_id]+'.pdf', type: 'application/pdf', disposition: 'attachment'
      end
      if tipo.eql? "precios_venta"
        pdf = PreciosVentaReportPdf.new(params[:producto_id],params[:precio_compra],params[:empresa])
        send_data pdf.render, filename: 'precios_venta.pdf', type: 'application/pdf', disposition: 'attachment'
      end
      if tipo.eql? "ganancias"
        pdf = GananciasReportPdf.new(params[:producto_id],params[:precio_compra],params[:empresa])
        send_data pdf.render, filename: 'precios_venta.pdf', type: 'application/pdf', disposition: 'attachment'
      end
      if tipo.eql? "reporte_salidas_campanha"
        @ventas = apply_scopes(Venta).by_tipos_salida(params[:tipo_salida].split('&')).order(:fecha_registro)
        @params = params
        @tipo_salida = params[:tipo_salida].split('&')
        render xlsx: 'salidas_campanha',filename: "salidas_campanha.xlsx"
      end
    else
      if params[:by_all_attributes] == ""
        params.delete(:by_all_attributes)
        puts "PARAMS: #{params}"
      end
      if Settings.autenticacion.logueo_con_sucursal
        #si se usa logueo con sucursal, se usa la sucursal_id donde está logueado
        @ventas = apply_scopes(Venta).page(params[:page]).per(PER_PAGE_RECORDS).sucursal(current_sucursal.id)
        total = apply_scopes(Venta).sucursal(current_sucursal.id).all.count
      else
         @ventas = apply_scopes(Venta).page(params[:page]).per(PER_PAGE_RECORDS)
         total = apply_scopes(Venta).all.count
      end
      puts "[VENTA_CONTROLLER.RB][INDEX]: Serializando Json"
      render json: @ventas, each_serializer: VentaSerializer, meta: {total: total, total_pages: @ventas.num_pages}
    end
  end

  def show
    respond_with Venta.unscoped.find(params[:id])
  end

  def new
    puts "------ new params-----------------------"
    puts params
    respond_with Venta.new
  end

  def create
    #si nro_facutura es nil sacar del diccionario para que la bd cree un valor por defecto

    puts "------ create params-----------------------"
    puts venta_inner_params

    puts '===================venta detalles'
    puts venta_params[:venta_detalles]

    puts '===================venta  . venta detalles'
    puts params[:venta][:venta_detalles]

      puts '===================venta  . venta medios'
    puts params[:venta][:venta_medios]

    # puts '===================venta  . venta fecha_registro'
    # puts params[:venta][:fecha_registro]
    # puts Time.zone.parse(params[:venta][:fecha_registro])
    # puts Time.parse(params[:venta][:fecha_registro])
    # puts Time.parse(params[:venta][:fecha_registro])
    # puts Time.parse(params[:venta][:fecha_registro]).utc
    # puts Time.parse(params[:venta][:fecha_registro]).utc

    cleanedParams = venta_inner_params.dup

    @venta = Venta.generar_facturas(cleanedParams, params, current_user.id,
    soporta_cajas_impresion, current_caja_impresion, current_caja, current_user, current_sucursal)

    respond_with @venta
  end

  def update
    @venta = Venta.unscoped.find_by(id: params[:id])
    if @venta.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else


      puts venta_params
      puts '===================venta detalles'
      puts venta_params[:venta_detalles]
      cleanedParams = venta_inner_params.dup

      cleanedParams.delete(:sucursal_id)
      cleanedParams.delete(:cliente_id)
      cleanedParams.delete(:tipo_credito_id)
      cleanedParams.delete(:cantidad_cuotas)

      puts  cleanedParams
      cleanedParams[:precio_editable] = Usuario.where("id = ? ",current_user).first.isAuthorized("FE_editar_precio_venta")

      @venta.update_attributes(cleanedParams)

      if current_caja_impresion
		    @venta.imprimir current_caja_impresion
      else
        puts '------------no se soporta caja de impresion---------------------'
      end

      if ParametrosEmpresa.default_empresa().first.soporta_cajas
  			op_anterior = Operacion.get_operacion_by_referencia(@venta, Settings.cajas.tipos_operaciones.venta)
  			if(op_anterior)
          Operacion.reversarOperacion(op_anterior, current_sucursal)
      	  Operacion.generarOperacion(current_caja.id, Settings.cajas.tipos_operaciones.venta, nil, @venta.id, @venta.total, @venta.moneda.id, current_sucursal)
        end
      end
      respond_with @venta
    end
  end

  def imprimir
    @venta = Venta.unscoped.find_by(id: params[:id])
    puts '===================\n\n\n\n\n\n'
    puts @venta
    puts '===================\n\n\n\n\n\n'
    if current_caja_impresion
        @venta.imprimir current_caja_impresion
    end
    respond_with @venta
  end

  def destroy
    @venta = Venta.unscoped.find_by(id: params[:id])
    if @venta.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @venta.anulado = true
      @deleted_at = Time.now
			if ParametrosEmpresa.default_empresa().first.soporta_cajas
				Venta.transaction do
					op_anterior = Operacion.get_operacion_by_referencia(@venta, Settings.cajas.tipos_operaciones.venta)
					if(op_anterior)
						Operacion.reversarOperacion(op_anterior, current_sucursal)
					end
				end
			end
      @venta.eliminar
      respond_with @venta
    end
  end

  def venta_params
    params.require(:venta).permit(:cliente_id, :descuento, :total, :iva5, :iva10, :credito, :tarjeta_credito, :vendedor_id,
      :pagado, :cantidad_cuotas, :tipo_credito_id, :fecha_registro, :nro_factura, :uso_interno, :consultorio_id,
      :sucursal_id, :deuda, :ganancia, :anulado, :cirugia, :cantidad_cirugias,:supervisor, :descuento_redondeo, :nombre_cliente, :ruc_cliente,:colaborador_id,
      :medio_pago_id, :tarjeta_id, :moneda_id, :porcentaje_recargo, :garante_id, :nro_contrato, :persona_id,:campanha_id, :tipo_salida_id,
      venta_detalles: [:producto_id, :cantidad, :precio, :descuento, :promocion_id, :moneda_id, :cotizacion_id, :monto_cotizacion, :codigo_lote],
      venta_medios: [:monto,:tarjeta_id,:medio_pago_id])
  end

  def venta_inner_params
    params.require(:venta).permit(:cliente_id, :descuento, :total, :iva5, :iva10, :credito, :tarjeta_credito, :vendedor_id,:colaborador_id, :consultorio_id,
      :pagado, :cantidad_cuotas, :tipo_credito_id, :fecha_registro, :nro_factura, :cantidad_cirugias,:uso_interno, :persona_id,:campanha_id,  :tipo_salida_id,
      :sucursal_id, :deuda, :ganancia, :anulado, :supervisor, :cirugia, :descuento_redondeo, :nombre_cliente, :ruc_cliente,
      :moneda_id, :medio_pago_id, :tarjeta_id, :porcentaje_recargo, :garante_id, :nro_contrato)
  end

  #cantidad puede ser un numero positivo o negativo
  def actualizarStockProducto(producto, sucursal, cantidad)
    @producto_sucursal = ProductoSucursal.where("producto_id = ? AND sucursal_id = ?", producto, sucursal).first

    @producto_sucursal.existencia = @producto_sucursal.existencia + cantidad
    @producto_sucursal.save
  end

  #signo -1 o +1
  def actualizarStock(venta, signo)
    @detalles = VentaDetalle.where("venta_id = ?", venta.id)
    @detalles.each do |det|
      actualizarStockProducto(det.producto_id, venta.sucursal_id, det.cantidad * signo)
    end
  end
end
