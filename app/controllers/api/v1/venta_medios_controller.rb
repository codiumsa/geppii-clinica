class API::V1::VentaMediosController < ApplicationController
    respond_to :json

    
    has_scope :by_id

     PER_PAGE_RECORDS = 15
    
    def index
    
    if params[:ids]
      @venta_medios = apply_scopes(VentaMedio).page.per(params[:ids].length)
    else
      @venta_medios = apply_scopes(VentaMedio).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @venta_medios, meta: {total: apply_scopes(VentaMedio).all.count, total_pages: @venta_medios.num_pages}      
  end

    def new
        respond_with VentaMedio.new
  end
    def create
           @medio = VentaMedio.new(venta_medio_params)
        @medio.save
        respond_with @medio, location: nil
    end
    
    def update
        @medio = VentaMedio.find_by(id: params[:id])
        if @medio.nil?
          render json: {message: 'Resource not found'}, :status => :not_found
        else
            @medio.update_attributes(venta_medio_params)
            respond_with @medio, location: nil
        end
    end

    def venta_medio_params
            params.require(:venta_medio).permit(:monto,:tarjeta_id,:medio_pago_id, :ids => [])
    end
end