class API::V1::VentaCuotasController < ApplicationController
  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_ventas" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_ventas" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_ventas" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_ventas" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_ventas" end

  respond_to :json
  #before_filter :ensure_authenticated_user

  has_scope :by_venta
	has_scope :pendientes, :type => :boolean
	has_scope :by_cancelado
	has_scope :by_cliente_id
  has_scope :by_cliente_nombre
  has_scope :by_cliente_apellido
	has_scope :by_cliente_ruc
	has_scope :by_empresa_id
	has_scope :by_sucursal_id
	has_scope :by_nro_factura
	has_scope :by_fecha_venta_before
  has_scope :by_fecha_venta_on
  has_scope :by_fecha_venta_after
	has_scope :by_fecha_vencimiento_before
  has_scope :by_fecha_vencimiento_on
  has_scope :by_fecha_vencimiento_after
  has_scope :by_fecha_cobro_before
  has_scope :by_fecha_cobro_on
  has_scope :by_fecha_cobro_after

  has_scope :by_venta_anulada


  PER_PAGE_RECORDS = 15

  def index
		tipo = params[:content_type]
		if params[:unpaged]
			@venta_cuotas = apply_scopes(VentaCuota)
			render json: @venta_cuotas, each_serializer: VentaCuotaSerializer, meta: {total: apply_scopes(VentaCuota).all.count, total_pages: 0}

    elsif tipo.eql? "recibo_cuota"
      @ventas = VentaCuota.find(params[:venta_cuota_id])
      pdf = ReciboCuotaReport.new(@ventas)
      send_data pdf.render, filename: 'recibo' + Time.now.to_s + '.pdf', type: 'application/pdf', disposition: 'attachment'

    elsif tipo.eql? "pdf"
      require 'venta_cuotas_report.rb'
      @ventas = apply_scopes(VentaCuota).order(:fecha_vencimiento).reverse_order
      pdf = VentaCuotasReportPdf.new(@ventas)
      send_data pdf.render, filename: 'reporte_cuentas_por_cobrar.pdf', type: 'application/pdf', disposition: 'attachment'

    elsif tipo.eql? "recibo_cuota"
      require 'recibo_cuota.rb'
      @ventas = VentaCuota.find(params[:venta_cuota_id])
      pdf = ReciboCuotaReport.new(@ventas)
      send_data pdf.render, filename: 'recibo' + Time.now.to_s + '.pdf', type: 'application/pdf', disposition: 'attachment'
    else
       @venta_cuotas = apply_scopes(VentaCuota).page(params[:page]).per(PER_PAGE_RECORDS)
       render json: @venta_cuotas, each_serializer: VentaCuotaSerializer, meta: {total: apply_scopes(VentaCuota).all.count, total_pages: @venta_cuotas.num_pages}
    end
  end

  def show
    respond_with VentaCuota.find(params[:id])
  end

  def new
    respond_with venta_cuota.new
  end

  def create
    @venta_cuota = VentaCuota.new(venta_cuota_params)
    @venta_cuota.save
    respond_with @venta_cuota, location: nil
  end

  def update
    @venta_cuota = VentaCuota.find_by(id: params[:id])

    if @venta_cuota.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @venta = Venta.find(venta_cuota_params[:venta_id])
      #@venta_cuota.update_attributes(venta_cuota_params)

      if @venta_cuota.cancelado and not venta_cuota_params[:cancelado] #se revertio el pago de cuota
        @venta_cuota.registrar_anulacion_pago
      elsif not @venta_cuota.cancelado and venta_cuota_params[:cancelado]
        @venta_cuota.registrar_pago(params[:venta_cuota][:fecha_cobro], params[:venta_cuota][:nro_recibo])
      end

      respond_with @venta_cuota, location: nil
    end
  end

  def destroy
    @venta_cuota = VentaCuota.find_by(id: params[:id])
    if @venta_cuota.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @venta_cuota.destroy
      respond_with @venta_cuota
    end
  end


  def venta_cuota_params
    params.require(:venta_cuota).permit(:venta_id, :nro_cuota, :monto, :fecha_vencimiento, :fecha_cobro, :cancelado, :nro_recibo, :estado)
  end
end
