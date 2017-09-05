# encoding: utf-8
class API::V1::TarjetasController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15
  #before_filter :only => [:index] do |c| c.isAuthorized "BE_index_tarjetas" end
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_tarjetas" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_tarjetas" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_tarjetas" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_tarjetas" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_tarjetas" end 

  has_scope :unpaged, :type => :boolean
  has_scope :by_banco
  has_scope :by_marca
  has_scope :by_afinidad
  has_scope :by_all_attributes, allow_blank: true 
  has_scope :by_activo
  has_scope :by_codigo_medio_pago

  def index
    if params[:unpaged]
      @tarjetas = apply_scopes(Tarjeta)
      render json: @tarjetas, each_serializer: TarjetaSerializer, meta: {total: apply_scopes(Tarjeta).all.count, total_pages: 0}
    else
      @tarjetas = apply_scopes(Tarjeta).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @tarjetas, each_serializer: TarjetaSerializer, meta: {total: apply_scopes(Tarjeta).all.count, total_pages: @tarjetas.num_pages}
    end
  end
  
  def show
    respond_with Tarjeta.find(params[:id])
  end

  def new
    respond_with Tarjeta.new
  end

  def create
    @tarjeta = Tarjeta.new(tarjeta_params)
    @tarjeta.activo = true
    @tarjeta.save
    respond_with @tarjeta, location: nil
  end

  def update
    @tarjeta = Tarjeta.find_by(id: params[:id])
    if @tarjeta.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tarjeta.update_attributes(tarjeta_params)
      respond_with @tarjeta, location: nil
    end
  end

  def destroy
    @tarjeta = Tarjeta.find_by(id: params[:id])
    if @tarjeta.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tarjeta.activo = false
      @tarjeta.save
      respond_with @tarjeta
    end
  end

  def tarjeta_params
    params.require(:tarjeta).permit(:banco, :marca, :medio_pago_id, :afinidad, :activo)
  end

end
