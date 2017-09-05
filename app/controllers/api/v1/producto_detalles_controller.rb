class API::V1::ProductoDetallesController < ApplicationController
  respond_to :json
  has_scope :by_id
  has_scope :by_producto_padre

  has_scope :ids, type: :array
  PER_PAGE_RECORDS = 15

  def index

    if params[:ids]
      @producto_detalles = apply_scopes(ProductoDetalle).page.per(params[:ids].length)
    else
      @producto_detalles = apply_scopes(ProductoDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @producto_detalles, meta: {total: apply_scopes(ProductoDetalle).all.count, total_pages: @producto_detalles.num_pages}
  end

  def new
    respond_with ProductoDetalle.new
  end
  def create
    @detalle = ProductoDetalle.new(producto_detalle_params)
    @detalle.save
    respond_with @detalle, location: nil
  end

  def update
    @detalle = ProductoDetalle.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.update_attributes(producto_detalle_params)
      respond_with @detalle, location: nil
    end
  end

  def producto_detalle_params
    params.require(:producto_detalle).permit(:cantidad,:producto_id,:ids => [])
  end
end
