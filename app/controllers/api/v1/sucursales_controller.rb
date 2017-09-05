class API::V1::SucursalesController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_sucursales" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_sucursales" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_sucursales" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_sucursales" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_sucursales" end 

  has_scope :by_id
  has_scope :by_codigo
  has_scope :by_descripcion
  has_scope :by_empresa

  has_scope :unpaged, :type => :boolean
  has_scope :by_activo, :type => :boolean

  has_scope :by_all_attributes, allow_blank: true

  PER_PAGE_RECORDS = 15

  def index
    if (params[:unpaged]) 
      @sucursales = apply_scopes(Sucursal)
      render json: @sucursales, each_serializer: SucursalSerializer, meta: {total: apply_scopes(Sucursal).all.count, total_pages: 0}
    else 
      @sucursales = apply_scopes(Sucursal).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @sucursales, each_serializer: SucursalSerializer, meta: {total: apply_scopes(Sucursal).all.count, total_pages: @sucursales.num_pages}
    end
  end

  def show
    respond_with Sucursal.find(params[:id])
  end

  def new
  	respond_with Sucursal.new
  end

  def create
  	@sucursal = Sucursal.new(sucursal_params)
    puts @sucursal
    @sucursal.guardar
    
  	respond_with @sucursal
  end

  def update
    @sucursal = Sucursal.find_by(id: params[:id])
    if @sucursal.nil?
    	render json: {message: 'Resource not found'}, :status => :not_found
    else
      update_params = sucursal_params.clone()
      
      if !sucursal_params.has_key?('deposito_id')
        update_params['deposito_id'] = nil
      end


      
      Sucursal.transaction do
        
        

		    @sucursal.update_attributes(update_params)
        @sucursal.genera_sucursal_vendedor
      end
     	respond_with @sucursal
  	end
  end

  def destroy
    @sucursal = Sucursal.find_by(id: params[:id])
    if @sucursal.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
  		#@sucursal.destroy
  		@sucursal.activo = false
      @sucursal.save
      respond_with @sucursal
  	end
  end

  def sucursal_params
  	params.require(:sucursal).permit(:codigo, :descripcion, :deposito_id, :empresa_id, :color, :vendedor_id, :crear_deposito,:nueva_caja_id)
  end

end
