class API::V1::CursosController < ApplicationController
  respond_to :json


  has_scope :by_id
  has_scope :by_colaborador_id
  has_scope :by_fecha_before
  has_scope :by_fecha_after
  has_scope :by_fecha_on
  has_scope :by_lugar
  

  PER_PAGE_RECORDS = 15

  def index
    content_type = params[:content_type]
    tipo = params[:tipo]
    if content_type.eql? "xls"
      if tipo.eql? "reporte_cursos"
        @cursos = apply_scopes(Curso).order(:fecha_inicio).reverse_order
        render xlsx: 'cursos', filename: "cursos.xlsx"
      end
    else
      if params[:ids]
        @cursos = apply_scopes(Curso).page.per(params[:ids].length)
      else
        @cursos = apply_scopes(Curso).page(params[:page]).per(PER_PAGE_RECORDS)
      end
      render json: @cursos, meta: {total: apply_scopes(Curso).all.count, total_pages: @cursos.num_pages}
    end
  end

  def show
    respond_with Curso.unscoped.find(params[:id])
  end

  def new
    respond_with Curso.new
  end
  def create
    @curso = Curso.new(curso_params)
    if (not params[:curso][:curso_colaboradores].nil?)
      curso_colaboradores = []
      params[:curso][:curso_colaboradores].each do |cursoColaborador|
        curso_colaborador = CursoColaborador.new(colaborador_id: cursoColaborador[:colaborador_id],observacion: cursoColaborador[:observacion])
        curso_colaboradores.push(curso_colaborador)
      end
      @curso.curso_colaboradores = curso_colaboradores
    end
    @curso.save
    respond_with @curso, location: nil
  end

  def update
    @curso = Curso.find_by(id: params[:id])
    if @curso.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @curso.update_attributes(curso_params)

      if (not params[:curso][:curso_colaboradores].nil?)
        @curso_colaboradores = []
        params[:curso][:curso_colaboradores].each do |cursoColaborador|
          @curso_colaborador = CursoColaborador.new(colaborador_id: cursoColaborador[:colaborador_id],observacion: cursoColaborador[:observacion])
          @curso_colaboradores.push(@curso_colaborador)
        end

        lista_vieja = Curso.find(params[:id])

         lista_vieja.curso_colaboradores.map do |elementoViejo|
           if !@curso_colaboradores.include?(elementoViejo)
             elementoViejo.destroy
           end
         end
        @curso.curso_colaboradores = @curso_colaboradores
      else
        @curso.curso_colaboradores = []
      end


      respond_with @curso, location: nil
    end
  end

	def destroy
    @curso = Curso.find_by(id: params[:id])
    if @curso.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @curso.destroy
			respond_with @curso
  	end
  end

  def curso_params
    params.require(:curso).permit(:id,:descripcion,:fecha_inicio, :lugar, :fecha_fin,:observaciones,:ids => [])
  end

  def curso_inner_params
    params.require(:curso).permit(:descripcion,:fecha_inicio, :lugar, :fecha_fin,:observaciones,curso_colaboradores:[:curso_id,:colaborador_id,:observacion])
  end
end
