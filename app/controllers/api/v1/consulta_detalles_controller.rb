class API::V1::ConsultaDetallesController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user

  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_consulta_detalles" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_consulta_detalles" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_consulta_detalles" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_consulta_detalles" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_consulta_detalles" end

  PER_PAGE_RECORDS = 15
  has_scope :ids, type: :array
  def index
    if params[:ids]
      @detalles = apply_scopes(ConsultaDetalle).page.per(params[:ids].length)
    else
      @detalles = apply_scopes(ConsultaDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @detalles, each_serializer: ConsultaDetalleSerializer,
      meta: {total: apply_scopes(ConsultaDetalle).all.count, total_pages: @detalles.num_pages}
  end

  def show
    respond_with ConsultaDetalle.find(params[:id])
  end

  # def new
  #   respond_with ConsultaDetalle.valid?
  # end

  def new
    respond_with ConsultaDetalle.new
  end

  def create
    @consulta_detalle = ConsultaDetalle.new(consulta_detalle_params)
    @consulta_detalle.save
    respond_with @consulta_detalle, location: nil
  end

  def update
    @consulta_detalle = ConsultaDetalle.find_by(id: params[:id])
    if @consulta_detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @consulta_detalle.update_attributes(consulta_detalle_params)
      respond_with @consulta_detalle, location: nil
    end
  end

  def destroy
    @consulta_detalle = ConsultaDetalle.find_by(id: params[:id])
    if @consulta_detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @consulta_detalle.destroy
      respond_with @consulta_detalle
    end
  end

  def consulta_detalle_params
    params.require(:consulta_detalle).permit(:producto_id, :cantidad, :consulta_id,:consentimiento_firmado)
  end
end
