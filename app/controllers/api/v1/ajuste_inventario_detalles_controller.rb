class API::V1::AjusteInventarioDetallesController < ApplicationController
	respond_to :json
	before_filter :ensure_authenticated_user

  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_ajuste_inventario_detalles" end
	before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_ajuste_inventario_detalles" end
	before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_ajuste_inventario_detalles" end
	before_filter :only => [:update]  do |c| c.isAuthorized "BE_ajuste_inventario_detalles" end
	before_filter :only => [:destroy] do |c| c.isAuthorized "BE_ajuste_inventario_detalles" end

	PER_PAGE_RECORDS = 15
	has_scope :ids, type: :array

  def index
    if params[:ids]
      @detalles = apply_scopes(AjusteInventarioDetalle).page.per(params[:ids].length)
    else
      @detalles = apply_scopes(AjusteInventarioDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @detalles, each_serializer: AjusteInventarioDetalleSerializer,
                meta: {total: apply_scopes(AjusteInventarioDetalle).all.count, total_pages: @detalles.num_pages}
  end

  def show
    respond_with AjusteInventarioDetalle.find(params[:id])
  end

  def new
    respond_with AjusteInventarioDetalle.new
  end

  def create
    @detalle = AjusteInventarioDetalle.new(ajuste_inventario_detalle_params)
    @detalle.save
    respond_with @detalle, location: nil
  end

  def update
    @detalle = AjusteInventarioDetalle.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.update_attributes(ajuste_inventario_params)
      respond_with @detalle, location: nil
    end
  end

  def destroy
    @detalle = AjusteInventarioDetalle.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.destroy
      respond_with @detalle
    end
  end

  def ajuste_inventario_params
    params.require(:ajuste_inventario).permit(:producto_id, :cantidad, :ajuste_inventario_id,:motivos_inventario_id,:lote_id)
  end
end
