class API::V1::ProduccionDetallesController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15

  has_scope :by_codigo
  has_scope :by_descripcion
  has_scope :by_all_attributes

    def index
        if (params[:unpaged])
            @producciones = apply_scopes(ProduccionDetalle).order(:id)
            render json: @producciones, each_serializer: ProduccionDetalleSerializer, meta: {total: apply_scopes(ProduccionDetalle).all.count, total_pages: 0}
        else
          @tipo_productos = apply_scopes(ProduccionDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
          render json: @tipo_productos, each_serializer: ProduccionDetalleSerializer, meta: {total: apply_scopes(ProduccionDetalle).all.count, total_pages: @tipo_productos.num_pages}
        end
    end

    def show
        respond_with ProduccionDetalle.find(params[:id])
    end

    def new
        respond_with ProduccionDetalle.new
    end

    def create
        @produccion = ProduccionDetalle.new(produccion_detalle_params)
        @produccion.save
        respond_with @produccion, location: nil
    end

    def update
        @produccion = ProduccionDetalle.find_by(id: params[:id])
        if @produccion.nil?
          render json: {message: 'Resource not found'}, :status => :not_found
        else
            @produccion.update_attributes(produccion_detalle_params)
          respond_with @produccion, location: nil
        end
    end

    def destroy
        @produccion = ProduccionDetalle.find_by(id: params[:id])
        if @produccion.nil?
          render json: {message: 'Resource not found'}, :status => :not_found
        else
            @produccion.destroy
            respond_with @produccion
  	    end
    end

    def produccion_detalle_params
        params.require(:produccion_detalle).permit(:id,:producto_id,:cantidad,:lote_id,:deposito_id)
    end
end
