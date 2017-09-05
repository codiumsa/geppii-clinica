class API::V1::VentaDetallesController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_ventas" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_ventas" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_ventas" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_ventas" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_ventas" end

  has_scope :ids, type: :array
  PER_PAGE_RECORDS = 15

  def index
    if params[:ids]
      @ventas = apply_scopes(VentaDetalle).page.per(params[:ids].length)
    else
      @ventas = apply_scopes(VentaDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @ventas, each_serializer: VentaDetalleSerializer,
                meta: {total: apply_scopes(VentaDetalle).all.count, total_pages: @ventas.num_pages}
  end

  def show
    respond_with VentaDetalle.find(params[:id])
  end

  def new
    respond_with VentaDetalle.new
  end

  def create
    @detalle = VentaDetalle.new(venta_detalle_params)
    @detalle.save
    respond_with @detalle, location: nil
    # render json: {:errors => {:cantidad => "Prueba"}}, status: 422
  end

  def update
    @detalle = VentaDetalle.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.update_attributes(venta_detalle_params)
      respond_with @detalle, location: nil
    end
  end

  def destroy
    @detalle = VentaDetalle.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.destroy
      respond_with @detalle
    end
  end

  def venta_detalle_params
    params.require(:venta_detalle).permit(:producto_id, :venta_id, :cantidad, :precio, :descuento, :promocion_id, :lote_deposito_id, :codigo_lote, :imei, :ids => [])
  end
end
