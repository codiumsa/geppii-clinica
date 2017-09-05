class API::V1::TipoColaboradoresController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_tipo_colaboradores" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_tipo_colaboradores" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_tipo_colaboradores" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_tipo_colaboradores" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_tipo_colaboradores" end

  has_scope :by_nombre
  has_scope :by_all_attributes, allow_blank: true
  has_scope :ids, type: :array
  has_scope :unpaged, :type => :boolean
  has_scope :by_descripcion
  #has_scope :by_activo

  PER_PAGE_RECORDS = 15

  def index

    if params[:ids]
      @tipo_colaboradores = apply_scopes(TipoColaborador).page.per(params[:ids].length)
      render json: @tipo_colaboradores, each_serializer: TipoColaboradorSerializer, meta: {total: apply_scopes(TipoColaborador).all.count, total_pages: 0}
    elsif params[:unpaged]
      @tipo_colaboradores = apply_scopes(TipoColaborador)
      render json: @tipo_colaboradores, each_serializer: TipoColaboradorSerializer, meta: {total: apply_scopes(TipoColaborador).all.count, total_pages: 0}
    else
      @tipo_colaboradores = apply_scopes(TipoColaborador).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @tipo_colaboradores, each_serializer: TipoColaboradorSerializer, meta: {total: apply_scopes(TipoColaborador).all.count, total_pages: @tipo_colaboradores.num_pages}
    end

  end

  def show
    respond_with TipoColaborador.find(params[:id])
  end

  def new
    respond_with TipoColaborador.new
  end

  def create
    @tipo_colaborador = TipoColaborador.new(tipo_colaborador_params)
    @tipo_colaborador.save
    respond_with @tipo_colaborador, location: nil
  end

  def update
    @tipo_colaborador = TipoColaborador.find_by(id: params[:id])
    if @tipo_colaborador.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tipo_colaborador.update_attributes(tipo_colaborador_params)
      respond_with @tipo_colaborador, location: nil
    end
  end

  def destroy
    @tipo_colaborador = TipoColaborador.find_by(id: params[:id])
    if @tipo_colaborador.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tipo_colaborador.destroy
      respond_with @tipo_colaborador
    end
  end

  def tipo_colaborador_params
    params.require(:tipo_colaborador).permit(:nombre, :descripcion, :tiene_viajes, :tiene_licencia, :es_club)
  end

end
