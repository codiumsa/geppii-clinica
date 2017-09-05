class API::V1::EspecialidadesController < ApplicationController
  respond_to :json
  has_scope :by_descripcion
  has_scope :habilita_consulta
  

  def index
      if (params[:unpaged])
          @especialidad = apply_scopes(Especialidad).order(:id)
          render json: @especialidad, each_serializer: EspecialidadSerializer, meta: {total: apply_scopes(Especialidad).all.count, total_pages: 0}
      else
        @especialidad = apply_scopes(Especialidad).page(params[:page]).per(PER_PAGE_RECORDS)
        render json: @especialidad, each_serializer: EspecialidadSerializer, meta: {total: apply_scopes(Especialidad).all.count, total_pages: @especialidad.num_pages}
      end
  end


  def show
    respond_with Especialidad.find(params[:id])
  end


end
