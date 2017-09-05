class API::V1::MedioPagosController < ApplicationController
  respond_to :json
  
  before_filter :ensure_authenticated_user  
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_medio_pagos" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_medio_pagos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_medio_pagos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_medio_pagos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_medio_pagos" end 
  
  has_scope :by_nombre
  has_scope :by_codigo
  has_scope :by_all_attributes, allow_blank: true
  has_scope :unpaged, :type => :boolean
  has_scope :by_activo

  PER_PAGE_RECORDS = 15
  
  def index
    if params[:unpaged]
      @medioPagos = apply_scopes(MedioPago).order(:id)
      render json: @medioPagos, each_serializer: MedioPagoSerializer, meta: {total: apply_scopes(MedioPago).all.count, total_pages: 0}
    else
      @medioPagos = apply_scopes(MedioPago).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @medioPagos, each_serializer: MedioPagoSerializer, meta: {total: apply_scopes(MedioPago).all.count, total_pages: @medioPagos.num_pages}
    end
  end

  def show
    respond_with MedioPago.find(params[:id])
  end

  def new
    respond_with MedioPago.new
  end

  def create
    @medio_pago = MedioPago.new(medio_pago_params)
    @medio_pago.activo = true
    @medio_pago.save
    respond_with @medio_pago, location: nil
  end

  def update
    @medio_pago = MedioPago.find_by(id: params[:id])
    if @medio_pago.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @medio_pago.update_attributes(medio_pago_params)
      respond_with @medio_pago, location: nil
    end
  end

  def destroy
    @medio_pago = MedioPago.find_by(id: params[:id])
    if @medio_pago.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @medio_pago.activo=false
      @medio_pago.save
      respond_with @medio_pago, location: nil
    end
  end

  def medio_pago_params
    params.require(:medio_pago).permit(:codigo, :nombre, :registra_pago, :activo)
  end
end
