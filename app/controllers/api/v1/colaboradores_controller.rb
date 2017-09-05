# encoding: utf-8
require 'rubygems'
require 'zip'
require 'fileutils'
class API::V1::ColaboradoresController < ApplicationController
  respond_to :json

  has_scope :by_activo
  has_scope :by_all_attributes
  has_scope :by_ciRuc
  has_scope :by_persona
  has_scope :ignorar_colaborador_default
  has_scope :by_especialidad_id
  has_scope :by_persona_id
  has_scope :by_cirujano
  has_scope :by_colaborador_id
  has_scope :by_all_attributes
  has_scope :by_tipo_colaborador_id

  PER_PAGE_RECORDS = 15


  def index
    tipo = params[:content_type]

    if tipo.eql? "pdf"
      tipo_reporte = params[:report_type]
      if tipo_reporte.eql("reporte_colaboradores")
        @colaboradores = apply_scopes(Colaborador).order(:numero_colaborador)
        pdf = ColaboradoresReportPdf.new(@colaboradores)
        send_data pdf.render, filename: 'reporte_colaboradores.pdf', type: 'application/pdf', disposition: 'attachment'
      end
    elsif tipo.eql? "xls"
      tipo_reporte = params[:report_type]
      if tipo_reporte.eql? "informacion_voluntarios"
        @colaboradores = apply_scopes(Colaborador).order(:id)
        @by_fecha_posible_after = params[:by_fecha_posible_after]
        @by_fecha_posible_before = params[:by_fecha_posible_before]
        @by_fecha_posible_on = params[:by_fecha_posible_on]
        render xlsx: 'informacion_voluntarios',filename: "informacion_voluntarios.xlsx"
      elsif tipo_reporte.eql? "listado_voluntarios"
        @colaboradores = apply_scopes(Colaborador).order(:id)
        render xlsx: 'listado_voluntarios',filename: "listado_voluntarios.xlsx"
      elsif tipo_reporte.eql? "participacion_voluntarios"
        @colaboradores = apply_scopes(Colaborador).order(:id)
        @viaje_id = params[:viaje_id]
        @campanha_id = params[:campanha_id]
        @curso_id = params[:curso_id]
        @by_fecha_posible_after = params[:by_fecha_posible_after]
        @by_fecha_posible_before = params[:by_fecha_posible_before]
        @by_fecha_posible_on = params[:by_fecha_posible_on]
        render xlsx: 'participacion_voluntarios', filename: "participacion_voluntarios.xlsx"

      end
    else
      if (params[:unpaged])
        @colaboradores = apply_scopes(Colaborador).order(:id)
        render json: @colaboradores, each_serializer: ColaboradorSerializer, meta: {total: apply_scopes(Colaborador).all.count, total_pages: 0}
      else
        @colaboradores = apply_scopes(Colaborador).page(params[:page]).per(PER_PAGE_RECORDS)
        render json: @colaboradores, each_serializer: ColaboradorSerializer, meta: {total: apply_scopes(Colaborador).all.count, total_pages: @colaboradores.num_pages}
      end
    end
  end


  def show
    @colaborador = Colaborador.find(params[:id])
    tipo = params[:content_type]

    if tipo.eql? "pdf"
      tipo_reporte = params[:report_type]

      case tipo_reporte
      when "reporte_legajo_colaborador"
        pdf = LegajoColaboradorReportPdf.new(@colaborador)
        # cookie que indica a $.fileDownload que el archivo se descargó correctamente
        cookies[:fileDownload] = {
          value: "true",
          path: "/"
        }
        send_data pdf.render, filename: 'legajo_colaborador.pdf', type: 'application/pdf', disposition: 'attachment'

        # generar zip con adjuntos del colaborador
        folder = "#{Rails.root}/public/adjuntos/#{@colaborador.id}"
        input_filenames = []
        zipfile_name = "#{Rails.root}/public/adjuntos/#{@colaborador.id}/adjuntos-#{@colaborador.persona.ci_ruc}.zip"

        for documento in @colaborador.documentos
          input_filenames.push("#{documento.adjunto_uuid}-#{documento.adjunto_file_name}#{File.extname(documento.adjunto_file_name)}")
        end
        Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
          input_filenames.each do |filename|
            zipfile.add(filename, folder + '/' + filename)
          end
        end
      end
    else
      respond_with @colaborador
    end
  end

  def new
    respond_with Colaborador.new
  end

  def create
    @id_persona = params[:colaborador][:id_persona]
    #Guardando colaborador
    @colaborador = Colaborador.find_by(persona_id: @id_persona)
    if @colaborador.nil?
      puts "Creando nuevo colaborador...."
      @colaborador = Colaborador.new(colaborador_inner_params)
    else
      puts "Actualizando colaborador existente..."
      @colaborador.update_attributes(colaborador_inner_params)
    end
    @colaborador.activo = true

    detalles = []
    if(not params[:colaborador][:campanhas_colaboradores].nil?)
      puts "Cargando campañas..."
      params[:colaborador][:campanhas_colaboradores].each do |d|
        @detalle = CampanhaColaborador.new(campanha_id: d[:campanha_id],
                                           observaciones: d[:observaciones])
        detalles.push(@detalle)
      end
    end
    @colaborador.campanhas_colaboradores = detalles

    #Guardando Persona
    persona_param = params[:colaborador][:persona]
    if(@id_persona.nil?)
      @persona = Persona.create(persona_param)
    else
      @persona = Persona.update(@id_persona, persona_param)
    end

    @colaborador.persona = @persona
    @colaborador.save
    respond_with @colaborador
  end

  def update
    puts "UPDATE COLABORADOR #{params}"
    @colaborador = Colaborador.find_by(id: params[:id])
    @persona = Persona.find_by(id: @colaborador.persona_id)
    pparams = params[:colaborador][:persona]

    if @colaborador.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      Persona.transaction do
        @colaborador.update_attributes(colaborador_inner_params)
        detalles = []
        if(not params[:colaborador][:campanhas_colaboradores].nil?)
          puts "Agregando campañas...."
          params[:colaborador][:campanhas_colaboradores].each do |d|
            @detalle = CampanhaColaborador.new(campanha_id: d[:campanha_id],
                                               observaciones: d[:observaciones])
            detalles.push(@detalle)
          end
        end
        @colaborador.campanhas_colaboradores = detalles
        @colaborador.save
        Persona.update(@persona.id, pparams)
      end
      respond_with @colaborador
    end
  end

  def destroy
    @colaborador = Colaborador.find_by(id: params[:id])
    if @colaborador.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @colaborador.activo = false
      @colaborador.save
      respond_with @colaborador
    end
  end

  def colaborador_params
    params.require(:colaborador).permit(:id, :activo, :acreditado, :comisionamiento, :tipo, :pals, :bls, :titulo, :institucion, :talle_remera, :lugar_trabajo_1,:lugar_trabajo_2,:lugar_trabajo_3, :horario_trabajo_1, :horario_trabajo_2, :horario_trabajo_3, :vencimiento_registro_medico, :vencimiento_bls, :vencimiento_pals, :otros, :tipo_colaborador_id, :id_persona, :voluntario, :especialidad_id, :licencia,:nombre_club,:nombre_contacto_club, :nombre_presidente_club,:email_contacto_club, :correo_presidente_club, :celular_contacto_club, :celular_presidente_club,
                                        persona: [:id, :tipo_persona, :ci_ruc, :razon_social, :nombre, :apellido, :direccion, :barrio, :telefono,
                                                  :celular, :estado_civil, :fecha_nacimiento, :correo, :ciudad_id, :sexo, :numero_hijos,
                                                  :estudios_realizados, :tipo_domicilio, :antiguedad_domicilio, :nacionalidad, :conyugue_id],
                                        campanhas_colaboradores: [:id, :observaciones, :campanha_id])
  end

  def colaborador_inner_params
    params.require(:colaborador).permit(:id, :activo, :acreditado, :pals, :bls,:comisionamiento, :tipo, :titulo, :institucion, :talle_remera, :lugar_trabajo_1,:lugar_trabajo_2,:lugar_trabajo_3, :horario_trabajo_1, :horario_trabajo_2, :horario_trabajo_3, :vencimiento_registro_medico, :vencimiento_bls, :vencimiento_pals, :otros, :tipo_colaborador_id, :voluntario, :especialidad_id, :licencia,:nombre_club,:nombre_contacto_club, :nombre_presidente_club, :email_contacto_club, :correo_presidente_club, :celular_contacto_club, :celular_presidente_club)
  end

  def persona_params
    params.require(:colaborador).require(:persona).permit(:id,:edad,:tipo_persona, :ci_ruc, :razon_social, :nombre, :apellido, :direccion, :barrio, :telefono,
                                                          :celular, :estado_civil, :fecha_nacimiento, :correo, :ciudad_id, :sexo, :numero_hijos,
                                                          :estudios_realizados, :tipo_domicilio, :antiguedad_domicilio, :nacionalidad, :conyugue_id,
                                                          conyugue: [:id, :nombre, :apellido, :nacionalidad, :cedula,
                                                                     :fecha_nacimiento, :lugar_nacimiento, :empleador, :actividad_empleador,
                                                                     :cargo, :profesion, :ingreso_mensual, :concepto_otros_ingresos, :otros_ingresos])
  end

  def conyugue_params
    params.require(:colaborador).require(:persona).require(:conyugue).permit(:id, :nombre, :apellido, :nacionalidad, :cedula,
                                                                             :fecha_nacimiento, :lugar_nacimiento, :empleador, :actividad_empleador,
                                                                             :cargo, :profesion, :ingreso_mensual, :concepto_otros_ingresos, :otros_ingresos)
  end
end
