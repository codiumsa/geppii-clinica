class API::V1::PromocionProductosController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_promociones" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_promociones" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_promociones" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_promociones" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_promociones" end

  has_scope :promociones, :using => [:cantidad, :producto], :type => :hash 
  has_scope :ids, type: :array


  def index
    puts params
    if params[:ids]
      @detalles = apply_scopes(PromocionProducto).page.per(params[:ids].length)
    else
      @detalles = apply_scopes(PromocionProducto).page(params[:page])
    end
   render json: @detalles, each_serializer: PromocionProductoSerializer, meta: {total: apply_scopes(PromocionProducto).all.count, total_pages: @detalles.num_pages}      

  end

  def show
    respond_with PromocionProducto.find(params[:id])
  end

  def new
    respond_with PromocionProducto.new
  end

  def create
    @detalle = PromocionProducto.new(promocion_producto_params)
    @detalle.save
    respond_with @detalle, location: nil
  end

  def update
    @detalle = PromocionProducto.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.update_attributes(promocion_producto_params)
      respond_with @detalle
    end
  end

  def destroy
    @detalle = PromocionProducto.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.destroy
      respond_with @detalle
    end
  end

  def promocion_producto_params
    params.require(:promocion_producto).permit(:producto_id, :promocion_id, :cantidad, :precio_descuento, :porcentaje, :moneda_id)
  end
end
