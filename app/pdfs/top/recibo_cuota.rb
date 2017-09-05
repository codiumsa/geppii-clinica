# encoding: utf-8


require "prawn/measurement_extensions"

class ReciboCuotaReport < Prawn::Document

  def initialize(venta_cuota)
    super(:page_size => "LEGAL", :bottom_margin => 0, :left_margin =>0, :right_margin =>0, :top_margin =>0)
  	@color_texto = '3E4D4A'
  	venta_cuota = VentaCuota.unscoped.find(venta_cuota.id)
  	dibujar_venta(venta_cuota,0)
    dibujar_venta(venta_cuota,1)
  end

  def dibujar_venta (venta_cuota, offset)
    move_down 43.mm
    altura = cursor + (offset * 20.mm)
    bounding_box([67.mm, altura], :width => self.bounds.right) do
      text "#{venta_cuota.nro_recibo}",size:7
    end
    
    bounding_box([158.mm, altura], :width => self.bounds.right) do
      text "#{venta_cuota.monto}",size:7
    end

    move_down 15.mm
    altura = cursor
    bounding_box([31.mm, altura], :width => self.bounds.right) do
      text "#{venta_cuota.venta.cliente_id}",size:7
    end
    
    bounding_box([170.mm, altura], :width => self.bounds.right) do
      text "#{venta_cuota.venta.ruc_cliente}",size:7
    end

    move_down 8.mm
    altura = cursor

    numero_en_letras = numero_a_palabras(venta_cuota.monto)
    bounding_box([10.mm, altura], :width => self.bounds.right) do
      text_box "                              #{numero_en_letras}",size:7
    end

    if cursor == altura #si la descripcion de la cantidad de guaranies ocupa solo un renglon 
      move_down 17.mm
    else
      move_down 8.mm
    end

    altura = cursor
    bounding_box([10.mm, altura], :width => self.bounds.right) do
      text_box "                    Pago de cuota N. #{venta_cuota.nro_cuota} de factura N. #{venta_cuota.venta.nro_factura}",size:7
      if cursor == altura #si la descripcion del concepto de pago ocupa solo un renglon 
        move_down 42.mm
      else
        move_down 33.mm
      end
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