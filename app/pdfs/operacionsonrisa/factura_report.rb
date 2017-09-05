# encoding: utf-8
require "prawn/measurement_extensions"

class FacturaReportPdf < Prawn::Document
  def initialize(venta)

    super(:page_size => "LEGAL", :bottom_margin => 0, :left_margin =>0)
    @color_texto = '3E4D4A'
    venta = Venta.unscoped.find(venta.id)
    header(venta)

    if(venta.moneda.simbolo == 'Gs.')
      @moneda = 'guaranies'
    elsif(venta.moneda.simbolo == 'US$')
      @moneda = 'dolares'
    end
    dibujar_venta(venta)

  end

  def header(venta)
    stroke_horizontal_rule

    bounding_box([0,cursor], :width => self.bounds.right) do

      pad(20){
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte Salida", :align => :center
        text "Tipo de Salida: #{venta.tipo_salida.descripcion}", :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center
      }
    end
    stroke_horizontal_rule
  end


  def dibujar_venta (venta)

    if venta.moneda.redondeo
      decimales = 0
    else
      decimales = 2
    end

    move_down 5.mm

    if venta.nombre_cliente
      nombreCliente =  "Nombre y Apellido o Razón Social: #{venta.nombre_cliente}"
    elsif venta.cliente
      nombreCliente = "Nombre y Apellido o Razón Social: #{venta.getPersona.razon_social}"
    end

    if venta.getPersona.razon_social or venta.getPersona.telefono.nil? or venta.getPersona.telefono.empty?
      telefono = "-"
    else
      telefono = venta.getPersona.telefono
    end

    if venta.nombre_cliente
      ciRuc =  "C.I. Nº / RUC Nº: #{venta.ruc_cliente}"
    else
      ciRuc =  "C.I. Nº / RUC Nº: #{venta.getPersona.ci_ruc}"
    end

    if venta.nombre_cliente or venta.getPersona.direccion.nil? or venta.getPersona.direccion.empty?
      direccion = "-"
    else
      direccion = venta.getPersona.direccion
    end

    bounding_box([10,cursor], :width => self.bounds.right) do
      pad(10){
        text "Fecha de Emisión: #{(venta.fecha_registro + 32400).strftime("%d/%m/%Y")}", size:10 #32400 segundos = 4hs, la hora en la BD esta en UTC
        text "Condición de Venta: #{venta.credito == false ? "Contado" : "Crédito"}", size:10
        text "#{nombreCliente}",size: 10
        text "Teléfono: #{telefono}",size: 10
        text "#{ciRuc}",size: 10
        text "Dirección: #{direccion}",size: 10
      }
    end

    subtotal_exentas = 0
    subtotal_iva5 = 0
    subtotal_iva10 = 0

    altura = cursor

    venta_detalles_array = []
    venta.venta_detalles.map do |detalle|
      venta_detalles_array.push(["#{Integer(detalle.cantidad)}","#{detalle.producto.descripcion}","#{to_Gs(detalle.precio/detalle.cantidad)}","#{(detalle.precio * detalle.cantidad) if detalle.producto.iva == 0}","#{(detalle.precio * detalle.cantidad) if detalle.producto.iva == 5}","#{(detalle.precio * detalle.cantidad) if detalle.producto.iva == 10}"])
      if detalle.producto.iva.eql? 0.0
        subtotal_exentas += detalle.precio * detalle.cantidad - detalle.descuento
      end
      if detalle.producto.iva.eql? 5.0
        subtotal_iva5 += detalle.precio * detalle.cantidad - detalle.descuento
      end
      if detalle.producto.iva.eql? 10.0
        subtotal_iva10 += detalle.precio * detalle.cantidad - detalle.descuento
      end
    end
    venta_detalles_array.push(["","","","#{subtotal_exentas}","#{subtotal_iva5}","#{subtotal_iva10}"])
    dibujar_venta_detalles(venta_detalles_array)

    total_a_pagar = subtotal_exentas + subtotal_iva5 + subtotal_iva10
    parte_entera_en_letras = numero_a_palabras(Integer(total_a_pagar)).upcase

    total_en_letras = to_Money(total_a_pagar).to_s + " (" + parte_entera_en_letras

    if(!venta.moneda.redondeo)
      parte_decimal = Integer((total_a_pagar - Integer(total_a_pagar)) * 100)
      parte_decimal_en_letras = numero_a_palabras(parte_decimal).upcase
      if(parte_decimal > 0)
        total_en_letras = total_en_letras + " CON " + parte_decimal_en_letras + " CENTAVOS"
      end

    end
    total_en_letras = total_en_letras + ")"
    total_iva = venta.iva5 + venta.iva10

    bounding_box([10,cursor], :width => self.bounds.right) do
      pad(10){
        text "Liquidación del IVA 5%: #{to_Money(venta.iva5)}", size:10
        text "Liquidación del IVA 10%: #{to_Money(venta.iva10)}", size:10
        text "Liquidación TOTAL IVA: #{to_Money(total_iva)}", size:10
        text "Total a pagar en letras: #{total_en_letras}", size:10
        text "Total a pagar: #{to_Money(total_a_pagar).to_s}", size:10
      }
    end
  end

  def numero_a_palabras(numero)
    de_tres_en_tres = numero.to_i.to_s.reverse.scan(/\d{1,3}/).map{|n| n.reverse.to_i}

    millones = [
      {true => nil, false => nil},
      {true => 'millon', false => 'millones'},
      {true => "billon", false => "billones"},
      {true => "trillon", false => "trillones"}
    ]

    centena_anterior = 0
    contador = -1
    palabras = de_tres_en_tres.map do |numeros|
      contador += 1
      if contador%2 == 0
        centena_anterior = numeros
        [centena_a_palabras(numeros), millones[contador/2][numeros==1]].compact if numeros > 0
      elsif centena_anterior == 0
        [centena_a_palabras(numeros), "mil", millones[contador/2][false]].compact if numeros > 0
      else
        [centena_a_palabras(numeros), "mil"] if numeros > 0
      end
    end

    palabras.compact.reverse.join(' ')
  end

  def centena_a_palabras(numero)
    especiales = {
      11 => 'once', 12 => 'doce', 13 => 'trece', 14 => 'catorce', 15 => 'quince',
      10 => 'diez', 20 => 'veinte', 100 => 'cien'
    }
    if especiales.has_key?(numero)
      return especiales[numero]
    end

    centenas = [nil, 'ciento', 'doscientos', 'trescientos', 'cuatrocientos', 'quinientos', 'seiscientos', 'setecientos', 'ochocientos', 'novecientos']
    decenas = [nil, 'dieci', 'veinti', 'treinta', 'cuarenta', 'cincuenta', 'sesenta', 'setenta', 'ochenta', 'noventa']
    unidades = [nil, 'un', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho', 'nueve']

    centena, decena, unidad = numero.to_s.rjust(3,'0').scan(/\d/).map{|i| i.to_i}

    palabras = []
    palabras << centenas[centena]

    if especiales.has_key?(decena*10 + unidad)
      palabras << especiales[decena*10 + unidad]
    else
      tmp = "#{decenas[decena]}#{' y ' if decena > 2 && unidad > 0}#{unidades[unidad]}"
      palabras << (tmp.blank? ? nil : tmp)
    end

    palabras.compact.join(' ')
  end

  def dibujar_venta_detalles(venta_detalles)
    #move_down 30
    #if cursor <80
    #  start_new_page
    #end
    ancho = self.bounds.right
      table dibujar_detalles(venta_detalles), :cell_style => { :size => 6, :padding => 2 } do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho/6),(ancho/6),(ancho/6),(ancho/6),(ancho/6),(ancho/6)]
    end
  end

def dibujar_detalles(ventaDetalles)
    [['Descripción', 'Cantidad','Precio Unitario','Exentas','Iva 5%','Iva 10%']] + ventaDetalles
  end


  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end
  def to_USD(monto)
    return ActionController::Base.helpers.number_to_currency(monto, precision: 2, unit: "",  separator: ".", delimiter: ",")
  end
  def to_Money(monto)
    if (@moneda == 'guaranies')
      return to_Gs(monto)
    elsif(@moneda == 'dolares')
      if(monto - Integer(monto)>0)
        return to_USD(monto.round(2))
      else
        return Integer(monto)
      end
    end
  end

end
