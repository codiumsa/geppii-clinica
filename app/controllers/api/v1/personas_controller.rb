# encoding: utf-8
class API::V1::PersonasController < ApplicationController
  respond_to :json

  has_scope :by_razon_social
  has_scope :by_ciRuc
  PER_PAGE_RECORDS = 15


  def index
    @personas = apply_scopes(Persona).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @personas, each_serializer: PersonaSerializer, meta: {total: apply_scopes(Persona).all.count, total_pages: @personas.num_pages}
  end

  def show
    respond_with Persona.find(params[:id])
  end

  def new
    respond_with Persona.new
  end

  def create
    @persona = Persona.new(persona_params)
    @persona.save
    respond_with @persona
  end

  def update
    @persona = Persona.find_by(id: params[:id])
    if @persona.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @persona.update_attributes(persona_params)
      respond_with @persona
    end
  end

  def destroy
    @persona = Persona.find_by(id: params[:id])
    if @persona.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @persona.destroy
      respond_with @persona
    end
  end

  def persona_params
    params.require(:persona).permit(:tipo_persona, :ci_ruc,:edad,:razon_social, :direccion, :barrio, :telefono, :celular, :estado_civil, :fecha_nacimiento, :correo, :ciudad_id)
  end
end
