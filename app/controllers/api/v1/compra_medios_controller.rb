class API::V1::CompraMediosController < ApplicationController
    respond_to :json


    has_scope :by_id

     PER_PAGE_RECORDS = 15

    def index
      if params[:ids]
        @compra_medios = apply_scopes(CompraMedio).page.per(params[:ids].length)
      else
        @compra_medios = apply_scopes(CompraMedio).page(params[:page]).per(PER_PAGE_RECORDS)
      end
      render json: @compra_medios, meta: {total: apply_scopes(CompraMedio).all.count, total_pages: @compra_medios.num_pages}
    end

    def new
        respond_with CompraMedio.new
    end

    def create
        @medio = CompraMedio.new(compra_medio_params)
        @medio.save
        respond_with @medio, location: nil
    end

    def update
      @medio = CompraMedio.find_by(id: params[:id])
      if @medio.nil?
        render json: {message: 'Resource not found'}, :status => :not_found
      else
          @medio.update_attributes(compra_medio_params)
          respond_with @medio, location: nil
      end
    end

    def compra_medio_params
        params.require(:compra_medio).permit(:nro_cheque,:cuenta_id,:tarjeta_id,:medio_pago_id, :ids => [])
    end
end
