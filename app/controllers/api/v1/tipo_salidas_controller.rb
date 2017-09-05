class API::V1::TipoSalidasController < ApplicationController
    respond_to :json

    has_scope :by_codigo


     PER_PAGE_RECORDS = 15

    def index

    if params[:ids]
      @tipos_salida = apply_scopes(TipoSalida).page.per(params[:ids].length)
      render json: @tipos_salida, meta: {total: apply_scopes(TipoSalida).all.count, total_pages: @tipos_salida.num_pages}

    elsif params[:unpaged]
      @tipos_salida = TipoSalida.all
      render json: @tipos_salida.to_a, each_serializer: TipoSalidaSerializer, meta: {total: apply_scopes(TipoSalida).all.count, total_pages: 0}
    else
      @tipos_salida = apply_scopes(TipoSalida).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @tipos_salida, meta: {total: apply_scopes(TipoSalida).all.count, total_pages: @tipos_salida.num_pages}

    end

  end

  def show
    respond_with TipoSalida.find(params[:id])
  end

    # def new
    #     respond_with VentaMedio.new
    # end
    # def create
    #        @medio = VentaMedio.new(venta_medio_params)
    #     @medio.save
    #     respond_with @medio, location: nil
    # end
    #
    # def update
    #     @medio = VentaMedio.find_by(id: params[:id])
    #     if @medio.nil?
    #       render json: {message: 'Resource not found'}, :status => :not_found
    #     else
    #         @medio.update_attributes(venta_medio_params)
    #         respond_with @medio, location: nil
    #     end
    # end

    def tipo_salida_params
            params.require(:tipo_salida).permit(:codigo,:descripcion)
    end
end
