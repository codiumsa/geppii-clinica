require "prawn/measurement_extensions"

class LegajoPacienteReportPdf < Prawn::Document
  def initialize(paciente, domain)
    super(:page_size => "A4", :bottom_margin => 50)
    font_size 9
    @color_texto = '3E4D4A'
    @domain = domain
    header(paciente)
    body(paciente)

  end
  def header(paciente)

    stroke_horizontal_rule
    bounding_box([0,cursor], :width => self.bounds.right) do
      pad(20){
        text "Paciente: #{paciente.persona.razon_social}", size: 12, style: :bold, :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Operación Sonrisa - Fecha: #{time} - Número de paciente: #{paciente.numero_paciente}", :align => :center
      }
    end
    stroke_horizontal_rule

  end

  def body(paciente)
    move_down 25
    text "DATOS PERSONALES DEL PACIENTE", size: 12, style: :bold_italic
    table datos_personales(paciente), column_widths: [self.bounds.right/4]*4
    move_down 25
    text "INFORMACIÓN FAMILIAR", size: 12, style: :bold_italic
    table informacion_familiar(paciente), column_widths: [self.bounds.right/6]*6 do
      row(0).align = :center
    end
    move_down 25
    table direccion(paciente), column_widths: [self.bounds.right/3]*3
    move_down 25
    text "CONTACTO DE EMERGENCIA", size: 12, style: :bold_italic
    contacto_emergencia(paciente)
    move_down 25
    text "VÍNCULO CON OPERACIÓN SONRISA", size: 12, style: :bold_italic
    vinculo(paciente)
    move_down 25
    text "OTROS DATOS", size: 12, style: :bold_italic
    otros_datos(paciente)

    start_new_page

    move_down 25
    text "INFORMACIÓN IMPORTANTE", size: 12, style: :bold_italic
    move_down 25
    info_cirugias(paciente)
    move_down 25
    info_misiones(paciente)
    move_down 25
    info_alergias(paciente)
    move_down 25
    info_medicamentos(paciente)
    move_down 25
    info_problemas(paciente)

    move_down 50
    text "CANDIDATURAS", size: 12, style: :bold_italic
    candidaturas(paciente)

    move_down 50
    text "FICHAS", size: 12, style: :bold_italic
    text "Haga click en los enlaces para acceder a las fichas del paciente.", size: 8, style: :italic
    links_fichas(paciente)
  end

  def datos_personales(paciente)
    otros_datos = JSON.parse(paciente.otros_datos)
    tieneSeguro = (otros_datos["tieneSeguro"].blank? || otros_datos["tieneSeguro"] == "no") ? false : true
    empresaSeguro = otros_datos["empresaDeSeguro"]
    return [
      ["NOMBRES:\nAPELLIDOS:", "#{paciente.persona.nombre}\n#{paciente.persona.apellido}", "EDAD: #{paciente.anhos}", [[{content: "SEXO: M #{'x' unless paciente.persona.sexo == 'Femenino'}   F #{'X' unless paciente.persona.sexo == 'Masculino'}", width: self.bounds.right/4}], ["ESTADO CIVIL: #{paciente.persona.estado_civil}"]]],
      [{content: "FECHA DE NACIMIENTO:  #{Date.parse(paciente.persona.fecha_nacimiento).strftime('%d / %m / %Y')}", colspan: 2}, {content: "LUGAR DE NACIMIENTO: #{}", colspan: 2}],
      [{content: "CÉDULA DE IDENTIDAD Nº: #{paciente.persona.ci_ruc}", colspan: 2}, {content: "SEGURO MÉDICO: SÍ #{'x' if tieneSeguro}   NO #{'x' unless tieneSeguro}   DÓNDE: #{empresaSeguro if tieneSeguro}", colspan: 2}]
    ]
  end

  def informacion_familiar(paciente)
    datos_familiares = JSON.parse(paciente.datos_familiares)
    madre = datos_familiares["madre"]
    padre = datos_familiares["padre"]
    nro_hermanos = datos_familiares["numeroHermanos"]
    edades_hermanos = datos_familiares["edadesHermanos"].gsub(" ","").split(",").join(", ")
    comparte_vivienda = datos_familiares["comparteVivienda"]
    return [
      ["", "NOMBRE", "EDAD", "ESCOLARIDAD", "OCUPACIÓN", "TELÉFONO"],
      ["DATOS DEL PADRE", padre['nombre'], padre['edad'], padre['escolaridad'], padre['ocupacion'], ""],
      ["DATOS DEL PADRE", madre['nombre'], madre['edad'], madre['escolaridad'], madre['ocupacion'], ""],
      ["NRO DE HERMANOS: #{nro_hermanos}", "EDADES: #{edades_hermanos}", {content: "PERSONAS CON QUIEN VIVE: #{comparte_vivienda}", colspan: 4}]
    ]
  end

  def direccion(paciente)
    return [
      ["DIRECCIÓN: #{paciente.persona.direccion}", "CIUDAD: #{paciente.persona.ciudad.nombre rescue ''}", "DEPARTAMENTO: "],
      ["BARRIO: #{paciente.persona.barrio}", "MEDIO DE TRANSPORTE: ", "KILÓMETROS DE LA CLÍNICA: "]
    ]
  end

  def contacto_emergencia(paciente)
    move_down 5
    contacto_emergencia = JSON.parse(paciente.contacto_emergencia)
    text "<b>NOMBRE:</b> #{contacto_emergencia['nombre']}", inline_format: true
    altura = cursor
    bounding_box([0, altura], width: self.bounds.right) do
      text "<b>RELACIÓN CON EL PACIENTE:</b> #{contacto_emergencia['relacion']}", inline_format: true
    end
    bounding_box([190, altura], width: self.bounds.right) do
      text "<b>TELÉFONO/CELULAR:</b> #{contacto_emergencia['telefono']}", inline_format: true
    end
  end

  def vinculo(paciente)
    move_down 5
    vinculos = JSON.parse(paciente.vinculos)
    sigueTratamiento = (vinculos['sigueTratamiento'].blank?) ? false : true
    primeraConsulta = (vinculos['fechaPrimeraConsulta'].blank? ? '' : Date.parse(vinculos['fechaPrimeraConsulta']).strftime('%d/%m/%Y'))
    asistencia = vinculos['asistencia'].blank? ? "Ninguna" : vinculos['asistencia']
    text "<b>ASISTENCIA A MISIONES:</b> #{asistencia}", inline_format: true
    text "<b>¿SIGUE TRATAMIENTO EN LA CLÍNICA?</b> SÍ #{'x' if sigueTratamiento}  NO #{'x' unless sigueTratamiento}          <b>FECHA DE PRIMERA CONSULTA:</b> #{primeraConsulta}", inline_format: true
    text "<b>¿CÓMO SE ENTERÓ DE OPERACIÓN SONRISA?</b> #{vinculos['comoSeEntero']['fuente']} #{vinculos['comoSeEntero']['detalle'].blank? ? '' : '- '+vinculos['comoSeEntero']['detalle']}", inline_format: true
  end

  def otros_datos(paciente)
    move_down 5
    otros_datos = JSON.parse(paciente.otros_datos)
    tratamiento = otros_datos['dondeSiguioTratamientoPediatrico'].blank? ? "No hay datos" : otros_datos['dondeSiguioTratamientoPediatrico']
    text "<b>¿DÓNDE SIGUE EL TRATAMIENTO PEDIÁTRICO?</b> #{tratamiento}", inline_format: true
  end

  def info_cirugias(paciente)
    text "CIRUGÍAS", size: 10
    cirugias = JSON.parse(paciente.datos_importantes)["cirugias"]
    if cirugias.blank?
      cirugias = FichaCirugia.where(paciente_id: paciente.id).order('created_at DESC').first
      if cirugias.blank?
        text "No hay cirugías", size: 9
      else
        rows = []
        tratamientos = JSON.parse(cirugias.tratamientos_realizados)
        if !tratamientos['tratamientos'].blank?
          tratamientos['tratamientos'].each do |tratamiento|
            cols = []
            cols << tratamiento['tipo']
            cols << tratamiento['nombre']
            cols << tratamiento['estadoTratamiento']
            cols << cirugias.comentarios_adicionales
            cols << tratamiento['hospital']
            cols << (tratamiento['anhoMision'].blank? ? '' : Date.parse(tratamiento['anhoMision']).strftime('%d/%m/%Y'))
            rows << cols
          end
          data = [["PARTE", "TRATAMIENTO", "ESTADO", "OBSERVACIÓN", "REALIZADO EN", "FECHA"]] + rows
          table data, width: self.bounds.right do
            row(0).align = :center
          end
        else
          text "No hay cirugías", size: 9
        end
      end
    else
      rows = []
      cirugias.each do |c|
        next if c['eliminado'] == true
        cols = []
        cols << (c['fecha'].blank? ? '' : Date.parse(c['fecha']).strftime('%d/%m/%Y'))
        cols << c['obs']
        cols << c['lugar']
        rows << cols
      end
      data = [["FECHA", "OBSERVACIÓN", "LUGAR"]] + rows
      table data, column_widths: [self.bounds.right/5,self.bounds.right/2.5,self.bounds.right/2.5] do
        row(0).align = :center
      end
    end
  end

  def info_misiones(paciente)
    move_down 5
    text "MISIONES", size: 10
    misiones = JSON.parse(paciente.vinculos)['misiones']
    if misiones.blank?
      text "No hay misiones", size: 9
    else
      rows = []
      misiones.each do |c|
        next if c['eliminado'] == true
        cols = []
        cols << c['nombre']
        cols << "#{c['tipoDiagnostico']} (#{c['diagnostico']})"
        cols << "#{c['tipoTratamiento']} (#{c['tratamiento']})"
        cols << c['motivoNoSeOpero']
        cols << c['recomendacionDental']
        cols << c['recomendacionFonoaudiologica']
        rows << cols
      end
      data = [["NOMBRE", "DIAGNÓSTICO", "TRATAMIENTO", "MOTIVO POR EL CUAL NO SE OPERÓ", "RECOMENDACIÓN DENTAL", "RECOMENDACIÓN FONOAUDOLÓGICA"]] + rows
      table data, column_widths: [self.bounds.right/6]*6, cell_style: {inline_format: true} do
        row(0).align = :center
        row(0).size = 8
      end
    end
  end

  def info_alergias(paciente)
    move_down 5
    text "ALERGIAS", size: 10
    alergias = JSON.parse(paciente.datos_importantes)['alergias']
    if alergias.blank?
      text "No hay alergias", size: 9
    else
      rows = []
      alergias.each do |a|
        next if a['eliminado'] == true
        cols = []
        cols << (a['fecha'].blank? ? '' : Date.parse(a['fecha']).strftime('%d/%m/%Y'))
        cols << a['alergia']
        rows << cols
      end
      data = [["FECHA", "ALERGIA"]] + rows
      table data, column_widths: [self.bounds.right/4,self.bounds.right/1.34] do
        row(0).align = :center
      end
    end
  end

  def info_medicamentos(paciente)
    move_down 5
    text "MEDICAMENTOS", size: 10
    medicamentos = JSON.parse(paciente.datos_importantes)['medicamentos']
    if medicamentos.blank?
      text "No hay medicamentos", size: 9
    else
      rows = []
      medicamentos.each do |m|
        next if m['eliminado'] == true
        cols = []
        cols << (m['fecha'].blank? ? '' : Date.parse(m['fecha']).strftime('%d/%m/%Y'))
        cols << m['medicamento']
        cols << m['frecuencia']
        cols << m['motivo']
        rows << cols
      end
      data = [["FECHA", "NOMBRE", "FRECUENCIA", "MOTIVO"]] + rows
      table data, column_widths: [self.bounds.right/4]*4 do
        row(0).align = :center
      end
    end
  end

  def info_problemas(paciente)
    move_down 5
    text "PROBLEMAS", size: 10
    problemas = JSON.parse(paciente.datos_importantes)['problemas']
    problemas_neuromusculares = problemas['neuromusculares']
    problemas_respiratorios = problemas['respiratorios']
    problemas_cardiacos = problemas['cardiacos']
    problemas_infecciones = problemas['infecciones']
    if problemas.blank?
      text "No hay problemas", size: 9
    else
      data = [
        ["SÍNDROMES", problemas['sindrome']],
        ["AUDITIVOS", problemas['auditivos']],
        ["VISUALES", problemas['visuales']],
        ["NEUROMUSCULARES", [
          [{content: "- Debilidad  #{'X' if problemas_neuromusculares['debilidad']}", width: self.bounds.right/1.34}],
          [{content: "- Desarrollo  #{'X' if problemas_neuromusculares['desarrollo']}", width: self.bounds.right/1.34}],
          [{content: "- Convulsiones  #{'X' if problemas_neuromusculares['convulsiones']}", width: self.bounds.right/1.34}]
        ]],
        ["RESPIRATORIOS", [
          [{content: "- Asma  #{'X' if problemas_respiratorios['asma']}", width: self.bounds.right/1.34}],
          [{content: "- Dificultad respiratoria  #{'X' if problemas_respiratorios['difRespiratoria']}", width: self.bounds.right/1.34}],
          [{content: "- Neumonía  #{'X' if problemas_respiratorios['neumonia']}", width: self.bounds.right/1.34}],
          [{content: "- Insuficiencia respiratoria  #{'X' if problemas_respiratorios['infRespiratoria']}", width: self.bounds.right/1.34}]
        ]],
        ["CARDIACOS", [
          [{content: "- Congénito  #{'X' if problemas_cardiacos['congenito']}", width: self.bounds.right/1.34}],
          [{content: "- Miocarditis  #{'X' if problemas_cardiacos['miocarditis']}", width: self.bounds.right/1.34}],
          [{content: "- Soplo  #{'X' if problemas_cardiacos['soplo']}", width: self.bounds.right/1.34}],
          [{content: "- Hipertensión  #{'X' if problemas_cardiacos['hipertension']}", width: self.bounds.right/1.34}],
          [{content: "- Perturbación  #{'X' if problemas_cardiacos['perturbacion']}", width: self.bounds.right/1.34}],
          [{content: "- Cardiopatía reumática  #{'X' if problemas_cardiacos['cardiopatiaReumatica']}", width: self.bounds.right/1.34}],
          [{content: "- Válvulas  #{'X' if problemas_cardiacos['valvulas']}", width: self.bounds.right/1.34}]
        ]],
        ["INFECCIONES", [
          [{content: "- VIH  #{'X' if problemas_infecciones['vih']}", width: self.bounds.right/1.34}],
          [{content: "- Hepatitis  #{'X' if problemas_infecciones['hepatitis']}", width: self.bounds.right/1.34}],
          [{content: "- Malaria  #{'X' if problemas_infecciones['malaria']}", width: self.bounds.right/1.34}],
          [{content: "Otras infecciones: #{problemas_infecciones['otros']}", width: self.bounds.right/1.34}]
        ]],
        ["OTROS", problemas['otros']]
      ]
      table data, column_widths: [self.bounds.right/4,self.bounds.right/1.34]
    end
  end

  def candidaturas(paciente)
    if paciente.candidaturas.blank?
      text "No hay candidaturas", size: 8
    else
      move_down 5
      rows = []
      paciente.candidaturas.each do |c|
        cols = []
        cols << c.colaborador.persona.razon_social
        cols << c.especialidad.descripcion
        if !c.clinica then cols << c.campanha.nombre else cols << "" end
        cols << (c.clinica ? "Sí" : "No")
        cols << c.fecha_posible.strftime('%d/%m/%Y')
        rows << cols
      end
      data = [["PROPUESTO POR", "ESPECIALIDAD", "CAMPAÑA", "MEDIANTE CLÍNICA", "FECHA POSIBLE"]] + rows
      table data, column_widths: [self.bounds.right/5]*5 do
        row(0).align = :center
      end
    end
  end

  def links_fichas(paciente)
    move_down 5
    fichas_fonoaudiologia = FichaFonoaudiologia.where(paciente_id: paciente.id, estado: 'VIGENTE').order('created_at DESC').first
    fichas_odontologia = FichaOdontologia.where(paciente_id: paciente.id, estado: 'VIGENTE').order('created_at DESC').first
    fichas_nutricion = FichaNutricion.where(paciente_id: paciente.id, estado: 'VIGENTE').order('created_at DESC').first
    fichas_cirugia = FichaCirugia.where(paciente_id: paciente.id, estado: 'VIGENTE').order('created_at DESC').first
    fichas_psicologia = FichaPsicologia.where(paciente_id: paciente.id, estado: 'VIGENTE').order('created_at DESC').first
    unless fichas_fonoaudiologia.blank?
      text "<u><color rgb='0000CC'><link href='#{@domain}/fichasFonoaudiologia/#{fichas_fonoaudiologia.id}/edit?paciente_id=#{paciente.id}'>• Ficha Fonoaudiología</link></color></u>", inline_format: true
    end
    unless fichas_odontologia.blank?
      text "<u><color rgb='0000CC'><link href='#{@domain}/fichasOdontologia/#{fichas_odontologia.id}/edit?paciente_id=#{paciente.id}'>• Ficha Odontología</link></color></u>", inline_format: true
    end
    unless fichas_nutricion.blank?
      text "<u><color rgb='0000CC'><link href='#{@domain}/fichasNutricion/#{fichas_nutricion.id}/edit?paciente_id=#{paciente.id}'>• Ficha Nutrición</link></color></u>", inline_format: true
    end
    unless fichas_cirugia.blank?
      text "<u><color rgb='0000CC'><link href='#{@domain}/fichasCirugia/#{fichas_cirugia.id}/edit?paciente_id=#{paciente.id}'>• Ficha Cirugía</link></color></u>", inline_format: true
    end
    unless fichas_psicologia.blank?
      text "<u><color rgb='0000CC'><link href='#{@domain}/fichasPsicologia/#{fichas_psicologia.id}/edit?paciente_id=#{paciente.id}'>• Ficha Psicología</link></color></u>", inline_format: true
    end
  end
end
