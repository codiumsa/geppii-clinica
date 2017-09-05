# encoding: utf-8
class UsoInternoReportPdf < Prawn::Document
  def initialize(venta)
    
    super(:page_size => [646.3, 790.87], :bottom_margin => 0, :left_margin =>0, :top_margin =>0)

    @color_texto = '3E4D4A'
    dibujar_venta venta
  end
 
    
  def dibujar_venta (venta)
    #move_down 10
    altura = cursor
    #bounding_box([80, altura], :width => self.bounds.right) do
    #  text "#{venta.fecha_registro.strftime("%d/%m/%Y")}", size:10
    #end

    altura = cursor
    bounding_box([80, altura], :width => self.bounds.right) do
      if venta.nombre_cliente 
        text "#{venta.nombre_cliente}", size: 10
      else
        text "#{venta.cliente.razon_social}", size: 10
      end
    end

    if venta.cliente.direccion.nil? or venta.cliente.direccion.empty?
	direccion = "-"
    else
        direccion = venta.cliente.direccion
    end
    
    altura = cursor
    bounding_box([80, altura], :width => self.bounds.right) do
	text "#{direccion}", size:10
    end

    if venta.cliente.telefono.nil? or venta.cliente.telefono.empty?
        telefono = "-"
    else
	telefono = venta.cliente.telefono
    end
    altura = cursor
    bounding_box([80, altura], :width => self.bounds.right) do
      text "#{telefono}", size:10
    end

    altura = cursor
    bounding_box([80, altura], :width => self.bounds.right) do
      text "FECHA: #{venta.fecha_registro.strftime("%d/%m/%Y")}", size:10
    end

    subtotal_exentas = 0
    subtotal_descuento = 0

    move_down 25
    altura = cursor

    pos_descuento = 375
    pos_exentas = 540 #la posicion de la columna de exentas en el eje horizontal
    venta.venta_detalles.map do |detalle|
      bounding_box([25, altura], :width => self.bounds.right) do
        text "#{Integer(detalle.cantidad)}", size:10
      end
      bounding_box([43, altura], :width => self.bounds.right) do
        text "#{detalle.producto.descripcion}", size:10
      end
      bounding_box([325, altura], :width => self.bounds.right) do
        text "#{Integer(detalle.precio)}", size:10
      end
      bounding_box([pos_descuento, altura], :width => self.bounds.right) do
        text "#{Integer(detalle.precio - (detalle.descuento / detalle.cantidad))}", size:10
      end
      subtotal_descuento += detalle.descuento

      #SE TOMAN TODAS COMO EXENTAS POR SER COMPROBANTE INTERNO
      subtotal_exentas += detalle.precio * detalle.cantidad  - detalle.descuento
      posicion_horizontal = pos_exentas
     
      bounding_box([posicion_horizontal, altura], :width => self.bounds.right) do
        subtotal = detalle.precio * detalle.cantidad - detalle.descuento
        text "#{Integer(subtotal)}", size:10
      end
      move_down 2
      altura = cursor
    end

    #ACA SE AGREGA EL DESCUENTO GENERAL
    
    subtotal_exentas = subtotal_exentas - venta.descuento_redondeo
    if not venta.descuento_redondeo.nil? and not venta.descuento_redondeo.eql? 0.0
      bounding_box([25, altura], :width => self.bounds.right) do
        text "1", size:10 #cantidad
      end
      bounding_box([43, altura], :width => self.bounds.right) do
        text "Descuento General", size:10 #descripcion
      end
      bounding_box([325, altura], :width => self.bounds.right) do
        text "#{Integer(-venta.descuento_redondeo)}", size:10 #precio
      end
      bounding_box([pos_descuento, altura], :width => self.bounds.right) do
        text "#{Integer(-venta.descuento_redondeo)}", size:10 #precio con descuento
      end
      bounding_box([pos_exentas, altura], :width => self.bounds.right) do
        text "#{Integer(-venta.descuento_redondeo)}", size:10 #subtotal
      end
    end

    y_totales = 80

    bounding_box([pos_exentas, y_totales], :width => self.bounds.right) do
      text "#{Integer(subtotal_exentas)}", size:10
    end

    total_a_pagar = subtotal_exentas
    numero_en_letras = numero_a_palabras(total_a_pagar).upcase
    bounding_box([60, y_totales], :width => self.bounds.right) do
      text "#{numero_en_letras}", size:10
    end    
  end

  def numero_a_palabras(numero)
    puts "NUMERO"
    puts numero
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
end
