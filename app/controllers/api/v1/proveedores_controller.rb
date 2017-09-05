class API::V1::ProveedoresController < ApplicationController
	respond_to :json
 	#before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_proveedores" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_proveedores" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_proveedores" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_proveedores" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_proveedores" end 

 	PER_PAGE_RECORDS = 15

  	has_scope :by_all_attributes, allow_blank: true
	has_scope :ignorar_proveedor_default
	has_scope :ruc

 	#has_scope :by_razon_social
 	has_scope :by_ruc
 	
 	#has_scope :direccion
 	#has_scope :telefono
 	#has_scope :email
 	#has_scope :email
 	#has_scope :persona_contacto
 	#has_scope :telefono_contacto

 	#has_scope :by_created_at, :using => [:before, :after], :type => :hash
 	has_scope :unpaged, :type => :boolean

 	def index
    	if (params[:unpaged]) 
	      @proveedores = apply_scopes(Proveedor)
	      render json: @proveedores, each_serializer: ProveedorSerializer, meta: {total: apply_scopes(Proveedor).all.count, total_pages: 0}
	    else 
	      @proveedores = apply_scopes(Proveedor).page(params[:page]).per(PER_PAGE_RECORDS)
	      render json: @proveedores, each_serializer: ProveedorSerializer, meta: {total: apply_scopes(Proveedor).all.count, total_pages: @proveedores.num_pages}
	    end
 	end

 	def show
    	respond_with Proveedor.find(params[:id])
  	end

	def new
		respond_with Proveedor.new
	end

	def create
		@proveedor = Proveedor.new(proveedor_params)
		@proveedor.save
		respond_with @proveedor
	end

	def update
		@proveedor = Proveedor.find_by(id: params[:id])
		if @proveedor.nil?
	    	render json: {message: 'Resource not found'}, :status => :not_found
		else
	  		@proveedor.update_attributes(proveedor_params)
	    	respond_with @proveedor
		end
	end

	def destroy
		@proveedor = Proveedor.find_by(id: params[:id])
    if @proveedor.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @proveedor.eliminar
      respond_with @proveedor
    end
	end

	def proveedor_params
		params.require(:proveedor).permit(:razon_social, :ruc, :direccion, :telefono, :email, :persona_contacto,
			:telefono_contacto)
	end
end
