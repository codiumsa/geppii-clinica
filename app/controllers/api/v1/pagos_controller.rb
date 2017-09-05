class API::V1::PagosController < ApplicationController

  respond_to :json
  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_pagos" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_pagos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_pagos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_pagos" end 

  PER_PAGE_RECORDS = 15

  has_scope :by_compra
	has_scope :by_venta
  has_scope :by_activo, :type => :boolean

  has_scope :by_not_pendiente, :type => :boolean
  has_scope :by_not_pendiente_with_descuento, :type => :boolean
  has_scope :by_estado_pago

  has_scope :by_usuario_aprobador_descuento_id
  has_scope :by_username_aprobador_descuento
  has_scope :by_nombre_aprobador_descuento
  has_scope :by_apellido_aprobador_descuento

  has_scope :by_fecha_creacion_before
  has_scope :by_fecha_creacion_on
  has_scope :by_fecha_creacion_after

  #has_scope :by_fecha_aprobacion_before
  #has_scope :by_fecha_aprobacion_on
  #has_scope :by_fecha_aprobacion_after

  #has_scope :by_multa_eq
  #has_scope :by_multa_gt
  #has_scope :by_multa_lt

  has_scope :by_descuento_eq
  has_scope :by_descuento_gt
  has_scope :by_descuento_lt

  #has_scope :by_descuento_interes_punitorio_eq
  #has_scope :by_descuento_interes_punitorio_gt
  #has_scope :by_descuento_interes_punitorio_lt

  #has_scope :by_descuento_interes_moratorio_eq
  #has_scope :by_descuento_interes_moratorio_gt
  #has_scope :by_descuento_interes_moratorio_lt

  #has_scope :by_descuento_gastos_administrativos_eq
  #has_scope :by_descuento_gastos_administrativos_gt
  #has_scope :by_descuento_gastos_administrativos_lt

  has_scope :by_total_eq
  has_scope :by_total_gt
  has_scope :by_total_lt
  

  def index
    #Cuota.actualizar_intereses_moratorio_punitorio
    #Cliente.actualizar_calificaciones
    tipo = params[:content_type]
    if tipo.eql? "pdf"
      tipo_reporte = params[:report_type]

      case tipo_reporte
        when "aprobacion_descuentos"
          @pago = apply_scopes(Pago).order(:created_at).reverse_order
          pdf = AprobacionDescuentosReportPdf.new(@pago)
          send_data pdf.render, filename: 'reporte_aprobacion_descuentos.pdf', type: 'application/pdf', disposition: 'attachment'
        when "reporte_pagos"
          puts "Reporte pagos: #{params}"
          agrupado = params[:group_by_prestamos].nil? ? false : true
          @pago = apply_scopes(Pago).order(:created_at).reverse_order
          pdf = ReportPagoPdf.new(@pago, agrupado)
          send_data pdf.render, filename: 'reporte_pagos.pdf', type: 'application/pdf', disposition: 'attachment'
        when "recibo"
          puts "\n\n\n\nREPORTE DE RECIBO\n\n\n\n"
          @pago = Pago.find(params[:pago_id])
          pdf = ReciboCuotaReport.new(@pago)
          send_data pdf.render, filename: 'reporte_recibo.pdf', type: 'application/pdf', disposition: 'inline'   
        when "recibo_ultimo_pago"
          puts "\n\n\n\nREPORTE DE RECIBO ULTIMO PAGO\n\n\n\n"
          @prestamo = Prestamo.find(params[:prestamo_id])
          if @prestamo.monto_refinanciamiento > 0
            @ultimo_pago = Pago.where("prestamo_id = ?", @prestamo.solicitud.prestamo_reestructurado).order(:fecha_pago).last
            pdf = ReciboReportPdf.new(@ultimo_pago)
            send_data pdf.render, filename: 'reporte_recibo.pdf', type: 'application/pdf', disposition: 'attachment'   
          end
      end 
    else
      @cuotas = apply_scopes(Pago).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @cuotas, each_serializer: PagoSerializer, meta: {total: apply_scopes(Pago).all.count, total_pages: @cuotas.num_pages}
    end
  end

  def show
    respond_with Pago.find(params[:id])
  end

  def new
    respond_with Pago.new
  end

  def create
    cleanedParams = pago_inner_params.dup
    @pago = Pago.new(cleanedParams)
    @pago.pago_detalles = []
    if(not params[:pago][:pago_detalles].nil?)
      params[:pago][:pago_detalles].each do |detalle|
						if (not detalle[:compra_cuota_id].nil?)
            	detalle = PagoDetalle.new(compra_cuota: CompraCuota.find(detalle[:compra_cuota_id]))
            	@pago.pago_detalles.push(detalle)
						end
						if (not detalle[:venta_cuota_id].nil?)
            	detalle = PagoDetalle.new(venta_cuota: VentaCuota.find(detalle[:venta_cuota_id]))
            	@pago.pago_detalles.push(detalle)
						end
        end
    end

    if @pago.unico_pendiente
      #if @pago.refinanciamiento
      #  @pago.refinanciar current_user
      #elsif @pago.impugnado
      #  @pago.impugnar current_user
      #else
      @pago.guardar current_user
      #end
      respond_with @pago, location: nil
    else
      render json: {message: 'Existe un pago pendiente'}, :status => :bad_request
    end
    # render json: {:errors => {:cantidad => "Prueba"}}, status: 422
  end

  def update
    @pago = Pago.find_by(id: params[:id])
    if @pago.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
			
      pago_actual = Pago.find(@pago.id)
			if(params[:pago][:estado] == Settings.estados_pagos.descuento_aprobado or params[:pago][:estado] == Settings.estados_pagos.descuento_rechazado)
				pago_actual.estado = params[:pago][:estado]

				#pago_actual.fecha_aprobacion_descuento = params[:pago][:fecha_aprobacion_descuento]
				pago_actual.usuario_aprobacion_descuento = current_user
				pago_actual.save!
				respond_with pago_actual, location: nil
			else
				if(params[:pago][:estado] == Settings.estados_pagos.concretado and 
					(@pago.estado == Settings.estados_pagos.pendiente or @pago.estado == Settings.estados_pagos.descuento_aprobado or @pago.estado == Settings.estados_pagos.congelado or Settings.estados_pagos.concretado))

          @pago.nro_recibo = params[:pago][:nro_recibo]
          @pago.banco_cheque = params[:pago][:banco_cheque]
          @pago.numero_cheque = params[:pago][:numero_cheque]
					@pago.concretar
                    
          genera_movimiento = Usuario.where("id = ? ",current_user).first.isAuthorized("BE_genera_movimientos_caja")

          if (ParametrosEmpresa.default_empresa().first.soporta_cajas && genera_movimiento)
            puts "************ GENERANDO OPERACION EN CAJA ************ "
  					if(not @pago.venta_id.nil?)
  						Operacion.generarOperacion(current_caja.id, Settings.cajas.tipos_operaciones.cobro_venta, nil, @pago.id, @pago.total, @pago.moneda.id, current_sucursal)
  					end
  					if(not @pago.compra_id.nil?)
  						Operacion.generarOperacion(current_caja.id, Settings.cajas.tipos_operaciones.pago_proveedor, nil, @pago.id, @pago.total, @pago.moneda.id, current_sucursal)
  					end
          end
					respond_with @pago, location: nil
				else
					render json: {message: 'Invalid state transition'}, :status => :bad_request
				end
			end
    end
  end

  def destroy
    @pago = Pago.find_by(id: params[:id])
    if @pago.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
			if ParametrosEmpresa.default_empresa().first.soporta_cajas
				Pago.transaction do
					if(not @pago.venta_id.nil?)
						op_anterior = Operacion.get_operacion_by_referencia(@pago, Settings.cajas.tipos_operaciones.cobro_venta)
						Operacion.reversarOperacion(op_anterior, current_sucursal)
					end
					if(not @pago.compra_id.nil?)
						op_anterior = Operacion.get_operacion_by_referencia(@pago, Settings.cajas.tipos_operaciones.pago_proveedor)
						Operacion.reversarOperacion(op_anterior, current_sucursal)
					end
				end
			end
			@pago.borrar
      respond_with @pago
    end
  end

  def pago_params
    params.require(:pago).permit(:descuento_moneda_seleccionada, :total_moneda_seleccionada, :monto_cotizacion, :moneda_id, :compra_id, :venta_id, :id, :fecha_pago, :total, :estado, :descuento, :banco_cheque, :numero_cheque, :nro_recibo, pago_detalles: [:monto_capital, :monto_interes, :monto_interes_moratorio, :monto_interes_punitorio, :compra_cuota_id, :venta_cuota_id])
  end

  def pago_inner_params
    params.require(:pago).permit(:banco_cheque, :numero_cheque, :descuento_moneda_seleccionada, :total_moneda_seleccionada, :monto_cotizacion, :moneda_id, :compra_id, :venta_id, :id, :fecha_pago, :total, :estado, :descuento, :nro_recibo)
  end
end
