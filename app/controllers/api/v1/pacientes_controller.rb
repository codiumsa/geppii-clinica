require 'json'

class API::V1::PacientesController < ApplicationController
  respond_to :json
  has_scope :by_all_attributes
  has_scope :by_numero_paciente
  has_scope :by_ciRuc
  has_scope :by_id
  has_scope :by_razon_social
  has_scope :by_nombre
  has_scope :by_apellido
  has_scope :ignorar_cliente_default
  has_scope :by_fecha_registro_before
  has_scope :by_fecha_registro_on
  has_scope :by_fecha_registro_after
  has_scope :by_fecha_modificacion_before
  has_scope :by_fecha_modificacion_on
  has_scope :by_fecha_modificacion_after
  has_scope :by_fecha_consulta_before
  has_scope :by_fecha_consulta_on
  has_scope :by_fecha_consulta_after
  has_scope :by_tratamiento
  has_scope :by_medicamento
  has_scope :by_sexo
  has_scope :by_tipo_persona
  has_scope :by_estado_civil
  has_scope :by_nacionalidad
  has_scope :by_persona_id
  has_scope :by_persona
  has_scope :by_id
  PER_PAGE_RECORDS = 15

  def index
    tipo = params[:tipo]
    content_type = params[:content_type]
    paciente = params[:paciente_id]
    if content_type.eql? "pdf"
      if tipo.eql? "reporte_legajo_paciente"
        @paciente = apply_scopes(Paciente).first
        pdf = LegajoPacienteReportPdf.new(@paciente, "#{request.protocol}#{request.host_with_port}")
        send_data pdf.render, filename: "legajo_paciente_#{@paciente.id}.pdf", type: 'application/pdf', disposition: 'attachment'
      end
    elsif content_type.eql? "xls"
      if tipo.eql? "reporte_pacientes_nuevos"
        @by_fecha_agenda_on = params[:by_fecha_agenda_on]
        @by_fecha_agenda_after = params[:by_fecha_agenda_after]
        @by_fecha_agenda_before = params[:by_fecha_agenda_before]
        render xlsx: 'pacientes_nuevos'
      elsif tipo.eql? "reporte_listado_pacientes"
        @pacientes = apply_scopes(Paciente)
        render xlsx: 'reporte_listado_pacientes'
      end
    else
      @pacientes = apply_scopes(Paciente).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @pacientes, each_serializer: PacienteSerializer,
        meta: {total: apply_scopes(Paciente).all.count, total_pages: @pacientes.num_pages}
      #respond_with :paciente => @pacientes, :total_pages => @pacientes.num_pages, :total => Paciente.count
    end
  end

  def fonoaudiologia
    if request.post?
      #@paciente = Paciente.find_by(id: params[:id])
      #@paciente.update_attribute
      params[:id] = nil
      puts params
      @newFF = FichaFonoaudiologia
      .new(
        paciente_id: params[:paciente_id],
        comunicacion_lenguaje: params[:comunicacion_lenguaje].to_json,
      estimulos: params[:estimulos].to_json)

      @newFF.save()
      respond_with @newFF, location: nil
    else
      puts 'something else ?'
    end


  end

  def show
    respond_with Paciente.find(params[:id])
  end

  def new
    respond_with Paciente.new
  end

  def create
    puts "PACIENTE: #{params}"
    Paciente.transaction do
      begin
        @id_persona = params[:paciente][:id_persona]
        #Guardando colaborador
        @paciente = Paciente.find_by(persona_id: @id_persona)
        if @paciente.nil?
          puts "Creando nuevo paciente...."
          @paciente = Paciente.new(paciente_inner_params)
        else
          puts "Actualizando colaborador existente..."
          @paciente.update_attributes(paciente_inner_params)
        end
        #@paciente.activo = true

        puts "CARGANDO DATOS JSON"
        @paciente.persona = Persona.new(persona_params)
        @paciente.datos_familiares = datos_familiares_params.to_json
        @paciente.contacto_emergencia = contacto_emergencia_params.to_json
        @paciente.vinculos = vinculos_params.to_json
        @paciente.otros_datos = otros_datos_params.to_json
        @paciente.datos_importantes = datos_importantes_params.to_json
        #Guardando Persona
        persona_param = params[:paciente][:persona]
        if(@id_persona.nil?)
          puts params[:paciente][:persona].inspect
          @persona = Persona.create(persona_param)
        else
          @persona = Persona.update(@id_persona, persona_param)
        end
        @paciente.persona = @persona
        if @paciente.numero_paciente.nil? or (@paciente.numero_paciente.eql? "")
          puts "Generando numero de paciente"
          @paciente.numero_paciente = Paciente.get_next_nro_paciente()[0]["numero_paciente"]
        end
        @paciente.save
      rescue Exception => e
        p e
        raise e
      end
    end
    respond_with @paciente
  end

  def update
    #now just replace the json structures
    #TODO: have a flag to update or replace a json data type
    @paciente = Paciente.find_by(id: params[:id])
    @persona = Persona.find_by(id: @paciente.persona_id)

    cands = []
    if (not params[:paciente][:candidaturas].nil?)
      params[:paciente][:candidaturas].each do |raw|
        puts "------raw candidatura"
        puts raw
        nuevaCandidatura = Candidatura.new(paciente_id: raw[:paciente_id],
                                           especialidad_id: raw[:especialidad_id],
                                           colaborador_id: raw[:colaborador_id],
                                           clinica: raw[:clinica],
                                           campanha_id: raw[:campanha_id],
                                           fecha_posible: raw[:fecha_posible]
                                           )
        cands.push(nuevaCandidatura)
      end
    end
    @paciente.candidaturas = cands
    persona_local_params = params[:paciente][:persona]
    Cliente.transaction do
      @paciente.update_attributes(paciente_inner_params)
      #@persona.update_attribute(:tipo_persona, persona_local_params[:tipo_persona])
      @persona.update_attribute(:ci_ruc, persona_local_params[:ci_ruc])
      @persona.update_attribute(:razon_social, persona_local_params[:razon_social])
      @persona.update_attribute(:direccion, persona_local_params[:direccion])
      @persona.update_attribute(:barrio, persona_local_params[:barrio])
      @persona.update_attribute(:telefono, persona_local_params[:telefono])
      @persona.update_attribute(:celular, persona_local_params[:celular])
      @persona.update_attribute(:edad, persona_local_params[:edad])
      @persona.update_attribute(:estado_civil, persona_local_params[:estado_civil])
      @persona.update_attribute(:fecha_nacimiento, persona_local_params[:fecha_nacimiento])
      @persona.update_attribute(:correo, persona_local_params[:correo])
      @persona.update_attribute(:sexo, persona_local_params[:sexo])
      @persona.update_attribute(:numero_hijos, persona_local_params[:numero_hijos])
      @persona.update_attribute(:estudios_realizados, persona_local_params[:estudios_realizados])
      @persona.update_attribute(:tipo_domicilio, persona_local_params[:tipo_domicilio])
      @persona.update_attribute(:antiguedad_domicilio, persona_local_params[:antiguedad_domicilio])
      @persona.update_attribute(:tipo_persona, persona_local_params[:tipo_persona])
      @persona.update_attribute(:nacionalidad, persona_local_params[:nacionalidad])
      @persona.update_attribute(:nombre, persona_local_params[:nombre])
      @persona.update_attribute(:apellido, persona_local_params[:apellido])
      @persona.update_attribute(:ciudad_id, persona_local_params[:ciudad_id])
      @paciente.update_attribute(:datos_familiares, datos_familiares_params.to_json)
      @paciente.update_attribute(:contacto_emergencia, contacto_emergencia_params.to_json)
      puts "vinculossss"
      puts vinculos_params.to_yaml
      @paciente.update_attribute(:vinculos, vinculos_params.to_json)
      @paciente.update_attribute(:otros_datos, otros_datos_params.to_json)
      @paciente.update_attribute(:datos_importantes, datos_importantes_params.to_json)
    end
    if @paciente.numero_paciente.nil? or (@paciente.numero_paciente.eql? "")
      puts "Generando numero de paciente"
      @paciente.numero_paciente = Paciente.get_next_nro_paciente()[0]["numero_paciente"]
    end
    @paciente.save
    respond_with @paciente
  end


  def destroy
    @paciente = Paciente.find_by(id: params[:id])
    if @paciente.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @paciente.activo = false
      @paciente.save
      respond_with @paciente
    end
  end


  def paciente_params
    params.require(:paciente)
    .permit(:numero_paciente, :id_persona, :datos_importantes, :datos_familiares => [:padre, :madre, :nroHermanos, :edades],
            persona: [:id, :edad, :tipo_persona, :ci_ruc, :razon_social, :direccion, :barrio,
                      :telefono, :celular, :estado_civil, :fecha_nacimiento, :correo,
                      :ciudad_id, :sexo, :nacionalidad, :conyuge_id])
  end

  def datos_importantes_params
    params.require(:paciente).require(:datos_importantes).permit!
  end
  def paciente_inner_params
    params.require(:paciente).permit(:numero_paciente)
  end

  def datos_familiares_params
    params.require(:paciente).require(:datos_familiares)
    .permit(:numeroHermanos, :edadesHermanos, :comparteVivienda,
            :padre => [:nombre,
                       :edad,
                       :ocupacion,
                       :escolaridad],
            :madre => [:nombre,
                       :edad,
                       :ocupacion,
                       :escolaridad],
            :contacto_emergencia => [:nombre,
                                     :relacion,
                                     :telefono],
            :vinculos => [:asistencia,
                          :sigueTratamiento,
                          :tratamiento,
                          :tipoTratamiento,
                          :diagnostico,
                          :tipoDiagnostico,
                          :recomendacionDental,
                          :recomendacionFonoaudiologica,
                          :motivoNoSeOpero,
                          :fechaPrimeraConsulta,
                          :comoSeEntero],
            :otros_datos => [:dondeSiguioTratamientoPediatrico,
                             :tieneSeguro,
                             :empresaDeSeguro])
  end

  #TODO generalizar, programacion funcional?
  def padre_params
    params.require(:paciente).require(:datos_familiares).require(:padre)
    .permit(:nombre, :edad, :ocupacion, :escolaridad)
  end

  def madre_params
    params.require(:paciente).require(:datos_familiares).require(:madre)
    .permit(:nombre, :edad, :ocupacion, :escolaridad)
  end

  def persona_params
    params.require(:paciente)
    .require(:persona).permit(:id,:edad,:tipo_persona, :ci_ruc, :razon_social, :nombre, :apellido, :direccion, :barrio, :telefono,
                              :celular, :estado_civil, :fecha_nacimiento, :correo, :ciudad_id, :sexo, :numero_hijos,
                              :estudios_realizados, :tipo_domicilio, :antiguedad_domicilio, :nacionalidad, :conyugue_id)
  end

  def contacto_emergencia_params
    params.require(:paciente).require(:contacto_emergencia)
    .permit(:nombre,
            :relacion,
            :telefono)
  end

  def vinculos_params
    params.require(:paciente).require(:vinculos)
    .permit(:asistencia,
            :sigueTratamiento,
            :misionAsociada,
            :fechaPrimeraConsulta,
            :comoSeEntero => [:fuente,:detalle],
            misiones: [:nombre,:descripcion,:tratamiento, :tipoTratamiento,:diagnostico, :tipoDiagnostico,:recomendacionDental,:recomendacionFonoaudiologica,
            :motivoNoSeOpero,])
  end
  def otros_datos_params
    params.require(:paciente).require(:otros_datos)
    .permit(:dondeSiguioTratamientoPediatrico,
            :tieneSeguro,
            :empresaDeSeguro)
  end

end
