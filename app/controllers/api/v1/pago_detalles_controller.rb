class API::V1::PagoDetallesController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_pagos" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_pagos" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_pagos" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_pagos" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_pagos" end 

  has_scope :ids, type: :array
  has_scope :by_pago_activo
  PER_PAGE_RECORDS = 15

  def index
    if params[:ids]
      @pago_detalles = apply_scopes(PagoDetalle).page.per(params[:ids].length)
    else
      @pago_detalles = apply_scopes(PagoDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @pago_detalles, each_serializer: PagoDetalleSerializer, 
                meta: {total: apply_scopes(PagoDetalle).all.count, total_pages: @pago_detalles.num_pages}
  end

  def show
    respond_with PagoDetalle.find(params[:id])
  end

  def new
    respond_with PagoDetalle.new
  end

  def create
    @detalle = PagoDetalle.new(pago_detalle_params)
    @detalle.save
    respond_with @detalle, location: nil
    # render json: {:errors => {:cantidad => "Prueba"}}, status: 422
  end

  def update
    @detalle = PagoDetalle.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.update_attributes(pago_detalle_params)
      respond_with @detalle, location: nil
    end
  end

  def destroy
    @detalle = PagoDetalle.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.destroy
      respond_with @detalle
    end
  end

  def pago_detalle_params
    params.require(:pago_detalle).permit(:monto_capital, :monto_interes, :monto_interes_moratorio, :monto_interes_punitorio, :cuota_id, :ids => [])
  end
end