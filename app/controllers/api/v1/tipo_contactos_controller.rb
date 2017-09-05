# encoding: utf-8
class API::V1::TipoContactosController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_tipo_contactos" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_tipo_contactos" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_tipo_contactos" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_tipo_contactos" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_tipo_contactos" end

  has_scope :by_all_attributes

  has_scope :unpaged, :type => :boolean
  has_scope :by_activo, :type => :boolean

  PER_PAGE_RECORDS = 15

  def index
    if params[:unpaged]
      @tipo_contactos = apply_scopes(TipoContacto).page(params[:page])
    else
      @tipo_contactos = apply_scopes(TipoContacto).page(params[:page]).per(PER_PAGE_RECORDS)
    end
    render json: @tipo_contactos, each_serializer: TipoContactoSerializer, meta: {total: apply_scopes(TipoContacto).all.count, total_pages: @tipo_contactos.num_pages}
  end


  def show
    respond_with TipoContacto.find(params[:id])
  end

  def new
    respond_with TipoContacto.new
  end

  def create
    @tipoContactos = TipoContacto.new(tipo_contacto_params)
    @tipoContactos.activo = true
    @tipoContactos.save
    respond_with @tipoContactos, location: nil
  end

  def update
    @tipo_contactos = TipoContacto.find_by(id: params[:id])
    if @tipo_contactos.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tipo_contactos.update_attributes(tipo_contacto_params)
      respond_with @tipo_contactos, location: nil
    end
  end

  def destroy
    @tipo_contactos = TipoContacto.find_by(id: params[:id])
    if @tipo_contactos.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tipo_contactos.eliminar
      respond_with @tipo_contactos
    end
  end

  def tipo_contacto_params
    params.require(:tipo_contacto).permit(:id, :descripcion, :codigo, :con_campanha, :con_mision, :activo)
  end
end
