class API::V1::CategoriaClientesPromocionesController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user

  has_scope :by_categoria_cliente
  
  PER_PAGE_RECORDS = 15
  
  def index
    @categoria_cliente_promociones = apply_scopes(CategoriaClientePromocion).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @categoria_cliente_promociones, each_serializer: CategoriaClientePromocionSerializer, meta: {total: apply_scopes(CategoriaClientePromocion).all.count, total_pages: @categoria_cliente_promociones.num_pages}
  end

  def show
    respond_with CategoriaClientePromocion.find(params[:id])
  end

  def new
    respond_with CategoriaClientePromocion.new
  end

  def create
    @categoria_cliente_promocion = CategoriaClientePromocion.new(categoria_cliente_promociones_params)
    @categoria_cliente_promocion.save
    respond_with @categoria_cliente_promocion, location: nil
  end

  def update
    @categoria_cliente_promocion = CategoriaClientePromocion.find_by(id: params[:id])
    if @categoria_cliente_promocion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @categoria_cliente_promocion.update_attributes(producto_params)
      respond_with @categoria_cliente_promocion, location: nil
    end
  end

  def destroy
    @categoria_cliente_promocion = CategoriaClientePromocion.find_by(id: params[:id])
    if @categoria_cliente_promocion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @categoria_cliente_promocion.destroy
      respond_with @categoria_cliente_promocion
    end
  end

  def categoria_cliente_promociones_params
    params.require(:categoria_cliente_promocion).permit(:id, :categoria_cliente_id, :promocion_id)
  end

end
