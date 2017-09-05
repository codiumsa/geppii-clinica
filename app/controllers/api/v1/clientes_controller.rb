# encoding: utf-8
require 'rubygems'
require 'zip'
require 'fileutils'

class API::V1::ClientesController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_clientes" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_clientes" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_clientes" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_clientes" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_clientes" end

  has_scope :by_all_attributes
  has_scope :by_numero_cliente
  has_scope :by_ciRuc
  has_scope :by_id
  has_scope :by_razon_social
  has_scope :by_nombre
  has_scope :by_apellido
  has_scope :ignorar_cliente_default
  has_scope :by_fecha_vencimiento_cuota_before
  has_scope :by_fecha_vencimiento_cuota_on
  has_scope :by_fecha_vencimiento_cuota_after
  has_scope :by_sexo
  has_scope :by_tipo_persona
  has_scope :by_estado_civil
  has_scope :by_nacionalidad
  has_scope :by_numero_hijos
  has_scope :by_estudios_realizados
  has_scope :by_ciudad
  has_scope :by_calificacion
  has_scope :by_barrio
  has_scope :by_es_empleado
  has_scope :by_antiguedad
  has_scope :by_fecha_nacimiento_before
  has_scope :by_fecha_nacimiento_on
  has_scope :by_fecha_nacimiento_after
  has_scope :by_profesion
  has_scope :by_cargo
  has_scope :by_fecha_pago_sueldo_before
  has_scope :by_fecha_pago_sueldo_on
  has_scope :by_fecha_pago_sueldo_after
  has_scope :by_salario_mensual
  has_scope :by_dias_atraso_gt
  has_scope :by_dias_atraso_lt
  has_scope :by_dias_atraso_eq
  has_scope :by_fecha_ingreso_informconf_before
  has_scope :by_fecha_ingreso_informconf_on
  has_scope :by_fecha_ingreso_informconf_after
  has_scope :by_fecha_egreso_informconf_before
  has_scope :by_fecha_egreso_informconf_on
  has_scope :by_fecha_egreso_informconf_after
  has_scope :by_search_input

  PER_PAGE_RECORDS = 15

  def index

    tipo = params[:content_type]

    if tipo.eql? "pdf"
      tipo_reporte = params[:report_type]

      case tipo_reporte
      when "clientes_morosos"
        @clientes = apply_scopes(Cliente).by_estado_vencida.order(:numero_cliente)
        pdf = ClientesMorososReportPdf.new(@clientes)
        send_data pdf.render, filename: 'reporte_clientes_morosos.pdf', type: 'application/pdf', disposition: 'attachment'
      when "reporte_clientes"
        @clientes = apply_scopes(Cliente).order(:numero_cliente)
        pdf = ClientesReportPdf.new(@clientes)
        send_data pdf.render, filename: 'reporte_clientes.pdf', type: 'application/pdf', disposition: 'attachment'
      when "reporte_clientes_creditos","reporte_clientes_refinanciamiento"
        @clientes = apply_scopes(Cliente).order(:numero_cliente)
        clientes_creditos = []
        calificacion_minima = params[:calificacion_minima]
        porcentaje_pagado_credito = params[:porcentaje_pagado_credito]
        if not calificacion_minima.nil?
          if calificacion_minima == ''
            calificacion_minima = nil
          end
        end

        if not porcentaje_pagado_credito.nil?
          if porcentaje_pagado_credito == ''
            porcentaje_pagado_credito = 60
          else
            porcentaje_pagado_credito = porcentaje_pagado_credito.to_f
          end
        else
          porcentaje_pagado_credito = 60
        end

        if not calificacion_minima.nil?
          calificacion_ref = Calificacion.find_by(codigo: calificacion_minima)
        else
          calificacion_ref = Calificacion.find_by(codigo: 'G')
        end
        # clientes para creditos deben tener 60% de un credito pagado. O no tener creditos vigentes
        for cliente in @clientes

          class << cliente
            attr_accessor :con_prestamo_vigente
          end
          prestamos = Prestamo.where(:cliente_id => cliente.id)
          cliente.con_prestamo_vigente = 'No'
          add = true

          if cliente.numero_cliente == 0
            next
          end

          if not prestamos.nil?

            for prestamo in prestamos
              if prestamo.estado == 'VENCIDO'
                add = false
                break
              end

              if prestamo.estado == 'VIGENTE'
                cliente.con_prestamo_vigente = 'Si'

                if (not cliente.calificacion.nil?) and
                  (cliente.calificacion.dias_atraso > calificacion_ref.dias_atraso)
                  add = false
                  break
                end
                cuotas = prestamo.cuotas
                pagadas_count = 0

                for cuota in cuotas

                  if cuota.estado == 'PAGADA'
                    pagadas_count += 1
                  end
                end
                percent = (pagadas_count.to_f / cuotas.length) * 100

                if percent < porcentaje_pagado_credito
                  add = false
                  break
                end
              end
            end
          end

          if add
            clientes_creditos.push(cliente)
          end
        end
        pdf = ClientesCreditosReportPdf.new(clientes_creditos)
        send_data pdf.render, filename: "#{tipo_reporte}.pdf", type: 'application/pdf', disposition: 'attachment'
      end
    else
      @clientes = apply_scopes(Cliente).page(params[:page]).per(PER_PAGE_RECORDS)
      for cliente in @clientes
        for documento in cliente.documentos
          documento.adjunto_url
        end
      end
      render json: @clientes, each_serializer: ClienteSerializer, meta: {total: apply_scopes(Cliente).all.count, total_pages: @clientes.num_pages}
    end
  end

  def show
    @cliente = Cliente.find(params[:id])

    for documento in @cliente.documentos
      documento.adjunto_url
    end
    tipo = params[:content_type]

    if tipo.eql? "pdf"
      tipo_reporte = params[:report_type]

      case tipo_reporte
      when "reporte_legajo_cliente"
        pdf = LegajoClienteReportPdf.new(@cliente)
        # cookie que indica a $.fileDownload que el archivo se descargó correctamente
        cookies[:fileDownload] = {
          value: "true",
          path: "/"
        }
        send_data pdf.render, filename: 'legajo_cliente.pdf', type: 'application/pdf', disposition: 'attachment'

        # generar zip con adjuntos del cliente
        folder = "#{Rails.root}/public/adjuntos/#{@cliente.id}"
        input_filenames = []
        zipfile_name = "#{Rails.root}/public/adjuntos/#{@cliente.id}/adjuntos-#{@cliente.persona.ci_ruc}.zip"

        for documento in @cliente.documentos
          input_filenames.push("#{documento.adjunto_uuid}-#{documento.adjunto_file_name}#{File.extname(documento.adjunto_file_name)}")
        end
        Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
          input_filenames.each do |filename|
            zipfile.add(filename, folder + '/' + filename)
          end
        end
      end
    else
      respond_with @cliente
    end
  end

  def new
    respond_with Cliente.new
  end

  def create
    @cliente = Cliente.new(cliente_inner_params)
    @cliente.activo = true
    persona_param = params[:cliente][:persona]
    conyugue_param = params[:cliente][:persona][:conyugue]

    if persona_param[:tipo_persona] == "Física"
      nombre = persona_param[:nombre]
      apellido = persona_param[:apellido]
      if nombre.nil?
        nombre = ""
      end
      if apellido.nil?
        apellido = ""
      end
      razon_social = nombre + " " + apellido
    elsif persona_param[:tipo_persona] == "Jurídica"
      nombre = nil
      apellido = nil
      razon_social = persona_param[:razon_social]
    end

    @cliente.persona = Persona.new(tipo_persona: persona_param[:tipo_persona],
                                   ci_ruc: persona_param[:ci_ruc],
                                   razon_social: persona_param[:razon_social],
                                   nombre: persona_param[:nombre],
                                   apellido: persona_param[:apellido],
                                   direccion: persona_param[:direccion],
                                   barrio: persona_param[:barrio],
                                   ciudad_id: persona_param[:ciudad_id],
                                   telefono: persona_param[:telefono],
                                   celular: persona_param[:celular],
                                   sexo: persona_param[:sexo],
                                   nacionalidad: persona_param[:nacionalidad],
                                   estado_civil: persona_param[:estado_civil],
                                   fecha_nacimiento: persona_param[:fecha_nacimiento],
                                   correo: persona_param[:correo])

    @cliente.persona.conyugue = Conyugue.new(
      nombre: conyugue_param[:nombre],
      apellido: conyugue_param[:apellido],
      nacionalidad: conyugue_param[:nacionalidad],
      cedula: conyugue_param[:cedula],
      fecha_nacimiento: conyugue_param[:fecha_nacimiento],
      lugar_nacimiento: conyugue_param[:lugar_nacimiento],
      empleador: conyugue_param[:empleador],
      actividad_empleador: conyugue_param[:actividad_empleador],
      cargo: conyugue_param[:cargo],
      profesion: conyugue_param[:profesion],
      ingreso_mensual: conyugue_param[:ingreso_mensual],
      concepto_otros_ingresos: conyugue_param[:concepto_otros_ingresos],
      otros_ingresos: conyugue_param[:otros_ingresos]
    )

    referencias = []
    if(not params[:cliente][:referencias].nil?)
      params[:cliente][:referencias].each do |ref|
        @referencia = Referencia.new(nombre: ref[:nombre],
                                     telefono: ref[:telefono],
                                     tipo_referencia: ref[:tipo_referencia],
                                     tipo_cuenta: ref[:tipo_cuenta],
                                     activa: ref[:activa])
        referencias.push(@referencia)
      end
      @cliente.referencias = referencias
    end

    ingreso_familiares = []
    if(not params[:cliente][:ingreso_familiares].nil?)
      params[:cliente][:ingreso_familiares].each do |ing|
        puts "Ingresos Familiares: #{ing} #{ing[:vinculoFamiliar]}"
        @vinculo_familiar = VinculoFamiliar.find_by(tipo: ing[:vinculoFamiliar][:tipo])
        @ingreso_familiar = IngresoFamiliar.new(ingreso_mensual: ing[:ingreso_mensual],
                                                vinculo_familiar_id: @vinculo_familiar.id)
        ingreso_familiares.push(@ingreso_familiar)
      end
      @cliente.ingreso_familiares = ingreso_familiares
    end

    documentos = []
    if(not params[:cliente][:documentos].nil?)
      params[:cliente][:documentos].each do |doc|
        @tipo_documento = TipoDocumento.find_by(nombre: doc[:tipo_documento][:nombre])
        @documento = Documento.new(nombre: doc[:nombre],
                                   tipo_documento_id: @tipo_documento.id,
                                   adjunto_file_name: doc[:adjunto_file_name],
                                   adjunto_uuid: doc[:adjunto_uuid])
        documentos.push(@documento)
      end
      @cliente.documentos = documentos
    end

    @cliente_ref = Cliente.find_by(numero_cliente: 0)
    puts "Cliente 0: #{@cliente_ref}"
    @cliente.calificacion_id = @cliente_ref.calificacion_id
    @cliente.guardar
    respond_with @cliente
  end

  def update
    @cliente = Cliente.find_by(id: params[:id])
    @persona = Persona.find_by(id: @cliente.persona_id)
    pparams = params[:cliente][:persona]
    cparams = params[:cliente]

    if @cliente.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      referencias = []
      ingreso_familiares = []

      if(not params[:cliente][:referencias].nil?)
        params[:cliente][:referencias].each do |ref|
          if ref[:id].nil?
            @referencia = Referencia.new(nombre: ref[:nombre],
                                         telefono: ref[:telefono],
                                         tipo_referencia: ref[:tipo_referencia],
                                         tipo_cuenta: ref[:tipo_cuenta])
            referencias.push(@referencia)
          else
            @referencia = Referencia.find_by(id: ref[:id])
            referencias.push(@referencia)
          end
        end
      end

      if(not params[:cliente][:ingreso_familiares].nil?)
        params[:cliente][:ingreso_familiares].each do |ing|
          if ing[:id].nil?
            puts "#{ing}"
            @vinculo_familiar = VinculoFamiliar.find_by(tipo: ing[:vinculoFamiliar][:tipo])
            @ingreso_familiar = IngresoFamiliar.new(ingreso_mensual: ing[:ingreso_mensual],
                                                    vinculo_familiar_id: @vinculo_familiar.id)
            ingreso_familiares.push(@ingreso_familiar)
          else
            @ingreso_familiar = IngresoFamiliar.find_by(id: ing[:id])
            ingreso_familiares.push(@ingreso_familiar)
          end
        end
      end

      documentos = []
      if(not params[:cliente][:documentos].nil?)
        params[:cliente][:documentos].each do |doc|
          if doc[:id].nil?
            @tipo_documento = TipoDocumento.find_by(nombre: doc[:tipoDocumento][:nombre])
            @documento = Documento.new(nombre: doc[:nombre],
                                       tipo_documento_id: @tipo_documento.id,
                                       adjunto_file_name: doc[:adjunto_file_name],
                                       adjunto_uuid: doc[:adjunto_uuid])
            documentos.push(@documento)
          else
            @documento = Documento.find_by(id: doc[:id])
            documentos.push(@documento)
          end
        end
      end

      @cliente.documentos = documentos
      @cliente.referencias = referencias
      @cliente.ingreso_familiares = ingreso_familiares

      if not @persona.conyugue_id.nil?
        @conyugue = Conyugue.find_by(id: @persona.conyugue_id)
      else
        conyugue_param = params[:cliente][:persona][:conyugue]
        @conyugue = Conyugue.new(
          nombre: conyugue_param[:nombre],
          apellido: conyugue_param[:apellido],
          nacionalidad: conyugue_param[:nacionalidad],
          cedula: conyugue_param[:cedula],
          fecha_nacimiento: conyugue_param[:fecha_nacimiento],
          lugar_nacimiento: conyugue_param[:lugar_nacimiento],
          empleador: conyugue_param[:empleador],
          actividad_empleador: conyugue_param[:actividad_empleador],
          cargo: conyugue_param[:cargo],
          profesion: conyugue_param[:profesion],
          ingreso_mensual: conyugue_param[:ingreso_mensual],
          concepto_otros_ingresos: conyugue_param[:concepto_otros_ingresos],
        otros_ingresos: conyugue_param[:otros_ingresos])
      end

      Cliente.transaction do
        @cliente.update_attributes(cliente_inner_params)
        @persona.update_attribute(:tipo_persona, pparams[:tipo_persona])
        @persona.update_attribute(:ci_ruc, pparams[:ci_ruc])
        @persona.update_attribute(:razon_social, pparams[:razon_social])
        @persona.update_attribute(:direccion, pparams[:direccion])
        @persona.update_attribute(:barrio, pparams[:barrio])
        @persona.update_attribute(:telefono, pparams[:telefono])
        @persona.update_attribute(:celular, pparams[:celular])
        @persona.update_attribute(:estado_civil, pparams[:estado_civil])
        @persona.update_attribute(:fecha_nacimiento, pparams[:fecha_nacimiento])
        @persona.update_attribute(:correo, pparams[:correo])
        @persona.update_attribute(:sexo, pparams[:sexo])
        @persona.update_attribute(:numero_hijos, pparams[:numero_hijos])
        @persona.update_attribute(:estudios_realizados, pparams[:estudios_realizados])
        @persona.update_attribute(:tipo_domicilio, pparams[:tipo_domicilio])
        @persona.update_attribute(:antiguedad_domicilio, pparams[:antiguedad_domicilio])
        @persona.update_attribute(:tipo_persona, pparams[:tipo_persona])
        @persona.update_attribute(:nacionalidad, pparams[:nacionalidad])
        @persona.update_attribute(:nombre, pparams[:nombre])
        @persona.update_attribute(:apellido, pparams[:apellido])
        @persona.update_attribute(:ciudad_id, pparams[:ciudad_id])
        if @persona.conyugue_id.nil?
          @conyugue.save
          @persona.update_attribute(:conyugue_id, @conyugue.id)
        else
          @conyugue.update_attributes(conyugue_params)
        end
      end
      respond_with @cliente
    end
  end

  def destroy
    @cliente = Cliente.find_by(id: params[:id])
    if @cliente.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @cliente.activo = false
      @cliente.save
      respond_with @cliente
    end
  end

  def cliente_params
    params.require(:cliente).permit(:activo, :calificacion_id, :antiguedad, :salario_mensual, :matricula_nro, :ramo,
                                    :otros_ingresos, :empleador, :jubilado, :comerciante, :pariente1, :pariente2, :ingreso_pariente2,
                                    :domicilio, :cargo, :telefono, :institucion, :empleado, :profesion, :actividad_empleador, :direccion_empleador,
                                    :barrio_empleador, :fecha_pago_sueldo, :concepto_otros_ingresos, :ips, :fecha_ingreso_informconf, :fecha_egreso_informconf,
                                    persona: [:id, :tipo_persona, :ci_ruc, :razon_social, :direccion, :barrio, :telefono,
                                              :celular, :estado_civil, :fecha_nacimiento, :correo, :ciudad_id, :sexo, :nacionalidad],
                                    ingreso_familiares: [:id, :ingreso_mensual, vinculo_familiar: [:id, :tipo]])
  end

  def cliente_inner_params
    params.require(:cliente).permit(:activo, :calificacion_id, :antiguedad, :salario_mensual, :matricula_nro, :ramo,
                                    :otros_ingresos, :empleador, :jubilado, :comerciante, :pariente1, :pariente2, :ingreso_pariente2,
                                    :domicilio, :cargo, :telefono, :institucion, :empleado, :profesion, :actividad_empleador, :direccion_empleador,
                                    :barrio_empleador, :fecha_pago_sueldo, :concepto_otros_ingresos, :ips, :fecha_ingreso_informconf, :fecha_egreso_informconf,
                                    :numero_cliente, :ciudad_id)
  end

  def persona_params
    params.require(:cliente).require(:persona).permit(:id,:edad, :tipo_persona, :ci_ruc, :razon_social, :nombre, :apellido, :direccion, :barrio, :telefono,
                                                      :celular, :estado_civil, :fecha_nacimiento, :correo, :ciudad_id, :sexo, :numero_hijos,
                                                      :estudios_realizados, :tipo_domicilio, :antiguedad_domicilio, :nacionalidad, :conyugue_id)
  end

  def conyugue_params
    params.require(:cliente).require(:persona).require(:conyugue).permit(:id, :nombre, :apellido, :nacionalidad, :cedula,
                                                                         :fecha_nacimiento, :lugar_nacimiento, :empleador, :actividad_empleador,
                                                                         :cargo, :profesion, :ingreso_mensual, :concepto_otros_ingresos, :otros_ingresos)
  end
end
