# encoding: utf-8
class API::V1::FichasCirugiaController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #ActionController::Parameters.permit_all_parameters = true
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_fichas_cirugia" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_fichas_cirugia" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_fichas_cirugia" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_fichas_cirugia" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_fichas_cirugia" end

  # has_scope :by_nombre
  has_scope :by_all_attributes, allow_blank: true
  has_scope :ids, type: :array
  has_scope :unpaged, :type => :boolean
  has_scope :paciente_id
  has_scope :diagnosticos
  has_scope :diagnosticos_by_tipo
  has_scope :tratamientos
  has_scope :tratamientos_by_tipo
  has_scope :tipos_tratamiento
  has_scope :tipos_diagnostico
  has_scope :paciente_id_fichas


  PER_PAGE_RECORDS = 15

  def index
    puts "Parametros!! #{params}"
    if params[:diagnosticos]
      render json: Diagnostico.getDiagnosticos
    elsif params[:diagnosticos_by_tipo]
      render json: Diagnostico.getDiagnosticosByTipo(params[:diagnosticos_by_tipo])
    elsif params[:tratamientos]
      render json: Diagnostico.getTratamientos
    elsif params[:tratamientos_by_tipo]
      render json: Diagnostico.getTratamientosByTipo(params[:tratamientos_by_tipo])
    elsif params[:tipos_tratamiento]
      render json: Diagnostico.getTiposTratamiento()
    elsif params[:tipos_diagnostico]
      render json: Diagnostico.getTiposDiagnostico()
    elsif params[:ids]
      @fichas_cirugia = apply_scopes(FichaCirugia).page.per(params[:ids].length)
      render json: @fichas_cirugia,
        each_serializer: FichaCirugiaSerializer,
        meta: {total: apply_scopes(FichaCirugia).all.count, total_pages: 0}
    elsif params[:unpaged]
      @fichas_cirugia = apply_scopes(FichaCirugia)
      render json: @fichas_cirugia,
        each_serializer: FichaCirugiaSerializer,
        meta: {total: apply_scopes(FichaCirugia).all.count, total_pages: 0}
    else
      @fichas_cirugia = apply_scopes(FichaCirugia)
      .page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @fichas_cirugia,
        each_serializer: FichaCirugiaSerializer,
        meta: {total: apply_scopes(FichaCirugia).all.count,
               total_pages: @fichas_cirugia.num_pages}
        end
  end

  def show
    respond_with FichaCirugia.find(params[:id])
  end

  def new
    respond_with FichaCirugia.new
  end

  def create
    @ficha_cirugia = FichaCirugia.new()
    fparams = params[:ficha_cirugia]
    @paciente = Paciente.find_by(id: fparams[:paciente_id])
    # puts fparams[:fistula].to_json

    puts @paciente
    if @paciente != nil
      #@ficha_cirugia.update_attributes(ficha_cirugia_params)
      @ficha_cirugia.update_attribute(:tratamientos_realizados,
                                      fparams[:tratamientos_realizados].to_json)
      @ficha_cirugia.update_attribute(:diagnosticos_realizados,
                                                      fparams[:diagnosticos_realizados].to_json)
      @ficha_cirugia.update_attribute(:diagnostico_inicial,
                                      fparams[:diagnostico_inicial])
      @ficha_cirugia.update_attribute(:externo,
                                      fparams[:externo])
      @ficha_cirugia.update_attribute(:anho_mision,
                                      fparams[:anho_mision])
      @ficha_cirugia.update_attribute(:anho_mision,
                                      fparams[:anho_mision])
      @ficha_cirugia.update_attribute(:fecha_consulta_inicial,
                                      fparams[:fecha_consulta_inicial])
      @ficha_cirugia.update_attribute(:colaborador_id,
                                      fparams[:colaborador_id])
      @ficha_cirugia.update_attribute(:paciente_id,
                                      fparams[:paciente_id])
      @ficha_cirugia.update_attribute(:campanha_id,
                                      fparams[:campanha_id])
      @ficha_cirugia.update_attribute(:necesita_cirugia,
                                      fparams[:necesita_cirugia])
      @ficha_cirugia.update_attribute(:estado, 'VIGENTE');
      @ficha_cirugia.update_attribute(:comentarios_adicionales,
                                      fparams[:comentarios_adicionales])
      @ficha_cirugia.update_attribute(:nro_ficha, Paciente.get_next_nro_ficha()[0]["nro_ficha"])
      @ficha_cirugia.save

      if(fparams[:consulta_id])
        @consulta =  Consulta.find_by(id: fparams[:consulta_id])
        @consulta.nro_ficha =  @ficha_cirugia.nro_ficha
        @consulta.save
      end

      #redireccionar a pacientes
      respond_with @ficha_cirugia
    end
  end

  def update
    @ficha_cirugia = FichaCirugia.new()
    fparams = params[:ficha_cirugia]
    @paciente = Paciente.find_by(id: fparams[:paciente_id])
    @ficha_anterior = FichaCirugia.find(Integer(params[:id]))
    puts "Actualizando Nro. Ficha: #{@ficha_anterior.nro_ficha}"

    if @paciente != nil
      puts "Creando nueva versión de ficha #{@ficha_anterior.nro_ficha}"

      # @ficha_cirugia.assign_attributes({:id => params[:id]})
      @ficha_cirugia.assign_attributes({:tratamientos_realizados => fparams[:tratamientos_realizados].to_json})
      @ficha_cirugia.assign_attributes({:diagnosticos_realizados => fparams[:diagnosticos_realizados].to_json})
      @ficha_cirugia.assign_attributes({:diagnostico_inicial => fparams[:diagnostico_inicial]})
      @ficha_cirugia.assign_attributes({:fecha_consulta_inicial => fparams[:fecha_consulta_inicial]})
      @ficha_cirugia.assign_attributes({:colaborador_id => fparams[:colaborador_id]})
      @ficha_cirugia.assign_attributes({:paciente_id => fparams[:paciente_id]})
      @ficha_cirugia.assign_attributes({:campanha_id => fparams[:campanha_id]})
      @ficha_cirugia.assign_attributes({:externo => fparams[:externo]})
      @ficha_cirugia.assign_attributes({:anho_mision => fparams[:anho_mision]})
      @ficha_cirugia.assign_attributes({:necesita_cirugia => fparams[:necesita_cirugia]})
      @ficha_cirugia.assign_attributes({:comentarios_adicionales => fparams[:comentarios_adicionales]})
      @ficha_cirugia.assign_attributes({:nro_ficha => @ficha_anterior.nro_ficha})


      @ficha_cirugia.assign_attributes({:id => nil})
      @ficha_cirugia.save
      @ficha_nueva = FichaCirugia.find(@ficha_cirugia.id)

      if (@ficha_anterior.campanha_id.hash == @ficha_nueva.campanha_id.hash && @ficha_anterior.externo.hash == @ficha_nueva.externo.hash && @ficha_anterior.anho_mision.hash == @ficha_nueva.anho_mision.hash && @ficha_anterior.tratamientos_realizados.hash == @ficha_nueva.tratamientos_realizados.hash && @ficha_anterior.diagnosticos_realizados.hash == @ficha_nueva.diagnosticos_realizados.hash && @ficha_anterior.diagnostico_inicial == @ficha_nueva.diagnostico_inicial && @ficha_anterior.fecha_consulta_inicial == @ficha_nueva.fecha_consulta_inicial && @ficha_anterior.colaborador_id == @ficha_nueva.colaborador_id && @ficha_anterior.paciente_id == @ficha_nueva.paciente_id && @ficha_anterior.necesita_cirugia == @ficha_nueva.necesita_cirugia && @ficha_anterior.comentarios_adicionales == @ficha_nueva.comentarios_adicionales)
        @ficha_nueva.destroy
      else
        @ficha_anterior.update_attribute(:estado, 'HISTORICO');
        @ficha_anterior.save

        @ficha_nueva.update_attribute(:estado, 'VIGENTE');
        @ficha_nueva.save
      end
      puts "Actualizando el nro. de ficha <#{@ficha_anterior.nro_ficha}> utilizada en la consulta"
      if(fparams[:consulta_id])
        @consulta =  Consulta.find_by(id: fparams[:consulta_id])
        @consulta.nro_ficha =  @ficha_anterior.nro_ficha
        @consulta.save
      end
      respond_with @ficha_cirugia
    end
  end

  def destroy
    @ficha_cirugia = FichaCirugia.find_by(id: params[:id])
    if @ficha_cirugia.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @ficha_cirugia.destroy
      respond_with @ficha_cirugia
    end
  end

  # def fichas_cirugia_params
  #   params
  #     .require(:ficha_cirugia)
  #     .permit(:id,
  #             :colaborador_id,
  #             :fecha_consulta_inicial,
  #             :diagnostico_inicial,
  #             :tratamientos_realizados,
  #             :necesita_cirugia,
  #             :comentarios_adicionales,
  #             :paciente_id)
  # end

end
