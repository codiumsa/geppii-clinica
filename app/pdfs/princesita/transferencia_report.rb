# encoding: utf-8
require "prawn/measurement_extensions"

class TransferenciaReportPdf < Prawn::Document
  def initialize(transferencia_deposito)
    super(:page_size => "LEGAL", :bottom_margin => 0, :left_margin =>0, :right_margin =>0, :top_margin =>0)

    @color_texto = '3E4D4A'
    transferencia_deposito = TransferenciaDeposito.unscoped.find(transferencia_deposito.id)

    dibujar_transferencia(transferencia_deposito,0)
    move_cursor_to(self.bounds.top)
    dibujar_transferencia(transferencia_deposito,1)


  end

  def dibujar_transferencia (transferencia, offset)
    move_down 18.mm
  	altura = cursor - (offset * 165.mm)
    nombre_vendedor = (Sucursal.where("deposito_id = ?", transferencia.destino_id)).first.vendedor.nombre
    apellido_vendedor = (Sucursal.where("deposito_id = ?", transferencia.destino_id)).first.vendedor.apellido
  	
    bounding_box([54.mm, altura], :width => self.bounds.right) do
      text "#{nombre_vendedor} #{apellido_vendedor}",size:7
    end

   	move_down 2.mm
   	altura = cursor

   	bounding_box([41.mm, altura], :width => self.bounds.right) do
    	text "#{transferencia.created_at.strftime("%d/%m/%Y")}",size:7
    end

    move_down 14.mm
    altura = cursor
    pos_codigo = 21.mm
    pos_descripcion = 38.mm
    total = 0
    pos_precio_venta = 85.mm

	   transferencia.detalles.map do |detalle|
	      altura = cursor
        bounding_box([pos_codigo, altura], :width => 15.mm ,:height=> 3.mm) do
          text "#{detalle.producto.codigo_barra}", size:6
        end
        temp_detalle_cantidad = "#{detalle.cantidad} #{detalle.producto.descripcion}"
        if(temp_detalle_cantidad.length > 40) #se acorta la cadena porque no entra en campo detalles
            loop do
              temp_detalle_cantidad = temp_detalle_cantidad.chop
              break if (temp_detalle_cantidad.length == 40)
            end
            temp_detalle_cantidad = temp_detalle_cantidad + "..."
        end
        bounding_box([pos_descripcion, altura], :width => 45.mm, :height=> 3.mm) do
          text "#{temp_detalle_cantidad}", size:6
        end
        bounding_box([pos_precio_venta, altura], :width => 19.mm, :height=> 3.mm) do
          text "#{to_Gs(detalle.producto.precio_promedio * 1.5 * detalle.cantidad)}", size:6
        end

        move_down 2.mm
        total = total + detalle.producto.precio * detalle.cantidad
      end

    	y_total = 267.mm - (offset * 165.mm)#la posicion de la línea de subtotales respecto a la vertical (se cuenta desde abajo hacia arriba)

      bounding_box([150.mm, y_total], :width => self.bounds.right) do
        text "#{to_Gs(total)}", size:7
      end
      bounding_box([23.mm, y_total - 4.mm], :width => self.bounds.right) do
        text "#{numero_a_palabras(total)}", size:6
      end


      nombre_vendedor = (Sucursal.where("deposito_id = ?", transferencia.origen_id)).first.vendedor.nombre
      apellido_vendedor = (Sucursal.where("deposito_id = ?", transferencia.origen_id)).first.vendedor.apellido
      
      bounding_box([47.mm, y_total - 20.mm], :width => self.bounds.right) do
         text "#{nombre_vendedor} #{apellido_vendedor}",size:7
       end

  
      bounding_box([53.mm, y_total - 38.mm], :width => self.bounds.right) do
        text "#{to_Gs(total)}", size:7
      end
      bounding_box([112.mm, y_total - 38.mm], :width => self.bounds.right) do
        text "#{numero_a_palabras(total)}", size:7
      end


      

	end

	def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
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

end


