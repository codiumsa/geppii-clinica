class API::V1::TransferenciaDepositoDetallesController < ApplicationController

  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_depositos" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_depositos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_depositos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_depositos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_depositos" end 

  PER_PAGE_RECORDS = 1500

  def index
    @detalles = apply_scopes(TransferenciaDepositoDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @detalles, meta: {total: apply_scopes(TransferenciaDepositoDetalle).all.count, total_pages: @detalles.num_pages}      
  end

  def show
    respond_with TransferenciaDepositoDetalle.find(params[:id])
  end

  def new
    respond_with TransferenciaDepositoDetalle.valid?
  end

  def create
    @transferencia = TransferenciaDepositoDetalle.new(deposito_params)
    @transferencia.save
    respond_with @transferencia, location: nil
  end

  def update
    @transferencia = TransferenciaDepositoDetalle.find_by(id: params[:id])
    if @transferencia.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @transferencia.update_attributes(deposito_params)
      respond_with @transferencia, location: nil
    end
  end

  def destroy
    @transferencia = TransferenciaDepositoDetalle.find_by(id: params[:id])
    if @transferencia.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @transferencia.destroy
      respond_with @transferencia
    end
  end

  def deposito_params
    params.require(:transferencia_deposito_detalle).permit(:transferencia_id, :producto_id, :cantidad)
  end
end