class API::V1::TratamientosController < ApplicationController
  respond_to :json
  has_scope :by_nombre
  has_scope :by_all_attributes
       
  PER_PAGE_RECORDS = 15
  
  def index
    #aplica los filtros que vienen en el request
    #por ej by_nombre=
    #tiene que existir un has_scope identico
    #en el modelo.rb debe existir el scope
    
    @tratamientos = apply_scopes(Tratamiento).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @tratamientos, each_serializer: TratamientoSerializer,
           meta: {total: apply_scopes(Tratamiento).all.count, total_pages: @tratamientos.num_pages}
    #respond_with :tratamiento => @tratamientos, :total_pages => @tratamientos.num_pages, :total => Tratamiento.count
    
  end

  def show
    respond_with Tratamiento.find(params[:id])
    
  end

  def new
    respond_with Tratamiento.new
  end

  def create
    Tratamiento.transaction do
      @tratamiento = Tratamiento.new(tratamiento_inner_params)
      @tratamiento.save
    end
    respond_with @tratamiento
  end

  def update
    @tratamiento = Tratamiento.find_by(id: params[:id])
    if @tratamiento.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tratamiento.update_attributes(tratamiento_params)
      respond_with @tratamiento, location: nil
    end
  end
  

  def destroy
    @tratamiento = Tratamiento.find_by(id: params[:id])
    if @tratamiento.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @tratamiento.destroy
      respond_with @tratamiento
    end
  end

  def tratamiento_params
    params.require(:tratamiento).permit(:nombre, :especialidad_id)
  end

  def tratamiento_inner_params
    params.require(:tratamiento).permit(:nombre, :especialidad_id)
  end
end
