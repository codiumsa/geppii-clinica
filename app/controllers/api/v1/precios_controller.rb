class API::V1::PreciosController < ApplicationController
  respond_to :json
  
  before_filter :ensure_authenticated_user
  
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_precios" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_precios" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_precios" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_precios" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_precios" end 
  
  has_scope :by_producto

  PER_PAGE_RECORDS = 15
 def index
    @precios = apply_scopes(Precio).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @precios, each_serializer: PrecioSerializer, meta: {total: apply_scopes(Precio).all.count, total_pages: @precios.num_pages}
  end

  def show
    respond_with Precio.find(params[:id])
  end

  def new
  	respond_with Precio.new
  end

  def create
  	@precio = Precio.new(precio_params)
  	@precio.save
  	respond_with @precio
  end

  def update
    @precio = Precio.find_by(id: params[:id])
    if @precio.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
  		@precio.update_attributes(precio_params)
      respond_with @precio
  	end
  end

  def destroy
    @precio = Precio.find_by(id: params[:id])
    if @precio.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
  		@precio.destroy
  		respond_with @precio
  	end
  end

  def precio_params
  	params.require(:precio).permit(:fecha, :precio_compra, :compra_detalle)
  end

end
