class API::V1::ConsultoriosController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15
  has_scope :by_descripcion
  has_scope :unpaged, :type => :boolean

  def index
    if params[:ids]
      @consultorios = apply_scopes(Consultorio).page.per(params[:ids].length)
    elsif params[:unpaged]
      @consultorios = apply_scopes(Consultorio)
      render json: @consultorios, each_serializer: ConsultorioSerializer, meta: {total: apply_scopes(Consultorio).all.count, total_pages: 0}
    else
      @consultorios = apply_scopes(Consultorio).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @consultorios, each_serializer: ConsultorioSerializer, meta: {total: apply_scopes(Consultorio).all.count, total_pages: @consultorios.num_pages}
    end
    #render json: @consultorios, meta: {total: apply_scopes(Consultorio).all.count, total_pages: @consultorios.num_pages}
  end

def show
  respond_with Consultorio.unscoped.find(params[:id])
end

  def new
      respond_with Consultorio.new
end
  def create
      @consultorio = Consultorio.new(consultorio_params)
      @consultorio.save
      respond_with @consultorio, location: nil
  end

  def update
      @consultorio = Consultorio.find_by(id: params[:id])
      if @consultorio.nil?
        render json: {message: 'Resource not found'}, :status => :not_found
      else
          @consultorio.update_attributes(consultorio_params)
          respond_with @consultorio, location: nil
      end
  end

  def destroy
    @consultorio = Consultorio.find_by(id: params[:id])
    if @consultorio.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @consultorio.destroy
      respond_with @consultorio
    end
  end

  def consultorio_params
    params.require(:consultorio).permit(:codigo,:descripcion,:especialidad_id)
  end

end
