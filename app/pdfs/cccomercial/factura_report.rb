# encoding: utf-8
# encoding: utf-8
# encoding: utf-8
require "prawn/measurement_extensions"

class FacturaReportPdf < Prawn::Document
  def initialize(venta)
    
    super(:page_size => "LEGAL", :bottom_margin => 0, :left_margin =>0, :right_margin =>0, :top_margin =>0)

    @color_texto = '3E4D4A'
    venta = Venta.unscoped.find(venta.id)

    dibujar_venta(venta, 0)
    #move_cursor_to(self.bounds.top)
    
    dibujar_venta(venta, 1)
    #move_cursor_to(self.bounds.top)

  end
 
    
  def dibujar_venta (venta, offset)
    offset_legal = 25.4.mm

    move_down 28.mm
    altura = cursor - (offset * 12.mm)

    bounding_box([160.mm, altura], :width => self.bounds.right) do
      text "#{venta.nro_factura}", size:7
      #text "123456", size:6
    end
      
    move_down 5.mm
    altura = cursor
    bounding_box([40.mm, altura], :width => self.bounds.right) do
      text "#{venta.fecha_registro.strftime("%d/%m/%Y")}", size:7
    end
    if venta.credito.eql? false
      bounding_box([177.mm, altura], :width => self.bounds.right) do
        text "X", size:7
      end
    else
      bounding_box([198.mm, altura], :width => self.bounds.right) do
        text "X", size:7
      end
    end
    move_down 2.mm
    altura = cursor
    bounding_box([46.mm, altura], :width => self.bounds.right) do
      if venta.nombre_cliente
        text "#{venta.nombre_cliente}", size:7
      else
        text "#{venta.cliente.razon_social}", size:7
      end
    end
    # bounding_box([150.mm, altura], :width => self.bounds.right) do
    #   if venta.nombre_cliente
    #       text "#{venta.ruc_cliente}", size:7
    #   else
    #       text "#{venta.cliente.ruc}", size:7
    #   end
    # end
    move_down 2.mm
    if venta.nombre_cliente or venta.cliente.direccion.nil? or venta.cliente.direccion.empty?
        direccion = "-"
    else
        direccion = venta.cliente.direccion
    end
    altura = cursor
    bounding_box([31.mm, altura], :width => self.bounds.right) do
      text "#{direccion}", size:7
    end

    if venta.nombre_cliente or venta.cliente.telefono.nil? or venta.cliente.telefono.empty?
        telefono = "-"
    else
        telefono = venta.cliente.telefono
    end
    bounding_box([150.mm, altura], :width => self.bounds.right) do
      text "#{telefono}", size:7
    end
    move_down 3.mm

    # if !venta.vendedor.nil?
    #   nombre_vendedor = venta.vendedor.nombre + ' ' + venta.vendedor.apellido
    # else
    #   nombre_vendedor = "-"
    # end

    altura = cursor
    bounding_box([32.mm, altura], :width => self.bounds.right) do
      if venta.nombre_cliente
          text "#{venta.ruc_cliente}", size:7
      else
          text "#{venta.cliente.ruc}", size:7
      end
    end  

    subtotal_exentas = 0
    subtotal_iva5 = 0
    subtotal_iva10 = 0

    move_down 15.mm #tabla de detalles
    altura = cursor

    pos_exentas = 132.mm #la posicion de la columna de exentas en el eje horizontal
    pos_iva5 = 156.mm
    pos_iva10 = 183.mm

    pos_codigo = 14.mm
    pos_cantidad = 30.mm
    pos_descripcion = 46.mm
    pos_precio = 117.mm

    venta.venta_detalles.map do |detalle|
      bounding_box([pos_codigo, altura], :width => self.bounds.right) do
        text "#{detalle.producto.codigo_barra}", size:5 
      end      
      bounding_box([pos_cantidad, altura], :width => self.bounds.right) do
        text "#{to_Gs(Integer(detalle.cantidad))}", size:7
      end
      bounding_box([pos_descripcion, altura], :width => self.bounds.right) do
        text "#{detalle.producto.descripcion}", size:7
      end
      bounding_box([pos_precio, altura], :width => self.bounds.right) do
        text "#{to_Gs(Integer(detalle.precio - (detalle.descuento / detalle.cantidad)))}", size:7
        #se incluye el descuento en el precio porque TOP no tiene un campo aparte en su factura
      end
      # bounding_box([pos_descuento, altura], :width => self.bounds.right) do
      #   text "#{Integer(detalle.precio - (detalle.descuento / detalle.cantidad))}", size:7
      # end

      if detalle.producto.iva.eql? 0.0
        subtotal_exentas += detalle.precio * detalle.cantidad - detalle.descuento
        posicion_horizontal = pos_exentas
      end
      if detalle.producto.iva.eql? 5.0
        subtotal_iva5 += detalle.precio * detalle.cantidad - detalle.descuento
        posicion_horizontal = pos_iva5
      end
      if detalle.producto.iva.eql? 10.0
        subtotal_iva10 += detalle.precio * detalle.cantidad - detalle.descuento
        posicion_horizontal = pos_iva10
      end
      bounding_box([posicion_horizontal, altura], :width => self.bounds.right) do
        subtotal = detalle.precio * detalle.cantidad - detalle.descuento
        text "#{to_Gs(Integer(subtotal))}", size:7
      end
      # if !detalle.imei.nil? and !detalle.imei.empty?
      #   bounding_box([20.mm, altura], :width => self.bounds.right) do
      #     text "imei: #{detalle.imei}", size:7
      #   end   
      # end 
      altura = cursor
      move_down 2
    end

    #ACA SE AGREGA EL DESCUENTO GENERAL
    
    subtotal_exentas = subtotal_exentas - venta.descuento_redondeo
    # if not venta.descuento_redondeo.nil? and not venta.descuento_redondeo.eql? 0.0
    #   bounding_box([pos_cantidad, altura], :width => self.bounds.right) do
    #     text "1", size:7 #cantidad
    #   end
    #   bounding_box([pos_descripcion, altura], :width => self.bounds.right) do
    #     text "Descuento General", size:7 #descripcion
    #   end
    #   bounding_box([pos_precio, altura], :width => self.bounds.right) do
    #     text "#{to_Gs(Integer(-venta.descuento_redondeo))}", size:7 #precio
    #   end
    #   bounding_box([pos_exentas, altura], :width => self.bounds.right) do
    #     text "#{to_Gs(Integer(-venta.descuento_redondeo))}", size:7 #subtotal
    #   end
    # end


    # y_subtotales = 196.mm - (offset * 165.mm)#la posicion de la línea de subtotales respecto a la vertical (se cuenta desde abajo hacia arriba)
    y_subtotales = 200.mm + offset_legal - (offset * 162.mm)#la posicion de la línea de subtotales respecto a la vertical (se cuenta desde abajo hacia arriba)

    y_down_totales = 6.mm

    bounding_box([pos_exentas, y_subtotales], :width => self.bounds.right) do
      text "#{to_Gs(Integer(subtotal_exentas))}", size:7
    end

    bounding_box([pos_iva5, y_subtotales], :width => self.bounds.right) do
      text "#{to_Gs(Integer(subtotal_iva5))}", size:7
    end

    bounding_box([pos_iva10, y_subtotales], :width => self.bounds.right) do
      text "#{to_Gs(Integer(subtotal_iva10))}", size:7
    end

    ######################################################################

    bounding_box([48.mm, y_subtotales - y_down_totales], :width => self.bounds.right) do
        text "#{to_Gs(Integer(-venta.descuento_redondeo))}", size:7 #descuento redondeo
      end

    total_a_pagar = subtotal_exentas + subtotal_iva5 + subtotal_iva10
    numero_en_letras = numero_a_palabras(total_a_pagar).upcase
    bounding_box([40.mm, y_subtotales - (y_down_totales*2)], :width => self.bounds.right) do
      text "#{to_Gs(Integer(total_a_pagar)).to_s + " (" + numero_en_letras + ")" }", size:7
    end

    pos_total_iva5 = 65.mm
    pos_total_iva10 = 110.mm
    pos_total_iva = 164.mm
    
    total_iva = venta.iva5 + venta.iva10
    y_liq_iva = y_subtotales - (y_down_totales * 3) - 0.5.mm
    bounding_box([pos_total_iva5, y_liq_iva], :width => self.bounds.right) do
      text "#{to_Gs(Integer(venta.iva5))}", size:7
    end

    bounding_box([pos_total_iva10, y_liq_iva], :width => self.bounds.right) do
      text "#{to_Gs(Integer(venta.iva10))}", size:7
    end

    bounding_box([pos_total_iva, y_liq_iva], :width => self.bounds.right) do
      text "#{to_Gs(Integer(total_iva))}", size:7
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


  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end
  
end
