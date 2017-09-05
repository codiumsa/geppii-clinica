class API::V1::CajasController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  ##before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_cajas" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_cajas" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_cajas" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_cajas" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_cajas" end 

  has_scope :by_codigo
  has_scope :by_descripcion
  has_scope :obtenerCajas, :type => :boolean
  #has_scope :obtenerCajaChica, :type => :boolean
  has_scope :by_all_attributes, allow_blank: true
  has_scope :sucursal
  has_scope :by_caja_destino_id
  has_scope :by_tipo_caja
  has_scope :by_username
  has_scope :unpaged, :type => :boolean
  has_scope :by_cajas_permitidas  

  PER_PAGE_RECORDS = 15

  def index
    puts "UNPAGED #{params[:unpaged]}"
    if params[:by_cajas_permitidas]
      @cajas = Caja.by_cajas_permitidas(current_user, current_sucursal)
    elsif params[:by_usuario]
      @cajas = Caja.by_usuario(current_user)
    elsif params[:by_sucursal]
      @cajas = Caja.by_sucursal(current_sucursal)
		elsif params[:monitoreo]
      #ver que sucursal poner
			@cajas = Caja.where("tipo_caja = 'U' and abierta = true")
    elsif params[:unpaged]
      @cajas = apply_scopes(Caja)
    else
      @cajas = apply_scopes(Caja).page(params[:page]).per(PER_PAGE_RECORDS)
      total = apply_scopes(Caja).all.count
    end

    if not total.nil?
      render json: @cajas, each_serializer: CajaSerializer, meta: {total: total, total_pages: @cajas.num_pages}
    else
      for caja in @cajas 
        caja.necesitaAlivio(current_sucursal)
      end

      render json: @cajas, each_serializer: CajaSerializer
    end
  end

  def show
    if (params[:id] === 'current_caja')
      respond_with current_caja
    else
      respond_with Caja.find(params[:id])
    end
  end

  def new
  	respond_with Caja.new
  end


  def create
  	@caja = Caja.new(caja_params)
    @caja.moneda = get_parametros_empresa().moneda_base
  	@caja.save
    #@caja.inicializarCaja

  	respond_with @caja
  end

  def update
    @caja = Caja.find_by(id: params[:id])
    if @caja.nil?
    	render json: {message: 'Resource not found'}, :status => :not_found
    else
  		@caja.update_attributes(caja_params)
     	respond_with @caja
  	end
  end

  def destroy
    @caja = Caja.find_by(id: params[:id])
    if @caja.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
  		@caja.destroy
  		respond_with @caja
  	end
  end

  def caja_params
  	params.require(:caja).permit(:codigo, :descripcion, :sucursal_id, :tipo_caja, :usuario_id, :saldo, :abierta)
  end

end
