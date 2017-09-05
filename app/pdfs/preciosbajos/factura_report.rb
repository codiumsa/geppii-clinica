# encoding: utf-8
require "prawn/measurement_extensions"

class FacturaReportPdf < Prawn::Document
  def initialize(venta)
    
    super(:page_size => "LEGAL", :bottom_margin => 0, :left_margin =>0)
    @color_texto = '3E4D4A'
    venta = Venta.unscoped.find(venta.id)

    if(venta.moneda.simbolo == 'Gs.')
      @moneda = 'guaranies'
    elsif(venta.moneda.simbolo == 'US$')
      @moneda = 'dolares'
    end

    dibujar_venta(venta, 0.mm)
    move_cursor_to(self.bounds.top)
    
    dibujar_venta(venta, 110.mm)
    move_cursor_to(self.bounds.top)
    
    dibujar_venta(venta, 220.mm)
    move_cursor_to(self.bounds.top)
  end
 
    
  def dibujar_venta (venta, offset)

    if venta.moneda.redondeo
      decimales = 0
    else
      decimales = 2
    end

    move_down 19.mm
    altura = cursor - offset
    bounding_box([160.mm, altura], :width => self.bounds.right) do
      text "#{venta.nro_factura}", size:6
    end

    move_down 4.mm
    altura = cursor
    bounding_box([35.mm, altura], :width => self.bounds.right) do
      text "#{(venta.fecha_registro + 32400).strftime("%d/%m/%Y")}", size:6#32400 segundos = 4hs, la hora en la BD esta en UTC
      #text "#{venta.fecha_registro.strftime("%d/%m/%Y")}", size:6
    end
    if venta.credito.eql? false
      bounding_box([126.mm, altura], :width => self.bounds.right) do
        text "X", size:6
      end
    else
      bounding_box([144.mm, altura], :width => self.bounds.right) do
        text "X", size:6
      end
    end
    move_down 1.mm
    altura = cursor
    bounding_box([45.mm, altura], :width => self.bounds.right) do
      if venta.nombre_cliente
        text "#{venta.nombre_cliente}", size:6
      else
        text "#{venta.cliente.razon_social}", size:6
      end
    end

    if venta.nombre_cliente or venta.cliente.telefono.nil? or venta.cliente.telefono.empty?
        telefono = "-"
    else
        telefono = venta.cliente.telefono
    end
    bounding_box([160.mm, altura], :width => self.bounds.right) do
      text "#{telefono}", size:6
    end

    move_down 3.mm
    altura = cursor
    bounding_box([25.mm, altura], :width => self.bounds.right) do
      if venta.nombre_cliente
          text "#{venta.ruc_cliente}", size:6
      else
          text "#{venta.cliente.ruc}", size:6
      end
    end
    if venta.nombre_cliente or venta.cliente.direccion.nil? or venta.cliente.direccion.empty?
        direccion = "-"
    else
        direccion = venta.cliente.direccion
    end
    bounding_box([85.mm, altura], :width => self.bounds.right) do
      text "#{direccion}", size:6
    end

    subtotal_exentas = 0
    subtotal_iva5 = 0
    subtotal_iva10 = 0

    move_down 10.mm
    altura = cursor

    #pos_descuento = 375
    pos_exentas = 152.mm #la posicion de la columna de exentas en el eje horizontal
    pos_iva5 = 170.mm
    pos_iva10 = 190.mm

    venta.venta_detalles.map do |detalle|
      bounding_box([13.mm, altura], :width => self.bounds.right) do
        text "#{Integer(detalle.cantidad)}", size:6
      end
      descripcion = detalle.producto.descripcion
      if venta.credito.eql? true
        cuotas = VentaCuota.by_venta(venta.id)
        fechaVencimiento = cuotas.last.fecha_vencimiento.strftime("%d/%m/%Y")
        descripcion = descripcion + " [Última cuota: #{fechaVencimiento}]"
      end

      bounding_box([25.mm, altura], :width => self.bounds.right) do
        text "#{descripcion}", size:6
      end
      bounding_box([135.mm, altura], :width => 10.mm) do
        text "#{to_Gs(detalle.precio - (detalle.descuento / detalle.cantidad))}", size:5, :align => :right
        #se incluye el descuento en el precio porque TOP no tiene un campo aparte en su factura
      end
      # bounding_box([pos_descuento, altura], :width => self.bounds.right) do
      #   text "#{Integer(detalle.precio - (detalle.descuento / detalle.cantidad))}", size:6
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
      bounding_box([posicion_horizontal, altura], :width => 11.mm) do
        subtotal = detalle.precio * detalle.cantidad - detalle.descuento
        text "#{to_Money(subtotal)}", size:5, :align => :right
      end
      if !detalle.imei.nil? and !detalle.imei.empty?
        bounding_box([20.mm, cursor], :width => self.bounds.right) do
          text "imei: #{detalle.imei}", size:6
        end   
      end 
      
      altura = cursor
      move_down 2
    end

    #ACA SE AGREGA EL DESCUENTO GENERAL
    
    subtotal_exentas = subtotal_exentas - venta.descuento_redondeo
    if not venta.descuento_redondeo.nil? and not venta.descuento_redondeo.eql? 0.0
      bounding_box([13.mm, altura], :width => self.bounds.right) do
        text "#{Integer(1)}", size:6 #cantidad
      end
      bounding_box([20.mm, altura], :width => self.bounds.right) do
        text "Descuento General", size:6 #descripcion
      end
      bounding_box([64.mm, altura], :width => 9.mm) do
        text "#{to_Money(-venta.descuento_redondeo)}", size:5, :align => :right #precio unitario
      end
      bounding_box([pos_exentas, altura], :width => 10.mm) do
        text "#{to_Money(-venta.descuento_redondeo)}", size:5, :align => :right #subtotal
      end
    end

    y_subtotales = 268.mm - offset #la posicion de la línea de subtotales respecto a la vertical (se cuenta desde abajo hacia arriba)

    bounding_box([pos_exentas, y_subtotales], :width => 10.mm) do
      text "#{to_Money(subtotal_exentas)}", size:5, :align => :right
    end

    bounding_box([pos_iva5, y_subtotales], :width => 10.mm) do
      text "#{to_Money(subtotal_iva5)}", size:5, :align => :right
    end

    bounding_box([pos_iva10, y_subtotales], :width => 10.mm) do
      text "#{to_Money(subtotal_iva10)}", size:5, :align => :right
    end

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
    bounding_box([30.mm, y_subtotales - 6.mm], :width => self.bounds.right) do
      text "#{total_en_letras}", size:6
    end

    bounding_box([pos_iva10, y_subtotales - 6.mm], :width => 11.mm) do
      text "#{to_Money(total_a_pagar).to_s}", size:5, :align => :right
    end

    #liquidación IVA 5
    #subtotal_iva5-------105
    #x-------------------5
    #x = (subtotal_iva5 * 5) / 105
    #liq_iva5 = (subtotal_iva5 * 5) / 105


    #liquidación IVA 10
    #subtotal_iva10-------110
    #x-------------------10
    #x = (subtotal_iva10 * 10) / 110
    #liq_iva10 = (subtotal_iva10 * 10) / 110

    #total_iva = liq_iva5 + liq_iva10
    total_iva = venta.iva5 + venta.iva10
    y_liq_iva = y_subtotales - 10.mm
    bounding_box([45.mm, y_liq_iva], :width => 11.mm) do
      text "#{to_Money(venta.iva5)}", size:6, :align => :right
    end

    bounding_box([75.mm, y_liq_iva], :width => 11.mm) do
      text "#{to_Money(venta.iva10)}", size:6, :align => :right
    end

    bounding_box([120.mm, y_liq_iva], :width => 11.mm) do
      text "#{to_Money(total_iva)}", size:6, :align => :right
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
