# encoding: utf-8
class API::V1::CalificacionesController < ApplicationController
	respond_to :json
  before_filter :ensure_authenticated_user

  PER_PAGE_RECORDS = 15
  
  has_scope :unpaged, :type => :boolean
  has_scope :by_codigo
  has_scope :by_all_attributes

  def index
    if params[:unpaged]
      @calificaciones = apply_scopes(Calificacion)
      render json: @calificaciones, each_serializer: CalificacionSerializer, meta: {total: apply_scopes(Calificacion).all.count, total_pages: 0}
    else
      @calificaciones = apply_scopes(Calificacion).page(params[:page]).per(PER_PAGE_RECORDS).order('dias_atraso ASC')
      render json: @calificaciones, each_serializer: CalificacionSerializer, meta: {total: apply_scopes(Calificacion).all.count, total_pages: @calificaciones.num_pages}
    end
  end

  def show
    respond_with Calificacion.find(params[:id])
  end	

  def create
    @calificacion = Calificacion.new(calificacion_params)
    @calificacion.save
    respond_with @calificacion
  end

  def update
    @calificacion = Calificacion.find_by(id: params[:id])
    if @calificacion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @calificacion.update_attributes(calificacion_params)
      puts '[ccalificaciones_controller.rb].update: '
      respond_with @calificacion
    end
  end

  def destroy
    @calificacion = Calificacion.find_by(id: params[:id])
    if @calificacion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @calificacion.destroy
      respond_with @calificacion
    end
  end

  def calificacion_params
    params.require(:calificacion).permit(:codigo, :descripcion, :dias_atraso)
  end
end
