class API::V1::ProcesoDetallesController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_procesos" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_procesos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_procesos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_procesos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_procesos" end 
  

  has_scope :ids, type: :array
  PER_PAGE_RECORDS = 15


  def index
    if params[:ids]
      @detalles = apply_scopes(ProcesoDetalle).page.per(params[:ids].length)
    else
      @detalles = apply_scopes(ProcesoDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @detalles, each_serializer: ProcesoDetalleSerializer, 
                meta: {total: apply_scopes(ProcesoDetalle).all.count, total_pages: @detalles.num_pages}
  end

  def show
    respond_with ProcesoDetalle.find(params[:id])
  end

  def new
    respond_with ProcesoDetalle.new
  end

  def create
    @procesoDetalle = ProcesoDetalle.new(proceso_detalle_params)
    @procesoDetalle.save
    respond_with @procesoDetalle, location: nil
  end

  def update
    @procesoDetalle = ProcesoDetalle.find_by(id: params[:id])
    if @procesoDetalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @procesoDetalle.update_attributes(proceso_detalle_params)
      respond_with @procesoDetalle, location: nil
    end
  end

  def destroy
    @procesoDetalle = ProcesoDetalle.find_by(id: params[:id])
    if @procesoDetalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @procesoDetalle.destroy
      respond_with @procesoDetalle
    end
  end

  def proceso_detalle_params
    params.require(:proceso_detalle).permit(:producto_id, :cantidad, :proceso_id)
  end
end
