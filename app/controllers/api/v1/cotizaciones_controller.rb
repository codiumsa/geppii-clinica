class API::V1::CotizacionesController < ApplicationController
  respond_to :json

  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_cotizaciones" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_cotizaciones" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_cotizaciones" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_cotizaciones" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_cotizaciones" end 

	PER_PAGE_RECORDS = 15

  has_scope :by_moneda
  has_scope :by_moneda_base
  has_scope :ultima_cotizacion, :using => [:moneda_id, :moneda_base_id], :type => :hash
  has_scope :by_all_attributes, allow_blank: true

  def index
    if (params[:unpaged])
      @cotizaciones = apply_scopes(Cotizacion)
      render json: @cotizaciones, each_serializer: CotizacionSerializer, meta: {total: apply_scopes(Cotizacion).all.count, total_pages: 1}
    else
  	  @cotizaciones = apply_scopes(Cotizacion).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @cotizaciones, meta: {total: apply_scopes(Cotizacion).all.count, total_pages: @cotizaciones.num_pages}
    end
	end

	def show
		respond_with Cotizacion.find(params[:id])
	end

	def new
  	respond_with Cotizacion.new
	end

	def create
    @cotizacion = Cotizacion.new(cotizacion_params)
    @cotizacion.usuario_id = current_user.id
    @cotizacion.save
    respond_with @cotizacion, location: nil
	end

	#No tiene destroy, la cotización no se borra, se reemplaza por una nueva

	#tampoco hay update, por la misma razón

  def cotizacion_params
    params.require(:cotizacion).permit(:monto, :fecha_hora, :moneda_id, :moneda_base_id)
  end
end
