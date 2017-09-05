# encoding: utf-8
class API::V1::RecargosController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_recargos" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_recargos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_recargos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_recargos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_recargos" end

  has_scope :unpaged, :type => :boolean
  has_scope :by_medio_pago
  has_scope :by_tipo_credito
  has_scope :by_cantidad_cuotas
  has_scope :by_all_attributes, allow_blank: true

  PER_PAGE_RECORDS = 15

  def index
    tipo = params[:tipo]
    content_type = params[:content_type]
    if content_type.eql? "pdf"
      if tipo.eql? "reporte_producto_recargo"
        @recargos = apply_scopes(Recargo)
        pdf = ProductoRecargoReportPdf.new(@recargos,params[:lista_precios],params[:producto_id],params[:empresa])
        send_data pdf.render, filename: 'reporte_producto_recargo.pdf', type: 'application/pdf', disposition: 'attachment'    
      elsif tipo.eql? "precios_venta"
       
      end
    else
  	  @recargos = apply_scopes(Recargo).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @recargos, meta: {total: apply_scopes(Recargo).all.count, total_pages: @recargos.num_pages}
    end
	end

	def show
	 respond_with Recargo.find(params[:id])
	end

	def new
  	respond_with Recargo.new
	end

	def create
    @recargo = Recargo.new(recargo_params)
    @recargo.save
    respond_with @recargo, location: nil
	end

  def update
    @recargo = Recargo.find_by(id: params[:id])
    if @recargo.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @recargo.update_attributes(recargo_params)
      respond_with @recargo, location: nil
    end
  end
  
  def destroy
    @recargo = Recargo.unscoped.find_by(id: params[:id])
    if @recargo.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @recargo.destroy
      respond_with @recargo
    end
  end

  def recargo_params
    params.require(:recargo).permit(:cantidad_cuotas, :interes, :tipo_credito_id, :medio_pago_id)
  end
end
