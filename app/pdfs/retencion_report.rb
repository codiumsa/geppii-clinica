# encoding: utf-8
require "prawn/measurement_extensions"

class RetencionReportPdf < Prawn::Document
  def initialize(compra)
    super(:page_size => [218.mm, 228.mm], :bottom_margin => 0, :left_margin =>0)
    @color_texto = '3E4D4A'
    dibujar_retencion compra
  end
 
    
  def dibujar_retencion(compra)
    move_down 107
    # bounding_box([450, cursor], :width => self.bounds.right) do
    #   text "#{venta.nro_factura}", size:11
    # end

    move_down 17

    altura = cursor

    bounding_box([45, altura], :width => self.bounds.right) do
      text "#{compra.fecha_registro.strftime("%d/%m/%Y")}", size:11
    end
    bounding_box([395, altura], :width => self.bounds.right) do
      text "FACTURA #{compra.nro_factura}", size:11
    end

    move_down 20
    altura = cursor
    bounding_box([200, altura], :width => self.bounds.right) do
      text "#{compra.proveedor.razon_social}", size: 11
    end
    move_down 30
    altura = cursor
    bounding_box([150, altura], :width => self.bounds.right) do
      text "#{compra.proveedor.ruc}", size:11
    end

    valor_sin_iva = compra.total - compra.iva5 - compra.iva10
    total_iva = compra.iva5 + compra.iva10
    if valor_sin_iva.eql? nil
      valor_sin_iva = 0
    end

    move_down 25
    altura = cursor
    bounding_box([150, altura], :width => self.bounds.right) do
      text "#{Integer(valor_sin_iva)}", size:11
    end

    move_down 25
    altura = cursor
    bounding_box([150, altura], :width => self.bounds.right) do
      text "#{Integer(total_iva)}", size:11
    end

    move_down 25
    altura = cursor
    bounding_box([150, altura], :width => self.bounds.right) do
      text "#{Integer(compra.total)}", size:11
    end

    move_down 25
    #ACA DEBE IR EL PORCENTAJE, AVERIGUAR QUE ONDA
    # altura = cursor
    # bounding_box([60, altura], :width => self.bounds.right) do
    #   text "#{compra.total}", size:11
    # end

    move_down 40
    altura = cursor
    bounding_box([300, altura], :width => self.bounds.right) do
      text "#{Integer(compra.retencioniva)}", size:11
    end

    move_down 60
    altura = cursor
    numero_en_letras = numero_a_palabras(compra.retencioniva).upcase
    bounding_box([150, altura - 15], :width => self.bounds.right) do
      text "#{numero_en_letras}", size:10
    end    
  end

  def numero_a_palabras(numero)
    puts "NUMERO"
    puts numero
    de_tres_en_tres = numero.to_i.to_s.reverse.scan(/\d{1,3}/).map{|n| n.reverse.to_i}
   
    millones = [
      {true => nil, false => nil},
      {true => 'millón', false => 'millones'},
      {true => "billón", false => "billones"},
      {true => "trillón", false => "trillones"}
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
