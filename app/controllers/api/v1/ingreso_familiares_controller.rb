# encoding: utf-8
class API::V1::IngresoFamiliaresController < ApplicationController
  before_filter :ensure_authenticated_user
  respond_to :json

  has_scope :by_cliente

  PER_PAGE_RECORDS = 15

  def index
    @ingresoFamiliares = apply_scopes(IngresoFamiliar).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @ingresoFamiliares, each_serializer: IngresoFamiliarSerializer, meta: {total: apply_scopes(IngresoFamiliar).all.count, total_pages: @ingresoFamiliares.num_pages}
  end

  def show
    respond_with IngresoFamiliar.find(params[:id])
  end

  def new
    respond_with IngresoFamiliar.new
  end

  def create
    @ingresoFamiliar = IngresoFamiliar.new(ingreso_familiar_params)
    @ingresoFamiliar.save
    respond_with @ingresoFamiliar
  end

  def update
    @ingresoFamiliar = IngresoFamiliar.find_by(id: params[:id])
    if @ingresoFamiliar.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @ingresoFamiliar.update_attributes(ingreso_familiar_params)
      respond_with @ingresoFamiliar
    end
  end

  def destroy
    @ingresoFamiliar = IngresoFamiliar.find_by(id: params[:id])
    if @ingresoFamiliar.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @ingresoFamiliar.destroy
      respond_with @ingresoFamiliar
    end
  end

  def ingreso_familiar_params
    params.require(:ingresoFamiliar).permit(:ingreso_mensual, vinculo_familiar: [:id, :tipo])
  end
  
  def ingreso_familiar_inner_params
    params.require(:ingresoFamiliar).permit(:ingreso_mensual)
  end
end
