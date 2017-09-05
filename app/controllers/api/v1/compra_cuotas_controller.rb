class API::V1::CompraCuotasController < ApplicationController
  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_compras" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_compras" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_compras" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_compras" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_compras" end 

  respond_to :json
  #before_filter :ensure_authenticated_user

  has_scope :by_compra
  has_scope :by_proveedor_id
  has_scope :by_sucursal_id
  has_scope :by_nro_factura
	has_scope :pendientes, :type => :boolean

  has_scope :by_fecha_compra_before
  has_scope :by_fecha_compra_after
  has_scope :by_fecha_compra_on
  has_scope :by_fecha_vencimiento_before
  has_scope :by_fecha_vencimiento_after
  has_scope :by_fecha_vencimiento_on
  has_scope :by_fecha_cobro_before
  has_scope :by_fecha_cobro_after
  has_scope :by_fecha_cobro_on
	has_scope :by_deposito_id
	has_scope :by_empresa_id
	has_scope :by_cancelado



  PER_PAGE_RECORDS = 15

  def index
    tipo = params[:content_type]
    if tipo.eql? "pdf"
      #require 'compra_cuotas_report.rb'
      @cuotas = apply_scopes(CompraCuota).order(:fecha_vencimiento).reverse_order
      pdf = CompraCuotasReportPdf.new(@cuotas)
      send_data pdf.render, filename: 'reporte_cuentas_por_pagar.pdf', type: 'application/pdf', disposition: 'attachment'
    else
			if params[:unpaged]
				@compra_cuota = apply_scopes(CompraCuota)
				render json: @compra_cuota, each_serializer: CompraCuotaSerializer, meta: {total: apply_scopes(CompraCuota).all.count, total_pages: 0}
			else
				@compra_cuota = apply_scopes(CompraCuota).page(params[:page]).per(PER_PAGE_RECORDS)
				render json: @compra_cuota, each_serializer: CompraCuotaSerializer, meta: {total: apply_scopes(CompraCuota).all.count, total_pages: @compra_cuota.num_pages}
			end
    end
  end

  def show
    respond_with CompraCuota.find(params[:id])
  end

  def new
    respond_with CompraCuota.new
  end

  def create
    puts('LLAMADA A CREATE DE COMPRA_CUOTA')
    @compra_cuota = CompraCuota.new(compra_cuota_params)
    @compra_cuota.save
    respond_with @compra_cuota
  end

  def update
    @compra_cuota = CompraCuota.find_by(id: params[:id])

   if @compra_cuota.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @compra = Compra.find(compra_cuota_params[:compra_id])
      #@compra_cuota.update_attributes(compra_cuota_params)
      
      if @compra_cuota.cancelado and not compra_cuota_params[:cancelado] #se revertio el pago de cuota
        #crear session de caja de reversion

        #actualizar deuda en compra
        nuevaDeuda =  @compra.deuda + @compra_cuota.monto

        if @compra.pagado
          @compra.pagado = false
        end

        @compra.deuda = nuevaDeuda
        @compra.save
      elsif  not @compra_cuota.cancelado and compra_cuota_params[:cancelado]
        #crear session de caja de entrada de dinero

        #actualizar deuda en compra
        nuevaDeuda =  @compra.deuda - @compra_cuota.monto
        if nuevaDeuda == 0
          @compra.pagado = true
        end

        @compra.deuda = nuevaDeuda 
        @compra.save
      end

      @compra_cuota.fecha_cobro = compra_cuota_params[:fecha_cobro]
      @compra_cuota.cancelado = compra_cuota_params[:cancelado]
      @compra_cuota.nro_recibo = compra_cuota_params[:nro_recibo]

      @compra_cuota.save

      
      #generarDebitoCaja(@compra_cuota)

      respond_with @compra_cuota, location: nil
    end
  end

  def destroy
    @compra_cuota = CompraCuota.find_by(id: params[:id])
    if @compra_cuota.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @compra_cuota.destroy
      respond_with @compra_cuota, location: nil
    end
  end

  def generarDebitoCaja(compra_cuota)

    @cajaChica = Caja.where("sucursal_id = ? AND tipo_caja = 'C'", current_sucursal.id).first
    @operacionCaja = OperacionCaja.where("tipo = 'Debito'").first

    observacion = 'Pago Cuota de Compra #' + compra_cuota.id.to_s + '#' + "Recibo Nro: "  
    if(compra_cuota.nro_recibo || compra_cuota.nro_recibo == '')
      observacion += compra_cuota.nro_recibo
    else
      observacion += "--"
    end 

    @sesionCaja = SesionCaja.new(:fecha =>compra_cuota.fecha_cobro, 
      :observacion => observacion, :monto => compra_cuota.monto, #:saldo => saldo,
      :caja_id => @cajaChica.id, :operacion_caja_id => @operacionCaja.id)

    @sesionCaja.save
  end

  def compra_cuota_params
    params.require(:compra_cuota).permit(:compra_id, :nro_cuota, :monto, :fecha_vencimiento, :fecha_cobro, :cancelado, :nro_recibo)
  end
end

