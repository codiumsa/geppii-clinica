class API::V1::SucursalesVendedoresController < ApplicationController
	respond_to :json
  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_vendedores" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_vendedores" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_vendedores" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_vendedores" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_vendedores" end 

  has_scope :by_vendedor_id
  has_scope :by_sucursal_id

  PER_PAGE_RECORDS = 15

  def index
    @sucursales_vendedores = apply_scopes(SucursalVendedor).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @sucursales_vendedores, each_serializer: SucursalVendedorSerializer, meta: {total: apply_scopes(SucursalVendedor).all.count, total_pages: @sucursales_vendedores.num_pages}
  end

  def show
    respond_with SucursalVendedor.find(params[:id])
  end

  def new
    respond_with SucursalVendedor.new
  end

  def create
    @sucursal_vendedor = SucursalVendedor.new(sucursal_vendedor_params)
    @sucursal_vendedor.save
    respond_with @sucursal_vendedor, location: nil
  end

  def update
    @sucursal_vendedor = SucursalVendedor.find_by(id: params[:id])
    if @sucursal_vendedor.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @sucursal_vendedor.update_attributes(sucursal_vendedor_params)
      respond_with @sucursal_vendedor, location: nil
    end
  end

  def destroy
    @sucursal_vendedor = SucursalVendedor.find_by(id: params[:id])
    if @sucursal_vendedor.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @sucursal_vendedor.destroy
      respond_with @sucursal_vendedor
    end
  end

  def sucursal_vendedor_params
    params.require(:sucursal_vendedor).permit(:id, :sucursal_id, :vendedor_id)
  end
end
