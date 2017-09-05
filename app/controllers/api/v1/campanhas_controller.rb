
class API::V1::CampanhasController < ApplicationController
  respond_to :json


  has_scope :by_id
  has_scope :by_persona_id
  has_scope :by_tipo_campanha
  has_scope :by_vigente
  has_scope :by_tipo_mision
  has_scope :by_tipo_contacto
  has_scope :by_tipo_mision_especifica
  has_scope :by_descripcion
  has_scope :by_nombre
  has_scope :by_activo
  has_scope :by_all_attributes,allow_blank: true


  PER_PAGE_RECORDS = 15

  def index

    if params[:ids]
      @campanhas = apply_scopes(Campanha).page.per(params[:ids].length)
    else
      @campanhas = apply_scopes(Campanha).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @campanhas, meta: {total: apply_scopes(Campanha).all.count, total_pages: @campanhas.num_pages}
  end

  def show
    respond_with Campanha.unscoped.find(params[:id])
  end

  def new
    respond_with Campanha.new
  end
  def create
    @campanha = Campanha.new(campanha_params)
    default_persona = Persona.where("ci_ruc = ?",'800456123').first
    @campanha.persona_id = default_persona.id
    @campanha.activo = true
    @campanha.save
    respond_with @campanha, location: nil
  end

  def update
    @campanha = Campanha.find_by(id: params[:id])
    if @campanha.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @campanha.update_attributes(campanha_params)
      respond_with @campanha, location: nil
    end
  end

  def destroy
    @campanha = Campanha.find_by(id: params[:id])
    if @campanha.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @campanha.activo = false
      @campanha.save
      respond_with @campanha
    end
  end

  def campanha_params
    params.require(:campanha).permit(:nombre,:descripcion,:fecha_incio,:fecha_fin,:estado,:persona_id,:tipo_campanha_id,:ids => [])
  end
end
