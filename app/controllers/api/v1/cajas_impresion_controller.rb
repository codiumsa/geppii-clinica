class API::V1::CajasImpresionController < ApplicationController
    respond_to :json
     before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_cajas_impresion" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_cajas_impresion" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_cajas_impresion" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_cajas_impresion" end 
    
    has_scope :by_nombre
    PER_PAGE_RECORDS = 15
    
    
    def index
        respond_with(apply_scopes(CajaImpresion).page params[:page])
    end
    
    def show
        respond_with CajaImpresion.find(params[:id])
    end
    
    def new
        respond_with CajaImpresion.new
    end
    
    def create
        @cajaImpresion = CajaImpresion.new(cajaimp_params)
        @cajaImpresion.save
        respond_with @cajaImpresion
    end
    
    def update
        @cajaImpresion = CajaImpresion.find_by(id: params[:id])
        if @cajaImpresion.nil?
            render json: {message: 'Resource not found'}, :status => :not_found
        else
            @cajaImpresion.update_attributes(cajaimp_params)
            respond_with @cajaImpresion
        end
    end
    
    def destroy
        @cajaImpresion = CajaImpresion.find_by(id: params[:id])
        if @cajaImpresion.nil?
            render json: {message: 'Resource not found'}, :status => :not_found
        else
            @cajaImpresion.destroy  
            respond_with @cajaImpresion
        end
    end
    
    private
    
        def cajaimp_params
     params.require(:caja_impresion).permit(:nombre)
        end
end
