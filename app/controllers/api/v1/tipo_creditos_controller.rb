class API::V1::TipoCreditosController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_tipo_creditos" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_tipo_creditos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_tipo_creditos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_tipo_creditos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_tipo_creditos" end 

  #has_scope :by_descripcion
  #has_scope :by_plazo
  #has_scope :by_unidad_tiempo  

  has_scope :by_contado, :type => :boolean
  has_scope :by_credito, :type => :boolean
  has_scope :unpaged, :type => :boolean

  has_scope :by_all_attributes, allow_blank: true

  PER_PAGE_RECORDS = 15

  def index

    if (params[:unpaged]) 
      @tipo_creditos = apply_scopes(TipoCredito)
      render json: @tipo_creditos, each_serializer: TipoCreditoSerializer, meta: {total: apply_scopes(TipoCredito).all.count, total_pages: 0}
    else 
      @tipo_creditos = apply_scopes(TipoCredito).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @tipo_creditos, each_serializer: TipoCreditoSerializer, meta: {total: apply_scopes(TipoCredito).all.count, total_pages: @tipo_creditos.num_pages}
    end
    
  end


  def show
    respond_with TipoCredito.find(params[:id])
  end

  def new
  	respond_with TipoCredito.new
  end

  def create
  	@tipoCreditos = TipoCredito.new(tipo_credito_params)
  	@tipoCreditos.save
  	respond_with @tipoCreditos, location: nil
  end

  def update
    @tipo_creditos = TipoCredito.find_by(id: params[:id])
    if @tipo_creditos.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
  		@tipo_creditos.update_attributes(tipo_credito_params)
      respond_with @tipo_creditos, location: nil
  	end
  end

  def destroy
    @tipo_creditos = TipoCredito.find_by(id: params[:id])
    if @tipo_creditos.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
  		@tipo_creditos.destroy
  		respond_with @tipo_creditos
  	end
  end

  def tipo_credito_params
  	params.require(:tipo_credito).permit(:id, :descripcion, :plazo, :unidad_tiempo)
  end

end