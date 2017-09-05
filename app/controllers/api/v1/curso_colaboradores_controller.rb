class API::V1::CursoColaboradoresController < ApplicationController
  respond_to :json

  before_filter :ensure_authenticated_user

  has_scope :by_all_attributes, allow_blank: true
  has_scope :unpaged, :type => :boolean

  PER_PAGE_RECORDS = 15

  def index
    if (params[:unpaged])
      @curso_colaboradores = apply_scopes(CursoColaborador)
      render json: @curso_colaboradores, each_serializer: CursoColaboradorSerializer, meta: {total: apply_scopes(CursoColaborador).all.count, total_pages: 0}
    else
      @curso_colaboradores = apply_scopes(CursoColaborador).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @curso_colaboradores, each_serializer: CursoColaboradorSerializer, meta: {total: apply_scopes(CursoColaborador).all.count, total_pages: @curso_colaboradores.num_pages}
    end
  end


  def show
    respond_with CursoColaborador.find(params[:id])
  end

  def new
    respond_with CursoColaborador.new
  end

  def create
    @curso_colaboradores = CursoColaborador.new(curso_colaborador_params)
    @curso_colaboradores.save
    respond_with @curso_colaboradores, location: nil
  end

  def update
    @curso_colaboradores = CursoColaborador.find_by(id: params[:id])
    if @curso_colaboradores.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @curso_colaboradores.update_attributes(curso_colaborador_params)
      respond_with @curso_colaboradores, location: nil
    end
  end

  def destroy
    @curso_colaboradores = CursoColaborador.find_by(id: params[:id])
    if @curso_colaboradores.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @curso_colaboradores.destroy
      respond_with @curso_colaboradores
    end
  end

  def curso_colaborador_params
    params.require(:curso_colaborador).permit(:id, :curso_id, :colaborador_id, :observacion)
  end

end
