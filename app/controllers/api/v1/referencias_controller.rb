# encoding: utf-8
class API::V1::ReferenciasController < ApplicationController
  before_filter :ensure_authenticated_user
  respond_to :json

  has_scope :by_cliente

  PER_PAGE_RECORDS = 15

  def index
    @referencia = apply_scopes(Referencia).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @referencia, each_serializer: ReferenciaSerializer, meta: {total: apply_scopes(Referencia).all.count, total_pages: @referencia.num_pages}
  end

  def show
    respond_with Referencia.find(params[:id])
  end

  def new
    respond_with Referencia.new
  end

  def create
    @referencia = Referencia.new(referencia_params)
    @referencia.save
    respond_with @referencia
  end

  def update
    @referencia = Referencia.find_by(id: params[:id])
    if @referencia.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @referencia.update_attributes(referencia_params)
      respond_with @referencia
    end
  end

  def destroy
    @referencia = Referencia.find_by(id: params[:id])
    if @referencia.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @referencia.destroy
      respond_with @referencia
    end
  end

  def referencia_params
    params.require(:referencia).permit(:nombre, :telefono, :tipo_referencia)
  end
end
