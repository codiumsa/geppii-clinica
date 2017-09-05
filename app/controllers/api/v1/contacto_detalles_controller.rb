class API::V1::ContactoDetallesController < ApplicationController
  respond_to :json

  before_filter :ensure_authenticated_user

  has_scope :by_all_attributes, allow_blank: true
  has_scope :unpaged, :type => :boolean

  PER_PAGE_RECORDS = 15

  def index
    if (params[:unpaged])
      @contacto_detalles = apply_scopes(ContactoDetalle)
      render json: @contacto_detalles, each_serializer: ContactoDetalleSerializer, meta: {total: apply_scopes(ContactoDetalle).all.count, total_pages: 0}
    else
      @contacto_detalles = apply_scopes(ContactoDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @contacto_detalles, each_serializer: ContactoDetalleSerializer, meta: {total: apply_scopes(ContactoDetalle).all.count, total_pages: @contacto_detalles.num_pages}
    end
  end


  def show
    respond_with ContactoDetalle.find(params[:id])
  end

  def new
    respond_with ContactoDetalle.new
  end

  def create
    @contacto_detalles = ContactoDetalle.new(contacto_detalle_params)
    @contacto_detalles.save
    respond_with @contacto_detalles, location: nil
  end

  def update
    @contacto_detalles = ContactoDetalle.find_by(id: params[:id])
    if @contacto_detalles.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @contacto_detalles.update_attributes(contacto_detalle_params)
      respond_with @contacto_detalles, location: nil
    end
  end

  def destroy
    @contacto_detalles = ContactoDetalle.find_by(id: params[:id])
    if @contacto_detalles.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @contacto_detalles.destroy
      respond_with @contacto_detalles
    end
  end

  def contacto_detalle_params
    params.require(:contacto_detalle).permit(:id, :fecha, :fecha_siguiente, :observacion,:comentario,:compromiso,:estado,:contacto_id,:moneda_id)
  end

end
