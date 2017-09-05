# bundle exec db:drop db:create db:migrate db:seed
# rails runner SonrisasController.migrar_medicamentos

class SonrisasController < ApplicationController

  def self.migrar()
    self.migrar_medicamentos()
    self.migrar_proveedores_sponsors()
  end
  def self.migrar_medicamentos()

    puts "[MIGRACION]: Obteniendo moneda en dolares..."
    moneda = Moneda.find_by(nombre: 'Dólares')
    puts "[MIGRACION]: Obteniendo deposito farmacia..."
    deposito = Deposito.find_by(nombre: 'Farmacia')
    puts "[MIGRACION]: Obteniendo tipo de producto Medicamento..."
    tipo_producto = TipoProducto.find_by(codigo: 'M')
    puts "ELIMINANDO PRODUCTOS TIPO MEDICAMENTO"
    Producto.where(:tipo_producto_id => tipo_producto.id).destroy_all

    require 'rubyXL'
    path = "Script/inventario.xlsx"
    puts "[MIGRACION] Parseando el archivo..."
    workbook = RubyXL::Parser.parse(path)
    puts "[MIGRACION] Se parseo el archivo..."
    worksheet = workbook[0]            # Returns first worksheet
    puts "[MIGRACION] Se obtuvo la primera hoja..."
    fila = 0
    worksheet.each do |row|
      if fila > 0
        puts "[MIGRACION] [#{fila}] : #{row}"
        if !row[2].nil?
          producto = nuevoProducto(row, deposito, moneda, tipo_producto, fila)
        end
      end
      fila = fila+1
    end
  end


  def self.nuevoProducto(row, deposito, moneda, tipo_producto, fila)
    puts "[MIGRACION][#{fila}]: Buscando producto: #{row[0].nil? ? nil : row[0].value} #{row[1].nil? ? nil : row[1].value}"
    codigo_barra = row[29].nil? ? nil : row[29].value
    if codigo_barra.nil?
      puts "[MIGRACION][#{fila}]: Creando codigo de barra: #{row[2].nil? ? nil : row[2].value}}"
      codigo_barra ||= row[2].nil? ? nil : row[2].value
      codigo_barra ||= fila.to_s
      puts "[MIGRACION][#{fila}]: #{codigo_barra}"
      codigo_barra.gsub!(/\s+/, '')
      codigo_barra.upcase
    end

    producto = Producto.find_by(codigo_barra: codigo_barra.to_s)
    if producto.nil?
      puts "[MIGRACION][#{fila}]: Producto nuevo... #{codigo_barra}"
      producto = Producto.new(
        codigo_barra: codigo_barra,
        descripcion: row[2].value,
        unidad: row[3].value,
        presentacion: row[3].value,
        margen: 0,
        iva: 10,
        precio_compra: row[10].value,
        precio: row[10].value,
        stock_minimo: 0,
        precio_promedio: 0,
        activo: true,
        pack: false,
        moneda: moneda,
        servicio: false,
        codigo_externo: row[1].value,
        descripcion_externa: row[2].value,
        codigo_local: row[0].nil? ? nil : row[0].value,
        tipo_producto: tipo_producto,
        descripcion_local: row[2].value,
        especialidad: nil,
        es_procedimiento: false,
        marca: row[8].value,
        nro_referencia: row[7].nil? ? nil : row[7].value
      )
      puts "[MIGRACION][#{fila}]: Guardando producto..."
      producto.save
    end
    puts "[MIGRACION][#{fila}]: Buscando lote #{row[9].value}"
    lote = Lote.find_by(producto_id: producto.id, codigo_lote: row[9].value.to_s)
    if !row[21].nil?
      contenedor = Contenedor.find_by(nombre: row[21].value.to_s, codigo: row[21].value.to_s)
      if contenedor.nil?
        puts "[MIGRACION][#{fila}]: Creando Contenedor----- COLUMNA..."
        columna = Contenedor.new(nombre: row[10].value.to_s, codigo: row[21].value.to_s)
        columna.save
      end
    else
      columna = nil
    end
    if lote.nil?
      puts "[MIGRACION][#{fila}]: Creando lote..."
      lote = Lote.new(producto: producto, codigo_lote: row[9].value.to_s, fecha_vencimiento: row[6].value)
      lote.save
    end

    puts "[MIGRACION][#{fila}]: Buscando lote deposito... Producto/Deposito/Lote #{producto.id}/#{deposito.id}/#{lote.id}"
    lote_deposito = LoteDeposito.find_by(producto_id: producto.id, deposito_id: deposito.id, lote_id: lote.id)
    if lote_deposito.nil?
      cantidad =  row[27].nil? ? 0 : row[27].value.to_f
      puts "[MIGRACION][#{fila}]: Creando lote deposito... existencia: #{cantidad}"
      lote_deposito = LoteDeposito.new(producto: producto, deposito: deposito, lote: lote, cantidad: cantidad, contenedor: columna)
    else
      cantidad =  row[27].nil? ? 0 : row[27].value.to_f
      puts "[MIGRACION][#{fila}]: Sumando existencia... #{cantidad}"
      lote_deposito.cantidad += cantidad
      lote_deposito.contenedor = columna
    end
    puts "[MIGRACION][#{fila}]: Guardando lote_deposito... #{lote_deposito.to_yaml}"
    lote_deposito.save
  end


  def self.migrar_proveedores_sponsors()
    Proveedor.destroy_all
    Sponsor.destroy_all
    require 'rubyXL'
    path = "Script/patrocinadores.xlsx"
    puts "[MIGRACION] Parseando el archivo..."
    workbook = RubyXL::Parser.parse(path)
    puts "[MIGRACION] Se parseo el archivo..."
    worksheet = workbook[0]            # Returns first worksheet
    puts "[MIGRACION] Se obtuvo la primera hoja..."
    fila = 0
    worksheet.each do |row|
      if fila > 0

        if !row[2].nil?
          if row[2].value == 'Proveedores'
            proveedor = nuevoProveedor(row, fila)
          elsif row[2].value == 'patrocinador'
            patrocinador = nuevoSponsor(row, fila)
          end
        else
          puts "\t\t\t[MIGRACION] [#{fila}] [SIN TIPO]: #{row[0].value}"
        end
      end
      fila = fila+1
    end
  end

  def self.nuevoProveedor(row, fila)
    begin
      puts "[MIGRACION] [#{fila}] [PROVEEDOR]: #{row[0].value}"
      ci_ruc = (row[3].value == "" or row[3].value.nil?) ? row[0].value.hash.to_s : row[3].value.to_s
      existe = Proveedor.find_by(ruc: ci_ruc)
      if !existe
        p = Proveedor.new()
        p.razon_social = row[0].value
        p.ruc = ci_ruc
        p.direccion = row[11].value
        telefono = row[4].value.to_s.delete(' ').delete('-')
        p.telefono = telefono == "" ? nil : telefono
        p.email = row[7].value
        p.persona_contacto = row[5].value
        telefono = row[9].value.to_s.delete(' ').delete('-')
        p.telefono_contacto = telefono

        p.save!
      end
    rescue ActiveRecord::RecordInvalid=> invalid
      puts invalid.record.errors.messages
      #puts "#{p.to_yaml}"
      puts "TELEFONO: .#{telefono}."
    end
  end


  def self.nuevoSponsor(row, fila)
    begin
      puts "[MIGRACION] [#{fila}] [SPONSOR]: #{row[0].value}"
      ci_ruc = (row[3].value == "" or row[3].value.nil?) ? row[0].value.hash.to_s : row[3].value.to_s
      existe = Persona.find_by(ci_ruc: ci_ruc)
      if !existe
        persona = Persona.new()
        persona.razon_social = row[0].value
        persona.direccion = row[11].value
        telefono = row[4].value.to_s.delete(' ').delete('-')
        persona.telefono = telefono == "" ? nil : telefono
        persona.tipo_persona = 'Jurídica'
        persona.nacionalidad = 'PARAGUAYA'
        telefono = row[9].value.to_s.delete(' ').delete('-')
        persona.celular = telefono == "" ? nil : telefono
        persona.correo = row[7].value
        persona.ci_ruc = ci_ruc
      else
        persona = existe
      end
      sponsor = Sponsor.new()
      sponsor.persona = persona
      sponsor.segmento = row[2].value
      sponsor.activo = true
      sponsor.contacto_nombre = row[5].value
      sponsor.contacto_apellido = nil
      sponsor.contacto_celular = row[10].value
      sponsor.contacto_cargo = row[6].value

      sponsor.save!
    end
  rescue ActiveRecord::RecordInvalid=> invalid
    puts invalid.record.errors.to_yaml
  end




  def self.migrar_colaboradores()
    Colaborador.destroy_all
    require 'rubyXL'
    path = "Script/voluntarios.xlsx"
    puts "[MIGRACION] Parseando el archivo..."
    workbooks = RubyXL::Parser.parse(path)
    puts "[MIGRACION] Se parseo el archivo..."
    #worksheet = workbooks[0]            # Returns first worksheet
    tipos = ["Doctor", "Voluntario", "Estudiantil Universitario"]
    workbooks.each do |worksheet|
      i = 0
      fila = 0
      worksheet.each do |row|
        if fila > 0
          nuevoColaborador(row, fila, tipos[i])
        end
        fila = fila+1
      end
      i = i+1
    end
  end



  def self.nuevoColaborador(row, fila, tipo)
    hash_especialidad = {"Nutrición" => "NUT",
                         "Enfermero Pre/Post" => "ENFPP",
                         "Cirujano" => "CIR",
                         "Odontología" => "ODO",
                         "Enfermeria OR" => "ENFOR",
                         "Fonoaudiología" => "FON",
                         "Anestesiología" => "ANE",
                         "Otorrinolaringología" => "OTO",
                         "Pediatría" => "PED",
                         "Enfermero Pre/Post Noche"=> "ENFPPNOCH",
                         "Instrumentista" => "INST",
                         "Enfermero Recovery" => "ENVRECOVER",
                         "Biomédico" => "BIO",
                         "PIT" => "PIT"}
    begin

      puts "[MIGRACION] [#{fila}] [COLABORADOR]: #{row[0].value}"
      n = row[0].nil? or row[0].value.nil? ? "" : row[0].value
      a = row[1].nil? or row[1].value.nil? ? "" : row[1].value
      nombre = n + a
      ci_ruc = (!row[3].nil? or row[3].value == "" or row[3].value.nil?) ? nombre.hash.to_s : row[3].value.to_s
      ci_ruc = ci_ruc.delete('.')
      existe = Persona.find_by(ci_ruc: ci_ruc)
      if !existe
        persona = Persona.new()
        #persona.razon_social = row[0].value + row[1].value
        persona.nombre = row[0].value
        persona.apellido = row[1].value
        persona.fecha_nacimiento = !row[4].nil? and !row[4].value.nil? and !row[4].value.eql?'' ? row[4].value.to_date : nil
        #persona.direccion = row[11].value
        telefono = row[5].value.to_s.delete(' ').delete('-').delete('.')
        persona.telefono = telefono == "" ? nil : telefono
        persona.tipo_persona = 'Física'
        persona.nacionalidad = 'PARAGUAYA'
        telefono = row[6].value.to_s.delete(' ').delete('-').delete('.')
        persona.celular = telefono == "" ? nil : telefono
        persona.correo = row[8].value
        persona.ci_ruc = ci_ruc
      else
        persona = existe
      end
      puts "Persona: #{persona.to_yaml}"
      voluntario = Colaborador.new()
      voluntario.persona = persona
      voluntario.tipo_colaborador = TipoColaborador.find_by(nombre: tipo)
      voluntario.activo = row[10].value!=nil && row[10].value.eql?("Activo") ? true : false
      puts "Buscando especialidad #{hash_especialidad[row[2].value]}"
      voluntario.especialidad_id = Especialidad.find_by(codigo: hash_especialidad[row[2].value])
      voluntario.voluntario = true
      voluntario.licencia = row[12].value
      #voluntario.save!
      puts "VOLUNTARIO: #{voluntario.to_yaml}"
    end
  rescue ActiveRecord::RecordInvalid=> invalid
    puts invalid.record.errors.to_yaml
  end



  def self.migrar_pacientes()
    #Pacientes.destroy_all
    require 'rubyXL'
    path = "Script/pacientes.xlsx"
    puts "[MIGRACION] Parseando el archivo..."
    workbook = RubyXL::Parser.parse(path)
    puts "[MIGRACION] Se parseo el archivo..."
    worksheet = workbook[0]            # Returns first worksheet
    puts "[MIGRACION] Se obtuvo la primera hoja..."
    fila = 0
    worksheet.each do |row|
      if fila > 0
        #puts "[MIGRACION] [#{fila}] : #{row}"
        if row[0].nil? or row[0].value == "" or row[0].value.nil?
          migrar_paciente row, fila
         
        end
      end
      fila += 1
    end
  end

  def self.migrar_paciente(row, fila)
    #puts "#{fila} Nombre #{get_nombre(row,fila)} #{get_apellido(row,fila)} - #{get_ci(row,fila, "hola")}"
    #puts "#{fila} #{get_contacto_emergencia(row,fila)}"
    #puts "#{fila} #{get_datos_familiares(row,fila)}"
    #puts "#{fila} #{get_observaciones(row,fila)}"
    #puts "#{fila} #{get_seguro_medico(row,fila)}"
    #puts "#{fila} #{get_numero_ficha(row,fila)}"
    #puts "#{fila} #{get_barrio(row,fila)}"
    #puts "#{fila} #{get_fecha(row,fila)}"
    #paciente = get_ciudad(row, fila)
    #paciente = get_fecha(row, fila)
    begin
      puts "[MIGRACION] [#{fila}] [paciente]:  #{get_nombre(row,fila)}"
      nombre = get_nombre(row,fila)
      apellido = get_apellido(row,fila)
      ci_ruc = get_ci(row,fila, nombre+apellido)
      contacto_emergencia = get_contacto_emergencia(row,fila)
      datos_familiares = get_datos_familiares(row,fila)
      observaciones = get_observaciones(row,fila)
      seguro_medico = get_seguro_medico(row,fila)
      ciudad = get_ciudad(row, fila)
      fecha_nacimiento = get_fecha(row, fila)
      barrio = get_barrio(row, fila)
      nro_ficha = get_numero_ficha(row, fila)

      otros_datos = JSON.parse('{"tieneSeguro": "", "empresaDeSeguro": "", "dondeSiguioTratamientoPediatrico": ""}')
      if seguro_medico.nil? or seguro_medico.eql?("") or seguro_medico.eql?("No") or seguro_medico.eql?("no")
        otros_datos['tieneSeguro'] = "no"
      else
        otros_datos['tieneSeguro'] = "si"
        otros_datos['empresaDeSeguro']=seguro_medico
      end
      otros_datos = otros_datos.to_json

      vinculos = JSON.parse('{"misiones": {}, "asistencia": "", "comoSeEntero": {"fuente": null, "detalle": ""}, "misionAsociada": "", "sigueTratamiento": "", "fechaPrimeraConsulta": ""}').to_json
      datos_importantes = JSON.parse('{"alergias": null, "cirugias": null, "embarazo": false, "problemas": {"otros": null, "visuales": null, "auditivos": null, "cardiacos": {"soplo": false, "valvulas": false, "congenito": false, "miocarditis": false, "hipertension": false, "perturbacion": false, "cardiopatiaReumatica": false}, "sindromes": null, "infecciones": {"VIH": false, "otros": null, "malaria": false, "hepatitis": false}, "respiratorios": {"asma": false, "neumonia": false, "difRespiratoria": false, "infRespiratoria": false}, "neuromusculares": {"debilidad": false, "desarrollo": false, "convulsiones": false}}, "medicamentos": null}').to_json


      
      existe = Persona.find_by(ci_ruc: ci_ruc.to_s)

      if !existe
        persona = Persona.new()
        persona.nombre = nombre
        persona.apellido = apellido
        persona.razon_social = nombre + apellido
        persona.fecha_nacimiento = fecha_nacimiento
        persona.barrio = barrio
        persona.tipo_persona = 'Física'
        persona.nacionalidad = 'PARAGUAYA'
        persona.ci_ruc = ci_ruc
        persona.ciudad_id = ciudad.id
        persona.direccion = barrio
      else
        persona = existe
      end
      
      #puts "Persona: #{persona.to_yaml}"
      paciente = Paciente.new()
      paciente.persona = persona
      paciente.numero_paciente = nro_ficha
      paciente.datos_familiares = datos_familiares
      paciente.contacto_emergencia = contacto_emergencia
      paciente.observacion = observaciones
      paciente.datos_importantes = datos_importantes
      paciente.vinculos = vinculos
      paciente.otros_datos = otros_datos
      paciente.save!
      #puts "PACIENTE: #{paciente.to_yaml}"
    rescue ActiveRecord::RecordInvalid=> invalid
      puts invalid.record.errors.to_yaml
    end
  end

  def self.get_numero_ficha(row, fila)
    seguro = (row[1].nil? or row[1].value.nil?) ? "" : row[1].value
    return seguro
  end

  def self.get_seguro_medico (row, fila)
    seguro = (row[27].nil? or row[27].value.nil?) ? "" : row[27].value
    return seguro
  end

  def self.get_contacto_emergencia(row,fila)
    # "{"nombre": "", "relacion": "", "telefono": ""}"
    contacto = (row[12].nil? or row[12].value.nil?) ? "" : row[12].value
    tipo_contacto = (row[13].nil? or row[13].value.nil?) ? "" : row[13].value
    telefono_1 = (row[14].nil? or row[14].value.nil?) ? "" : row[14].value
    telefono_2 = (row[15].nil? or row[15].value.nil?) ? "" : row[15].value
    
    str = '{"nombre": "", "relacion": "", "telefono": ""}'
    
    json = JSON.parse(str)
    json['nombre'] = contacto
    json['relacion'] = tipo_contacto
    json['telefono']= get_telefono(telefono_1, telefono_2)
    #puts "#{json.to_json}"
    return json.to_json
  end

  def self.get_telefono(t1,t2)
    t = t1.to_s
    if !t2.nil? and !t2.eql?"" 
      t += "/" + t2.to_s
    end
    return t
  end

  def self.get_observaciones(row, fila)
    diagnostico_1 = (row[18].nil? or row[18].value.nil?) ? "" : row[18].value
    diagnostico_2 = (row[19].nil? or row[19].value.nil?) ? "" : row[19].value
    fue_operado = (row[20].nil? or row[20].value.nil?) ? "" : row[20].value
    fecha_operacion_1 = (row[21].nil? or row[21].value.nil?) ? "" : row[21].value
    fecha_operacion_2 = (row[22].nil? or row[22].value.nil?) ? "" : row[22].value
    lugar_1 = (row[23].nil? or row[23].value.nil?) ? "" : row[23].value
    lugar_2 = (row[24].nil? or row[24].value.nil?) ? "" : row[24].value
    operado_por = (row[25].nil? or row[25].value.nil?) ? "" : row[25].value

    str = "Primer Diagnóstico: #{diagnostico_1} \n"
    str += "Segundo Diagnóstico: #{diagnostico_2} \n" 
    str += "Fue Operado: #{fue_operado} \n" 
    str += "Fecha Primera Operación: #{fecha_operacion_1} \n" 
    str += "Lugar Primera Operacion: #{lugar_1} \n" 
    str += "Fecha Segunda Operación: #{fecha_operacion_2} \n" 
    str += "Lugar Segunda Operacion: #{lugar_2} \n" 
    str += "Operado por: #{operado_por} \n" 

    return str

  end

  def self.get_datos_familiares(row,fila)
    # "{"madre": {"edad": 0, "nombre": "", "ocupacion": "", "escolaridad": null}, "padre": {"edad": 0, "nombre": "", "ocupacion": "", "escolaridad": null}, "edadesHermanos": "", "numeroHermanos": "", "comparteVivienda": ""}"
    contacto = (row[12].nil? or row[12].value.nil?) ? "" : row[12].value
    tipo_contacto = (row[13].nil? or row[13].value.nil?) ? "" : row[13].value
    telefono_1 = (row[14].nil? or row[14].value.nil?) ? "" : row[14].value
    telefono_2 = (row[15].nil? or row[15].value.nil?) ? "" : row[15].value
    str = '{"madre": {"edad": 0, "nombre": "", "ocupacion": "", "escolaridad": null}, "padre": {"edad": 0, "nombre": "", "ocupacion": "", "escolaridad": null}, "edadesHermanos": "", "numeroHermanos": "", "comparteVivienda": ""}'
    json = JSON.parse(str)
    if normalizar(tipo_contacto).upcase.eql?("MAMA") 
      json['madre']['nombre']=contacto
      json['madre']['telefono']=get_telefono(telefono_1, telefono_2)
    elsif normalizar(tipo_contacto).upcase.eql?("PAPA")
      json['padre']['nombre']=contacto
      json['padre']['telefono']=get_telefono(telefono_1, telefono_2)
    else
      #puts ">>>>>>>>>> #{fila} NO EXISTE #{normalizar(tipo_contacto)}"
    end
    return json.to_json
  end
  def self.get_ci (row, fila, nombre)
    ci = (row[10].nil? or row[10].value.nil?) ? "" : row[10].value
    ci = ci.to_s.gsub(".","")
    ci = ci.to_s.gsub(" ","")
    
    obs = (row[11].nil? or row[11].value.nil?) ? "" : row[11].value
    obs = obs == "" ? obs : "/"+obs
    ci = ci.to_s + obs
    if ci.eql?("") or ci.nil? or ci.eql?("RN")
      ci = nombre.hash
    end
    return ci
  end

  def self.get_nombre (row, fila)
    nombre = ""
    nombres_range = [2,3,4]
    nombres_range.each do |p|
      nombre += (row[p].nil? or row[p].value.nil?) ? "" : " " + row[p].value
    end
    nombre
  end

  def self.get_apellido (row, fila)
    nombre = ""
    nombres_range = [5,6,7]
    nombres_range.each do |p|
      nombre += (row[p].nil? or row[p].value.nil?) ? "" : " " + row[p].value
    end
    nombre
  end

  def self.get_fecha(row, fila)
    if row[9].nil? or row[9].value.nil?
      puts "#{fila} #{row[9].nil? ? "SIN DATO" : row[9].value}"
    else
      begin
        return row[9].value.to_date
      rescue Exception => e 
        puts "WARN #{fila} #{e.message}"
      end
    end
    return nil
  end

  def self.get_ciudad(row, fila)

    ciudad = (row[16].nil? or row[16].value == "") ? "SIN DATO" : row[16].value
    departamento = (row[17].nil? or row[17].value == "") ? "SIN DATO" : row[17].value
    
    #puts "#{fila} Ciudad: #{ciudad} - Departamento: #{departamento}"

    city = Ciudad.by_nombre(transform(normalizar(ciudad).upcase))

    #puts "#{city.nil? ? "NULL" : city.nombre}"
    #puts "#{city.to_yaml}"

    if city.first.nil?
      city = Ciudad.by_nombre("SIN EQUIVALENCIA")
      puts "WARN #{fila} CIUDAD .#{transform(normalizar(ciudad).upcase)}. --- #{departamento}"
    end

    return city.first
  end

  def self.get_barrio(row,fila)
    ciudad = (row[16].nil? or row[16].value == "" or row[16].value.nil?) ? "SIN DATO" : row[16].value
    departamento = (row[17].nil? or row[17].value == "" or row[17].value.nil?) ? "SIN DATO" : row[17].value
    return ciudad + "/" + departamento
  end

 def self.normalizar nombre
    return nombre.to_s.tr(
"ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
"AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
  end
  
  def self.transform(nombre)
    nombre = nombre.end_with?(" ") ? nombre.last(1) : nombre
    nombre = nombre == "CORONEL OVIEDO" ? "CNEL. OVIEDO" : nombre
    nombre = (nombre.include?"CDE") ? "CIUDAD DEL ESTE" : nombre
    nombre = nombre == "FDO DE LA MORA" ? "FERNANDO DE LA MORA" : nombre
    nombre = nombre == "FDO. DE LA MORA" ? "FERNANDO DE LA MORA" : nombre
    nombre = nombre == "ITAGUA" ? "ITAUGUA" : nombre
    nombre = nombre == "S. LORENZO" ? "SAN LORENZO" : nombre
    nombre = nombre.include?("LORENZO") ? "SAN LORENZO" : nombre

    nombre = nombre == "ZEBALLOSCUE" ? "ASUNCION" : nombre
    nombre = nombre == "SAJONIA" ? "ASUNCION" : nombre
  
    nombre = nombre == "VILLARICA" ? "VILLARRICA" : nombre
    nombre = (nombre.include?"YCUA") ? "SAN PEDRO DE YCUAMANDYYU" : nombre
    nombre = nombre == "AMAMBAY" ? "PEDRO JUAN CABALLERO" : nombre
    nombre = nombre == "CAMPO NUEVE" ? "CAAGUAZU" : nombre
    nombre = nombre == "SANTA ROSA DE LA AGUARAY" ? "SANTA ROSA DEL AGUARAY" : nombre
    nombre = nombre == "STA ROSA DEL AGUEROY" ? "SANTA ROSA DEL AGUARAY" : nombre
    nombre = nombre == "KAMBYRETA" ? "CAMBYRETA" : nombre
    nombre = (nombre.include?"BELEN") ? "BELEN" : nombre
    nombre = (nombre.include?"PINA") ? "PTO.PINAZCO" : nombre
    nombre = (nombre.include?"PRESIDENTE FRANCO") ? "PUERTO PTE.FRANCO" : nombre
    nombre = (nombre.include?"CAPIBARY") ? "CAPIIBARY" : nombre
    
    nombre = (nombre.include?"M. R. ALONSO") ? "MARIANO ROQUE ALONSO" : nombre
    nombre = (nombre.include?"MRA") ? "MARIANO ROQUE ALONSO" : nombre
    nombre = (nombre.include?"MARIANO R. A.") ? "MARIANO ROQUE ALONSO" : nombre
    nombre = (nombre.include?"M.R ALONSO") ? "MARIANO ROQUE ALONSO" : nombre
    nombre = (nombre.include?"M.R.ALONSO") ? "MARIANO ROQUE ALONSO" : nombre



    nombre = (nombre.include?"CLETO ROMERO") ? "JUAN DE MENA" : nombre
    nombre = (nombre.include?"TACUATI") ? "TACUATI" : nombre
    nombre = (nombre.include?"ELISA") ? "VILLA ELISA" : nombre
    nombre = (nombre.include?"SALDIVAR") ? "J.AUGUSTO SALDIVAR" : nombre
    nombre = (nombre.include?"VALLEMI") ? "SAN LAZARO" : nombre
    nombre = (nombre.include?"MISIONES") ? "SAN IGNACIO" : nombre
    nombre = (nombre.include?"MARZO") ? "1RO.DE MARZO" : nombre
    nombre = (nombre.include?"GONZALEZ") ? "ROQUE GONZALEZ" : nombre
    nombre = (nombre.include?"INDEPEND") ? "INDEPENDENCIA (R.D.MELGAREJO)" : nombre
    nombre = (nombre.include?"CNEL OVIEDO") ? "CNEL. OVIEDO" : nombre
  
    nombre = (nombre.include?"QUIROYTY") ? "CAACUPE" : nombre
    nombre = (nombre.include?"TACUMBU") ? "ASUNCION" : nombre
    nombre = (nombre.include?"BARRIO SAN PABLO") ? "ASUNCION" : nombre
    nombre = (nombre.include?"PTE. FRANCO") ? "PUERTO PTE.FRANCO" : nombre
    nombre = (nombre.include?"GUAZU - CUA") ? "GUAZU CUA" : nombre
    nombre = (nombre.include?"MERCADO 4") ? "ASUNCION" : nombre


    nombre = (nombre.include?"YTAKYRY") ? "ITAKYRY" : nombre
    nombre = (nombre.include?"BARRERO") ? "EUSEBIO AYALA" : nombre
    nombre = (nombre.include?"KAPI'I VARY") ? "CAPIIBARY" : nombre
    nombre = (nombre.include?"YAU") ? "YBY YA\\U" : nombre
    nombre = (nombre.include?"MIRANDA") ? "CAPITAN MIRANDA" : nombre

    nombre = (nombre.include?"BOGADO") ? "CORONEL BOGADO" : nombre
    nombre = (nombre.include?"LEARY") ? "JUAN E.O\\LEARY" : nombre
    nombre = (nombre.include?"TEBICUARYMI") ? "TEBICUARY MI" : nombre
    nombre = (nombre.include?"PJC") ? "PEDRO JUAN CABALLERO" : nombre
    return nombre
  end

end
