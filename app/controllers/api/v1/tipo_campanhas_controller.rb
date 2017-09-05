class API::V1::TipoCampanhasController < ApplicationController
  respond_to :json

  before_filter :ensure_authenticated_user

  has_scope :by_all_attributes, allow_blank: true
  has_scope :unpaged, :type => :boolean

  PER_PAGE_RECORDS = 15

  def index
    if (params[:unpaged])
      @tipo_campanhas = apply_scopes(TipoCampanha)
      render json: @tipo_campanhas, each_serializer: TipoCampanhaSerializer, meta: {total: apply_scopes(TipoCampanha).all.count, total_pages: 0}
    else
      @tipo_campanhas = apply_scopes(TipoCampanha).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @tipo_campanhas, each_serializer: TipoCampanhaSerializer, meta: {total: apply_scopes(TipoCampanha).all.count, total_pages: @tipo_campanhas.num_pages}
    end
  end


  def show
    respond_with TipoCampanha.find(params[:id])
  end

  def new
    respond_with TipoCampanha.new
  end

  def create
    @tiposCampanhas = TipoCampanha.new(tipo_campanha_params)
    @tiposCampanhas.save
    respond_with @tiposCampanhas, location: nil
  end

  def update
    @tipo_campanhas = TipoCampanha.find_by(id: params[:id])
    if @tipo_campanhas.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tipo_campanhas.update_attributes(tipo_campanha_params)
      respond_with @tipo_campanhas, location: nil
    end
  end

  def destroy
    @tipo_campanhas = TipoCampanha.find_by(id: params[:id])
    if @tipo_campanhas.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tipo_campanhas.destroy
      respond_with @tipo_campanhas
    end
  end

  def tipo_campanha_params
    params.require(:tipo_campanha).permit(:id, :nombre, :descripcion)
  end

end
