class API::V1::TransferenciasDepositoController < ApplicationController

  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_depositos" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_depositos" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_depositos" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_depositos" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_depositos" end

  PER_PAGE_RECORDS = 15

  has_scope :by_origen_id
  has_scope :by_destino_id
  has_scope :by_fecha_registro_before
  has_scope :by_fecha_registro_after
  has_scope :by_fecha_registro_on
  has_scope :by_usuario
  has_scope :by_all_attributes, allow_blank: true


  def index
    tipo = params[:tipo]
    content_type = params[:content_type]
    if content_type.eql? "pdf"
      @TransferenciasDeposito = TransferenciaDeposito.find(params[:transferencia_deposito_id])
      pdf = TransferenciaReportPdf.new(@TransferenciasDeposito)
      send_data pdf.render, filename: 'TransferenciaReport.pdf', type: 'application/pdf', disposition: 'inline'
    else
      @transferencias = apply_scopes(TransferenciaDeposito).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @transferencias, meta: {total: apply_scopes(TransferenciaDeposito).all.count, total_pages: @transferencias.num_pages}
    end
  end

  def show
    respond_with TransferenciaDeposito.find(params[:id])
  end

  def new
    respond_with TransferenciaDeposito.new
  end

  def create
    @transferencia = TransferenciaDeposito.new(transferencia_deposito_inner_params)
    detalles = []
    if(not params[:transferencia_deposito][:detalle].nil?)
      params[:transferencia_deposito][:detalle].each do |d|
        @detalle = TransferenciaDepositoDetalle.new(lote_id: d[:lote_id],
                                                    cantidad: d[:cantidad])
        detalles.push(@detalle)
      end
    end

    @transferencia.detalles = detalles
    sucursal_id = current_sucursal.id

    @transferencia.save_with_details(sucursal_id)
    respond_with @transferencia, location: nil
  end

  def update
    @transferencia = TransferenciaDeposito.find_by(id: params[:id])
    if @transferencia.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @transferencia.update_attributes(transferencia_deposito_inner_params)
      respond_with @transferencia, location: nil
    end
  end

  def destroy
    @transferencia = TransferenciaDeposito.find_by(id: params[:id])
    if @transferencia.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @transferencia.destroy_with_details
      respond_with @transferencia
    end
  end

  def transferencia_deposito_params
    params.require(:transferencia_deposito).permit(:nombre, :nro_transferencia, :descripcion, :origen_id, :destino_id, :usuario_id, :fecha_registro, detalle: [:producto_id, :cantidad])
  end

  def transferencia_deposito_inner_params
    params.require(:transferencia_deposito).permit(:nombre, :nro_transferencia, :descripcion, :origen_id, :destino_id, :usuario_id, :fecha_registro)
  end
end
