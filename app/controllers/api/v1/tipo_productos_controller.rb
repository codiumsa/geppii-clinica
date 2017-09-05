class API::V1::TipoProductosController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15

  has_scope :by_codigo
  has_scope :by_descripcion
  has_scope :by_all_attributes

    def index
        if (params[:unpaged])
            @tipo_productos = apply_scopes(TipoProducto).order(:id)
            render json: @tipo_productos, each_serializer: TipoProductoSerializer, meta: {total: apply_scopes(TipoProducto).all.count, total_pages: 0}
        else
          @tipo_productos = apply_scopes(TipoProducto).page(params[:page]).per(PER_PAGE_RECORDS)
          render json: @tipo_productos, each_serializer: TipoProductoSerializer, meta: {total: apply_scopes(TipoProducto).all.count, total_pages: @tipo_productos.num_pages}
        end
    end

    def show
        respond_with TipoProducto.find(params[:id])
    end

    def new
        respond_with TipoProducto.new
    end

    def create
        @tipo_productos = TipoProducto.new(tipo_producto_params)
        @tipo_productos.save
        respond_with @tipo_productos, location: nil
    end

    def update
        @tipo_productos = TipoProducto.find_by(id: params[:id])
        if @tipo_productos.nil?
          render json: {message: 'Resource not found'}, :status => :not_found
        else
            @tipo_productos.update_attributes(tipo_producto_params)
          respond_with @tipo_productos, location: nil
        end
    end

    def destroy
        @tipo_productos = TipoProducto.find_by(id: params[:id])
        if @tipo_productos.nil?
          render json: {message: 'Resource not found'}, :status => :not_found
        else
            @tipo_productos.destroy
            respond_with @tipo_productos
  	    end
    end

    def tipo_producto_params
        params.require(:tipo_producto).permit(:id,:codigo,:descripcion,:usa_lote,:procedimiento,:especialidad,:stock,:producto_osi)
    end

end
