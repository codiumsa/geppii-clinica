class API::V1::InventarioProductosController < ApplicationController
	respond_to :json
	before_filter :ensure_authenticated_user

  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_inventario_productos" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_inventario_productos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_inventario_productos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_inventario_productos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_inventario_productos" end 

  PER_PAGE_RECORDS = 15
  has_scope :ids, type: :array

  def index
    if params[:ids]
      @detalles = apply_scopes(InventarioProducto).page.per(params[:ids].length)
    else
      @detalles = apply_scopes(InventarioProducto).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @detalles, each_serializer: InventarioProductoSerializer, 
                meta: {total: apply_scopes(InventarioProducto).all.count, total_pages: @detalles.num_pages}
  end

  def show
    respond_with InventarioProducto.find(params[:id])
  end

  # def new
  #   respond_with InventarioProducto.valid?
  # end

  def new
    respond_with InventarioProducto.new
  end

  def create
    @inventarioProducto = InventarioProducto.new(inventario_producto_params)
    @inventarioProducto.save
    respond_with @inventarioProducto, location: nil
  end

  def update
    @inventarioProducto = InventarioProducto.find_by(id: params[:id])
    if @inventarioProducto.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @inventarioProducto.update_attributes(inventario_producto_params)
      respond_with @inventarioProducto, location: nil
    end
  end

  def destroy
    @inventarioProducto = InventarioProducto.find_by(id: params[:id])
    if @inventarioProducto.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @inventarioProducto.destroy
      respond_with @inventarioProducto
    end
  end

  def inventario_producto_params
    params.require(:inventario_producto).permit(:producto_id, :existencia, :inventario_id)
  end
end
