# encoding: utf-8
class API::V1::CiudadesController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15
  #before_filter :only => [:index] do |c| c.isAuthorized "BE_index_ciudades" end

  has_scope :unpaged, :type => :boolean
  has_scope :by_id
  has_scope :by_codigo

  def index
    if params[:unpaged]
      @ciudades = apply_scopes(Ciudad)
      render json: @ciudades, each_serializer: CiudadSerializer, meta: {total: apply_scopes(Ciudad).all.count, total_pages: 0}
    else
      @ciudades = apply_scopes(Ciudad).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @ciudades, each_serializer: CiudadSerializer, meta: {total: apply_scopes(Ciudad).all.count, total_pages: @ciudades.num_pages}
    end
  end

  def show
    respond_with Ciudad.find(params[:id])
  end

  def new
    respond_with Ciudad.new
  end

  def create
    @ciudad = Ciudad.new(ciudad_params)
    @ciudad.save
    respond_with @ciudad
  end

  def update
    @ciudad = Ciudad.find_by(id: params[:id])
    if @ciudad.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @ciudad.update_attributes(ciudad_params)
      respond_with @ciudad
    end
  end

  def destroy
    @ciudad = Ciudad.find_by(id: params[:id])
    if @ciudad.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @ciudad.destroy
      respond_with @ciudad
    end
  end

  def ciudad_params
    params.require(:ciudad).permit(:nombre, :codigo)
  end

end
