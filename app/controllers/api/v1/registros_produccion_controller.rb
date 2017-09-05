class API::V1::RegistrosProduccionController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_registros_produccion" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_registros_produccion" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_registros_produccion" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_registros_produccion" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_registros_produccion" end 

  has_scope :by_proceso_id
  has_scope :by_deposito_id
  has_scope :by_estado
  has_scope :by_cantidad
  has_scope :by_fecha_before
  has_scope :by_fecha_on
  has_scope :by_fecha_after
  has_scope :by_created_at, :using => [:before, :after], :type => :hash

  has_scope :by_all_attributes, allow_blank: true

  PER_PAGE_RECORDS = 15

  def index
    @registros_produccion = apply_scopes(RegistroProduccion).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @registros_produccion, each_serializer: RegistroProduccionSerializer, meta: {total: apply_scopes(RegistroProduccion).all.count, total_pages: @registros_produccion.num_pages}
  end

  def show
    respond_with RegistroProduccion.find(params[:id])
  end

  def new
  	respond_with RegistroProduccion.new
  end

  def create
    @registroProduccion = RegistroProduccion.new(registroProduccion_params)
  	@registroProduccion.save
  	respond_with @registroProduccion, location: nil
  end

  def update
    @registroProduccion = RegistroProduccion.find_by(id: params[:id])
    if @registroProduccion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      puts '---------------------------------------------------------------------------------------------------------------------'
      if @registroProduccion.estado = 'REGISTRADO' and registroProduccion_params[:estado] == 'INICIADO'
        @registroProduccion.iniciar(registroProduccion_params)
      elsif @registroProduccion.estado = 'INICIADO' and registroProduccion_params[:estado] == 'TERMINADO'
        @registroProduccion.terminar(registroProduccion_params)
      else
        puts '... ... ... ... ... ... ... Actualizado modelo '
        @registroProduccion.update_attributes(registroProduccion_params)
      end
      puts '---------------------------------------------------------------------------------------------------------------------'
      respond_with @registroProduccion, location: nil
  	end
  end

  def destroy
    puts "Destroy de registros_produccion"
    @registroViejo = RegistroProduccion.find_by(id: params[:id])

    if @registroViejo.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @registroViejo.eliminar
  		respond_with @registroViejo, location: nil
  	end
  end

  def registroProduccion_params
    params.require(:registro_produccion).permit(:cantidad, :estado, :observacion, :fecha, :proceso_id, :deposito_id)
  end

end
