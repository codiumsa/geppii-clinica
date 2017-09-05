require 'axlsx'

class API::V1::ConsultasController < ApplicationController
  respond_to :json
  # before_filter :ensure_authenticated_user
  # before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_consultas" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_consultas" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_consultas" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_consultas" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_consultas" end

  has_scope :by_nombre
  has_scope :by_nro_ficha
  has_scope :by_all_attributes, allow_blank: true
  has_scope :by_especialidad
  has_scope :by_especialidad_id
  has_scope :descarta_cancelado
  has_scope :ids, type: :array
  has_scope :unpaged, :type => :boolean
  has_scope :by_paciente_id
  has_scope :by_estado
  has_scope :by_fecha_agenda_before
  has_scope :by_fecha_agenda_after
  has_scope :by_fecha_agenda_on
  has_scope :by_estado_actual
  #has_scope :by_activo

  PER_PAGE_RECORDS = 15

  def index
    especialidad = params[:especialidad]
    revocacion = params[:revocacion]
    content_type = params[:content_type]
    tipo = params[:tipo]

    if content_type.eql? "pdf"
      if tipo.eql? "receta"
         @consulta = Consulta.find(params[:consulta_id])
         pdf = RecetaReport.new(@consulta)
         send_data pdf.render, filename: 'receta_report.pdf', type: 'application/pdf', disposition: 'inline'
      else
        @paciente = Paciente.find(params[:paciente_id])
        if especialidad.eql? "CIRUGIA"
          puts "revocacion.eql? false"
          puts revocacion.eql? "false"
          if revocacion.eql? "false"
            pdf = ConsentimientoCirugiaReport.new(@paciente)
            send_data pdf.render, filename: 'consentimiento_cirugia.pdf', type: 'application/pdf', disposition: 'inline'
          else
            @colaborador = Colaborador.find(params[:colaborador_id])
            pdf = RevocacionCirugiaReport.new(@paciente,@colaborador)
            send_data pdf.render, filename: 'revocacion_cirugia.pdf', type: 'application/pdf', disposition: 'inline'
          end
        else
            @colaborador = Colaborador.find(params[:colaborador_id])
            pdf = TratamientosConsultorioReport.new(@paciente,@colaborador)
            send_data pdf.render, filename: 'tratamientos_consultorio.pdf', type: 'application/pdf', disposition: 'inline'
        end
      end
    elsif content_type.eql? "xls"
      if tipo.eql? "reporte_cantidad_tratamientos"
        @consultas = apply_scopes(Consulta).order(:fecha_agenda).reverse_order
        @by_fecha_agenda_after = params[:by_fecha_posible_after]
        @by_fecha_agenda_before = params[:by_fecha_posible_before]
        @by_fecha_agenda_on = params[:by_fecha_posible_on]
        @paciente_id = params[:by_paciente_id]
        @especialidad_id = params[:by_especialidad_id]
        render xlsx: 'cantidad_tratamientos'
      elsif tipo.eql? "reporte_cantidad_consultas"
        @consultas = apply_scopes(Consulta).order(:fecha_agenda).reverse_order
        @by_fecha_agenda_after = params[:by_fecha_agenda_after]
        @by_fecha_agenda_before = params[:by_fecha_agenda_before]
        @by_fecha_agenda_on = params[:by_fecha_agenda_on]
        @especialidad_id = params[:by_especialidad_id]
        render xlsx: 'cantidad_consultas', filename: "cantidad_consultas.xlsx"
      elsif tipo.eql? 'reporte_asistencia_consultas'
        @consultas = apply_scopes(Consulta).order(:fecha_agenda).reverse_order
        @by_fecha_agenda_after = params[:by_fecha_agenda_after]
        @by_fecha_agenda_before = params[:by_fecha_agenda_before]
        @by_fecha_agenda_on = params[:by_fecha_agenda_on]
        @especialidad_id = params[:by_especialidad_id]
        render xlsx: 'asistencia_consultas', filename: "asistencia_consultas.xlsx"
      elsif tipo.eql? "reporte_cantidad_pacientes_atendidos"
        @consultas = apply_scopes(Consulta).order('fecha_agenda').reverse_order
        @by_fecha_agenda_after = params[:by_fecha_agenda_after]
        @by_fecha_agenda_before = params[:by_fecha_agenda_before]
        @by_fecha_agenda_on = params[:by_fecha_agenda_on]
        @especialidad_id = params[:by_especialidad_id]
        render xlsx: 'cantidad_pacientes_atendidos', filename: "cantidad_pacientes_atendidos.xlsx"
      end
    else
        if params[:ids]
          @consultas = apply_scopes(Consulta).page.per(params[:ids].length)
          render json: @consultas, each_serializer: ConsultaSerializer, meta: {total: apply_scopes(Consulta).all.count, total_pages: 0}
        elsif params[:unpaged]
          @consultas = apply_scopes(Consulta)
          render json: @consultas, each_serializer: ConsultaSerializer, meta: {total: apply_scopes(Consulta).all.count, total_pages: 0}
        else
          @consultas = apply_scopes(Consulta).where("estado != 'ATENDIDO'").order('fecha_agenda desc').page(params[:page]).per(PER_PAGE_RECORDS)
          render json: @consultas, each_serializer: ConsultaSerializer, meta: {total: apply_scopes(Consulta).where("estado != 'ATENDIDO'").all.count, total_pages: @consultas.num_pages}
        end
    end
  end

  def show
    respond_with Consulta.find(params[:id])
  end

  def new
    respond_with Consulta.new
  end

  def create
    puts "PARAMETROS CONSULTA: #{params}"

    listaConsultas = params[:consulta][:consulta_listas]

    listaConsultas.map do |consultaTemp|
      @consulta = Consulta.new()
      @consulta.assign_attributes({:paciente_id => params[:consulta][:paciente_id]})
      @consulta.assign_attributes({:estado => params[:consulta][:estado]})
      @consulta.assign_attributes({:especialidad_id => consultaTemp[:especialidad_id]})
      @consulta.assign_attributes({:colaborador_id => consultaTemp[:colaborador_id]})
      @consulta.assign_attributes({:fecha_agenda => consultaTemp[:fecha_agenda]})
      if(params[:consulta][:paciente_id])
        @paciente = Paciente.find_by(id: params[:consulta][:paciente_id])
        @consulta.edad = @paciente.anhos
      end
      @consulta.save
    end

    puts "SE GUARDO LA CONSULTA: #{@consulta.to_yaml}"
    respond_with @consulta
  end

  def update
    puts ">>>>>>>>>> CONSULTA: #{params}"
    @consulta = Consulta.find_by(id: params[:id])
    if @consulta.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      puts ">>>>>>>>>> EXISTE LA CONSULTA"
      detalles = []
      if(not params[:consulta][:consulta_detalles].nil?)
        params[:consulta][:consulta_detalles].each do |d|
          @detalle = ConsultaDetalle.new(cantidad: d[:cantidad],
                                         producto_id: d[:producto_id])
          detalles.push(@detalle)
        end
      end
      Consulta.transaction do
        @consulta.consulta_detalles = detalles
        cparams = consulta_inner_params
        @consulta.update_attribute(:fecha_agenda, cparams[:fecha_agenda])
        @consulta.update_attribute(:fecha_inicio, cparams[:fecha_inicio])
        @consulta.update_attribute(:estado, cparams[:estado])
        @consulta.update_attribute(:cobrar, cparams[:cobrar])
        @consulta.update_attribute(:evaluacion, cparams[:evaluacion])
        @consulta.update_attribute(:diagnostico, cparams[:diagnostico])
        @consulta.update_attribute(:receta, cparams[:receta])
        @consulta.update_attribute(:indicaciones, cparams[:indicaciones])
        @consulta.update_attribute(:colaborador_id, cparams[:colaborador_id])
        @consulta.update_attribute(:especialidad_id, cparams[:especialidad_id])
        @consulta.update_attribute(:paciente_id, cparams[:paciente_id])
        @consulta.save
      end
      puts "SE ACTUALIZO LA CONSULTA: #{@consulta.to_yaml}"
      respond_with @consulta
    end
  end

  def destroy
    @consulta = Consulta.find_by(id: params[:id])
    if @consulta.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @consulta.estado = "CANCELADO"
      @consulta.save
      respond_with @consulta
    end
  end

  def consulta_params
    params.require(:consulta).permit(
      :id, :fecha_agenda, :fecha_inicio, :fecha_fin, :estado, :cobrar,:colaborador_id,
      :especialidad_id, :paciente_id, :evaluacion, :diagnostico, :receta, :indicaciones,
    consulta_detalle: [:producto_id, :cantidad,:consentimiento_firmado])
  end


  def consulta_inner_params
    params.require(:consulta).permit(
      :id, :fecha_agenda, :fecha_inicio, :fecha_fin, :estado, :cobrar,:colaborador_id,
    :especialidad_id, :paciente_id, :evaluacion, :diagnostico, :receta, :indicaciones)
  end


end
