class API::V1::CategoriasProductosController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_productos" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_productos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_productos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_productos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_productos" end 

  has_scope :by_producto
  PER_PAGE_RECORDS = 15

  def index
    @categoria_productos = apply_scopes(CategoriaProducto).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @categoria_productos, each_serializer: CategoriaProductoSerializer, meta: {total: apply_scopes(CategoriaProducto).all.count, total_pages: @categoria_productos.num_pages}
  end

  def show
    respond_with CategoriaProducto.find(params[:id])
  end

  def new
    respond_with CategoriaProducto.new
  end

  def create
    @categoria_producto = CategoriaProducto.new(categoria_productos_params)
    @categoria_producto.save
    respond_with @categoria_producto, location: nil
  end

  def update
    @categoria_producto = CategoriaProducto.find_by(id: params[:id])
    if @categoria_producto.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @categoria_producto.update_attributes(producto_params)
      respond_with @categoria_producto, location: nil
    end
  end

  def destroy
    @categoria_producto = CategoriaProducto.find_by(id: params[:id])
    if @categoria_producto.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @categoria_producto.destroy
      respond_with @categoria_producto
    end
  end

  def categoria_productos_params
    params.require(:categoria_producto).permit(:id, :producto_id, :categoria_id)
  end

end

