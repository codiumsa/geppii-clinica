class API::V1::VendedoresController < ApplicationController
  
  respond_to :json
  
  before_filter :ensure_authenticated_user
    before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_vendedores" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_vendedores" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_vendedores" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_vendedores" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_vendedores" end 

  PER_PAGE_RECORDS = 15

	has_scope :by_all_attributes, allow_blank: true
 	
 	has_scope :by_activo, :type => :boolean
 	has_scope :unpaged, :type => :boolean
 	has_scope :by_nombre
 	has_scope :by_apellido
 	has_scope :by_direccion
 	has_scope :by_telefono
 	has_scope :by_email
 	has_scope :by_sucursal_id
 	
 	def index
 		if (params[:unpaged])
      		@vendedores = apply_scopes(Vendedor)
   		else 
 			@vendedores = apply_scopes(Vendedor).page(params[:page]).per(PER_PAGE_RECORDS)
 		end
 		if @vendedores.count > 0
 			if (params[:unpaged])
 				render json: @vendedores, each_serializer: VendedorSerializer, meta: {total: apply_scopes(Vendedor).all.count, total_pages: 1}
 			else
 				render json: @vendedores, each_serializer: VendedorSerializer, meta: {total: apply_scopes(Vendedor).all.count, total_pages: @vendedores.num_pages}
 			end
    	else
    		render json: @vendedores, each_serializer: VendedorSerializer
    	end
 	end

  def show
      respond_with Vendedor.find(params[:id])
    end

  def new
    respond_with Vendedor.new
  end

  def create
    Vendedor.transaction do
      begin
        @vendedor = Vendedor.new(vendedor_inner_params)
        @vendedor.save
        updateRelations @vendedor
      rescue => e
        @vendedor.errors[:base]<<"#{e.message}"
      end
    end
    respond_with @vendedor
  end

  def update
    @vendedor = Vendedor.find_by(id: params[:id])
    if @vendedor.nil?
        render json: {message: 'Resource not found'}, :status => :not_found
    else
      Vendedor.transaction do
        begin
          updateRelations @vendedor
        rescue => e
          @vendedor.errors[:base]<<"#{e.message}"
        end
      end
        respond_with @vendedor
    end
  end

  def updateRelations vendedor
    sucursales = []
    if(not params[:vendedor][:sucursales].nil?)
      params[:vendedor][:sucursales].each do |sucursal|
        puts ">>>>>>>>>>>>>>> SUCURSAL: #{sucursal[:id]}"
        if (sucursal[:id])
          sucursalObject = Sucursal.find(sucursal[:id])
          sucursales.push(sucursalObject)
        else
          raise "Sucursal Inexistente: #{sucursal[:descripcion]}"
        end
      end
    end
    vendedor.sucursales = sucursales
    vendedor.update_attributes(sucursales: sucursales)
    vendedor.update_attributes(vendedor_inner_params)
  end

  def destroy
    @vendedor = Vendedor.find_by(id: params[:id])
      if @vendedor.nil?
        render json: {message: 'Resource not found'}, :status => :not_found
      else
        @vendedor.activo = false
        @vendedor.save
        respond_with @vendedor
      end
  end

  def vendedor_inner_params
    params.require(:vendedor).permit(:nombre, :apellido, :direccion, :telefono, :email, :activo, :comision)
  end

  def vendedor_params
    params.require(:vendedor).permit(:nombre, :apellido, :direccion, :telefono, :email, :activo,  sucursales: [:id, :codigo, :descripcion])
  end
end
