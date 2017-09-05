# encoding: utf-8


require "prawn/measurement_extensions"

class ReciboCuotaReport < Prawn::Document

  def initialize(pago)
    super(:page_size => "LEGAL", :bottom_margin => 0, :left_margin =>0, :right_margin =>0, :top_margin =>0)
  	@color_texto = '3E4D4A'
  	pago = Pago.unscoped.find(pago.id)
  	dibujar_venta(pago,0)
    dibujar_venta(pago,1)
  end

  def dibujar_venta (pago, offset)
    move_down 44.mm
    altura = cursor - (offset * 22.mm)
    bounding_box([67.mm, altura], :width => self.bounds.right) do
      # text "#{pago.id}",size:9
    end
    
    bounding_box([161.mm, altura], :width => self.bounds.right) do
      text "#{to_Gs(Integer(pago.total_moneda_seleccionada))}",size:9
    end

    move_down 12.mm
    altura = cursor
    bounding_box([31.mm, altura], :width => self.bounds.right) do
        text "#{pago.venta.cliente.nombre}" + " #{pago.venta.cliente.apellido}",size:9
    end
    
    bounding_box([173.mm, altura], :width => self.bounds.right) do
        text "#{pago.venta.cliente.ruc}",size:9
    end

    move_down 6.mm
    altura = cursor

    numero_en_letras = numero_a_palabras(pago.total_moneda_seleccionada).upcase
    bounding_box([10.mm, altura], :width => 195.mm) do
      text_box "#{Prawn::Text::NBSP * 70}"+ " #{numero_en_letras}",:size => 9, :leading => 14
    end

    if cursor == altura #si la descripcion de la cantidad de guaranies ocupa solo un renglon 
      move_down 18.mm
    else
      move_down 9.mm
    end

    altura = cursor
    # var estado_pagada
    bounding_box([10.mm, altura], :width => 195.mm) do
    # pago.pago_detalles.map do |detalle|
    #   temp = detalle.venta_cuota
    #   if temp.estado == Settings.estadosCuotas.pagada
    #     estado_pagada=1     
    #   else
    #     estado_pagada=0
    #   end
    # end
    if pago.pago_detalles.last.venta_cuota.estado==Settings.estadosCuotas.pagada

          numero_cuota_lista=numero_lista(pago.pago_detalles.first.venta_cuota.nro_cuota,pago.pago_detalles.last.venta_cuota.nro_cuota)
          text_box "#{Prawn::Text::NBSP * 43}"+ " Pago cuota N. #{numero_cuota_lista} según Factura Nro. #{pago.venta.nro_factura}",size:9
    else
      text_box "#{Prawn::Text::NBSP * 43}"+ " Pago parcial según Factura Nro. #{pago.venta.nro_factura}",size:9
    end
    if cursor == altura #si la descripcion del concepto de pago ocupa solo un renglon 
        move_down 53.mm
    else
        move_down 44.mm
    end
  end

    altura = cursor
    bounding_box([32.mm, altura], :width => self.bounds.right) do
      text "Asunción" + " - #{pago.fecha_pago}", size:9
    end
    altura = cursor

  end
def numero_lista(numerobase,numerotope)
  temp=""
  if numerobase == numerotope
    temp=numerobase.to_s
  else
    for i in 0...(numerotope-numerobase+1)
      temp=temp+"#{numerobase+i}, "
    end
  end 
  return(temp)
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
    unidades = [nil, 'uno', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho', 'nueve']
   
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

def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end

end