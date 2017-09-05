class API::V1::CampanhasColaboradoresController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user

  PER_PAGE_RECORDS = 15
  has_scope :ids, type: :array
  def index
    if params[:ids]
      @detalles = apply_scopes(CampanhaColaborador).page.per(params[:ids].length)
    else
      @detalles = apply_scopes(CampanhaColaborador).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @detalles, each_serializer: CampanhaColaboradorSerializer,
      meta: {total: apply_scopes(CampanhaColaborador).all.count, total_pages: @detalles.num_pages}
  end

  def show
    respond_with CampanhaColaborador.find(params[:id])
  end

  # def new
  #   respond_with CampanhaColaborador.valid?
  # end

  def new
    respond_with CampanhaColaborador.new
  end

  def create
    @campanha_colaborador = CampanhaColaborador.new(campanha_colaborador_params)
    @campanha_colaborador.save
    respond_with @campanha_colaborador, location: nil
  end

  def update
    @campanha_colaborador = CampanhaColaborador.find_by(id: params[:id])
    if @campanha_colaborador.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @campanha_colaborador.update_attributes(campanha_colaborador_params)
      respond_with @campanha_colaborador, location: nil
    end
  end

  def destroy
    @campanha_colaborador = CampanhaColaborador.find_by(id: params[:id])
    if @campanha_colaborador.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @campanha_colaborador.destroy
      respond_with @campanha_colaborador
    end
  end

  def campanha_colaborador_params
    params.require(:campanha_colaborador).permit(:id, :campanha_id, :colaborador_id, :observaciones)
  end
end
