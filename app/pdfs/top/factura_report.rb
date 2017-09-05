# encoding: utf-8
require "prawn/measurement_extensions"

class FacturaReportPdf < Prawn::Document
  def initialize(venta)
    super(:page_size => "LEGAL", :page_layout => :landscape, :bottom_margin => 0, :left_margin =>0)

    @color_texto = '3E4D4A'
    venta = Venta.unscoped.find(venta.id)

    dibujar_venta(venta, 0)
    move_cursor_to(self.bounds.top)

    dibujar_venta(venta, 120.mm)
    move_cursor_to(self.bounds.top)

    dibujar_venta(venta, 240.mm)
    move_cursor_to(self.bounds.top)

   #  @ventas = ventas

   #  @ventas.map do |venta|
			# venta = Venta.unscoped.find(venta.id)
   #    dibujar_venta(venta, 0)
   #    move_cursor_to(self.bounds.top)

   #    dibujar_venta(venta, 118.mm)
   #    move_cursor_to(self.bounds.top)

   #    dibujar_venta(venta, 236.mm)
   #    move_cursor_to(self.bounds.top)
   #  end
  end


  def dibujar_venta (venta, offset)
    move_down 15.mm
    bounding_box([90.mm + offset, cursor], :width => self.bounds.right) do
      text "#{venta.nro_factura}", size:6
    end

    move_down 3.mm
    altura = cursor
    bounding_box([23.mm + offset, altura], :width => self.bounds.right) do
      text "#{(venta.fecha_registro - 32400).strftime("%d/%m/%Y")}", size:6#32400 segundos = 4hs, la hora en la BD esta en UTC
      #text "#{venta.fecha_registro.strftime("%d/%m/%Y")}", size:6
    end
    if venta.credito.eql? false
      bounding_box([85.mm + offset, altura], :width => self.bounds.right) do
        text "X", size:6
      end
    else
      bounding_box([107.mm + offset, altura], :width => self.bounds.right) do
        text "X", size:6
      end
    end
    move_down 3.mm
    altura = cursor
    bounding_box([26.mm + offset, altura], :width => self.bounds.right) do
      if venta.nombre_cliente
        text "#{venta.nombre_cliente}", size:6
      else
        text "#{venta.cliente.razon_social}", size:6
      end
    end
    bounding_box([95.mm + offset, altura], :width => self.bounds.right) do
      if venta.nombre_cliente
          text "#{venta.ruc_cliente}", size:6
      else
          text "#{venta.cliente.ruc}", size:6
      end
    end
    move_down 1.mm
    if venta.nombre_cliente or venta.cliente.direccion.nil? or venta.cliente.direccion.empty?
	      direccion = "-"
    else
        direccion = venta.cliente.direccion
    end
    altura = cursor
    bounding_box([15.mm + offset, altura], :width => self.bounds.right) do
      text "#{direccion}", size:6
    end

    if venta.nombre_cliente or venta.cliente.telefono.nil? or venta.cliente.telefono.empty?
        telefono = "-"
    else
	      telefono = venta.cliente.telefono
    end
    bounding_box([95.mm + offset, altura], :width => self.bounds.right) do
      text "#{telefono}", size:6
    end

    if !venta.vendedor.nil?
      nombre_vendedor = venta.vendedor.nombre + ' ' + venta.vendedor.apellido
    else
      nombre_vendedor = ""
    end

    move_down 2.mm
    altura = cursor
    bounding_box([100.mm + offset, altura], :width => self.bounds.right) do
      text "#{nombre_vendedor}", size:6
    end

    subtotal_exentas = 0
    subtotal_iva5 = 0
    subtotal_iva10 = 0

    move_down 50.mm
    altura = cursor

    #pos_descuento = 375
    pos_exentas = 71.mm + offset #la posicion de la columna de exentas en el eje horizontal
    pos_iva5 = 86.mm + offset
    pos_iva10 = 102.mm + offset

    venta.venta_detalles.map do |detalle|
      bounding_box([13.mm + offset, altura], :width => self.bounds.right) do
        text "#{Integer(detalle.cantidad)}", size:6
      end
      bounding_box([20.mm + offset, altura], :width => self.bounds.right) do
        text "#{detalle.producto.descripcion}", size:6
      end
      bounding_box([63.mm + offset, altura], :width => 9.mm) do
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
      bounding_box([posicion_horizontal, altura], :width => 10.mm) do
        subtotal = detalle.precio * detalle.cantidad - detalle.descuento
        text "#{to_Gs(subtotal)}", size:6, :align => :right
      end
      if !detalle.imei.nil? and !detalle.imei.empty?
        bounding_box([20.mm + offset, cursor], :width => self.bounds.right) do
          text "imei: #{detalle.imei}", size:6
        end
      end
      altura = cursor
      move_down 2
    end

    #ACA SE AGREGA EL DESCUENTO GENERAL

    subtotal_exentas = subtotal_exentas - venta.descuento_redondeo
    if not venta.descuento_redondeo.nil? and not venta.descuento_redondeo.eql? 0.0
      bounding_box([13.mm + offset, altura], :width => self.bounds.right) do
        text "#{Integer(1)}", size:6 #cantidad
      end
      bounding_box([20.mm + offset, altura], :width => self.bounds.right) do
        text "Descuento General", size:6 #descripcion
      end
      bounding_box([64.mm + offset, altura], :width => 9.mm) do
        text "#{to_Gs(-venta.descuento_redondeo)}", size:5, :align => :right #precio unitario
      end
      bounding_box([pos_exentas, altura], :width => 10.mm) do
        text "#{to_Gs(-venta.descuento_redondeo)}", size:6, :align => :right #subtotal
      end
    end

    y_subtotales = 70.mm#la posicion de la línea de subtotales respecto a la vertical (se cuenta desde abajo hacia arriba)

    bounding_box([pos_exentas, y_subtotales], :width => 10.mm) do
      text "#{to_Gs(subtotal_exentas)}", size:6, :align => :right
    end

    bounding_box([pos_iva5, y_subtotales], :width => 10.mm) do
      text "#{to_Gs(subtotal_iva5)}", size:6, :align => :right
    end

    bounding_box([pos_iva10, y_subtotales], :width => 10.mm) do
      text "#{to_Gs(subtotal_iva10)}", size:6, :align => :right
    end

    total_a_pagar = subtotal_exentas + subtotal_iva5 + subtotal_iva10
    numero_en_letras = numero_a_palabras(total_a_pagar).upcase
    bounding_box([20.mm + offset, y_subtotales - 5.mm], :width => self.bounds.right) do
      text "#{to_Gs(total_a_pagar).to_s + " (" + numero_en_letras + ")" }", size:6
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
    bounding_box([25.mm + offset, y_liq_iva], :width => 10.mm) do
      text "#{to_Gs(venta.iva5)}", size:6, :align => :right
    end

    bounding_box([50.mm + offset, y_liq_iva], :width => 10.mm) do
      text "#{to_Gs(venta.iva10)}", size:6, :align => :right
    end

    bounding_box([80.mm + offset, y_liq_iva], :width => 10.mm) do
      text "#{to_Gs(total_iva)}", size:6, :align => :right
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
