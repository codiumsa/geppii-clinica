class API::V1::ViajeColaboradoresController < ApplicationController
  respond_to :json

  before_filter :ensure_authenticated_user

  has_scope :by_all_attributes, allow_blank: true
  has_scope :unpaged, :type => :boolean

  PER_PAGE_RECORDS = 15

  def index
    if (params[:unpaged])
      @viaje_colaboradores = apply_scopes(ViajeColaborador)
      render json: @viaje_colaboradores, each_serializer: ViajeColaboradorSerializer, meta: {total: apply_scopes(ViajeColaborador).all.count, total_pages: 0}
    else
      @viaje_colaboradores = apply_scopes(ViajeColaborador).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @viaje_colaboradores, each_serializer: ViajeColaboradorSerializer, meta: {total: apply_scopes(ViajeColaborador).all.count, total_pages: @viaje_colaboradores.num_pages}
    end
  end


  def show
    respond_with ViajeColaborador.find(params[:id])
  end

  def new
    respond_with ViajeColaborador.new
  end

  def create
    @viaje_colaboradores = ViajeColaborador.new(viaje_colaborador_params)
    @viaje_colaboradores.save
    respond_with @viaje_colaboradores, location: nil
  end

  def update
    @viaje_colaboradores = ViajeColaborador.find_by(id: params[:id])
    if @viaje_colaboradores.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @viaje_colaboradores.update_attributes(viaje_colaborador_params)
      respond_with @viaje_colaboradores, location: nil
    end
  end

  def destroy
    @viaje_colaboradores = ViajeColaborador.find_by(id: params[:id])
    if @viaje_colaboradores.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @viaje_colaboradores.destroy
      respond_with @viaje_colaboradores
    end
  end

  def viaje_colaborador_params
    params.require(:viaje_colaborador).permit(:id, :viaje_id, :colaborador_id, :observacion,:companhia,:costo_ticket,:costo_estadia)
  end

end
