# encoding: utf-8
class ExtractoClienteReportPdf < Prawn::Document
  #Se deben recibir ventas ordenadas por fecha
  def initialize(ventas, moneda_destino_id)
    super()
    @color_texto = '3E4D4A'
    @monto_total = 0
    @saldo = 0

    @ventas = ventas
    @cuentas = []
    moneda_id = moneda_destino_id.to_i
    @moneda = Moneda.find(moneda_id)
    @redondeo = @moneda.redondeo
    @nombre_cliente = @ventas[0].cliente.razon_social
    puts "[REPORTE][EXTRACTO CLIENTES]: Creando movimientos para #{ventas.count} ventas"
    #Se crean los movimientos con saldos incoherentes
    @ventas.map do |venta|
      if venta.anulado == false
        cuotas_pagos = []
        detalles = []

        venta_aux = VentaAuxiliar.new
        venta_aux.created_at = venta.created_at
        venta_aux.fecha = venta.fecha_registro
        venta_aux.total = obtener_total_venta(venta, moneda_id)
        venta_aux.nro_factura = venta.nro_factura
        venta_aux.nro_contrato = venta.nro_contrato
        venta_aux.garante = venta.garante
        venta_aux.tipo = venta.credito ? "Crédito" : "Contado"
        venta_aux.estado = "PAGADA"
        venta_aux.cuota_vencida = false

        #Detalles de venta = Productos
        venta.venta_detalles.map do |det|
          detalle = VentaDetalleAuxiliar.new
          detalle.created_at = det.created_at
          detalle.concepto = det.producto.descripcion
          detalle.cantidad = det.cantidad
          detalle.precio_venta = det.precio
          detalle.descuento = det.descuento
          detalle.precio_final = det.cantidad * (det.precio - det.descuento)
          detalles << detalle
        end

        #Cuotas y Pagos
        venta.venta_cuotas.map do |c|
          puts "Venta #{venta.nro_factura} - Cuota #{c.nro_cuota} - #{c.pago_detalles.count}"
          pagos_detalles_temp = c.pago_detalles.by_pago_activo
          if not c.pago_detalles.nil? and pagos_detalles_temp.count > 0
            i = 0
            pagos_detalles_temp.map do |p|
                cuota = CuotaPago.new
                puts "Pago: #{p.id} - Cuota: #{p.venta_cuota.nro_cuota} + Monto: #{p.monto_cuota}"
                cuota.concepto = "Cuota nro. #{c.nro_cuota}"
                cuota.created_at = p.created_at
                cuota.fecha_vencimiento =  c.fecha_vencimiento
                cuota.fecha_pago =  p.pago.fecha_pago
                if (i==0)
                  cuota.monto = c.monto 
                else
                  cuota.monto = cuotas_pagos[-1].saldo
                end
                cuota.descuento = p.pago.descuento / pagos_detalles_temp.count
                if(!p.monto_cuota)
                  cuota.pago = 0
                else
                  cuota.pago = p.monto_cuota #+ p.monto_interes + p.monto_interes_moratorio + p.monto_interes_punitorio
                end
                if(!p.monto_interes.nil?)
                  cuota.pago += p.monto_interes
                end
                if(!p.monto_interes_moratorio.nil?)
                  cuota.pago += p.monto_interes_moratorio
                end
                if(!p.monto_interes_punitorio.nil?)
                  cuota.pago += p.monto_interes_punitorio
                end
                # cuota.pago += p.monto_interes.nil? ? 0 : p.monto_interes
                # cuota.pago += p.monto_interes_moratorio.nil? ? 0 : p.monto_interes_moratorio 
                # cuota.pago += p.monto_interes_punitorio.nil? ? 0 : p.monto_interes_punitorio
                cuota.pago -= cuota.descuento
                cuota.saldo = cuota.monto - cuota.descuento - cuota.pago
                if !venta_aux.cuota_vencida
                  if cuota.fecha_vencimiento < Date.today
                    puts "Cuota Vencida!!!!"
                    venta_aux.cuota_vencida = true
                  end
                end
                cuotas_pagos << cuota
                i += 1
            end
          else
            cuota = CuotaPago.new
            puts "Cuota #{c.nro_cuota} sin pagos"
            cuota.concepto = "Cuota nro. #{c.nro_cuota}"
            cuota.created_at = c.fecha_vencimiento
            cuota.fecha_vencimiento = c.fecha_vencimiento
            cuota.fecha_pago = nil
            cuota.monto =  c.monto
            cuota.descuento = 0
            cuota.pago = 0
            cuota.saldo = cuota.monto
            puts "Esta vencida: #{cuota.fecha_vencimiento < Date.today}"
            if !venta_aux.cuota_vencida
              if cuota.fecha_vencimiento < Date.today
                puts "Cuota Vencida!!!!"
                venta_aux.cuota_vencida = true
              end
            end
            cuotas_pagos << cuota
          end
        end
        #Se agregan los atributos
        venta_aux.cuotas_pagos = cuotas_pagos
        venta_aux.productos = detalles
      end
        if venta_aux
          #puts "VENTA VENCIDA: #{venta_aux.cuota_vencida} VENTA PAGADA: #{venta.pagado}"
          venta_aux.estado = venta.pagado ? "Pagado" : "Pendiente"
          venta_aux.estado = venta_aux.cuota_vencida ? "Vencida" : "Pendiente"
          venta_aux.estado = venta.credito ? venta_aux.estado : "Pagada"
          venta_aux.saldo_pendiente = 0
          venta_aux.cuotas_pagos.each do |s|
          venta_aux.saldo_pendiente += s.saldo
        end
      end
      if venta_aux
        @cuentas << venta_aux
      end
    end

    puts "[REPORTE][EXTRACTO CLIENTES]: Ordenando por fecha"
    @cuentas.sort_by! {|u| u.created_at}

    #Ordenamiento de cosas
    @cuentas.map do |cuenta|
      cuenta.cuotas_pagos.sort_by! {|u| u.created_at}
    end
    puts "[REPORTE][EXTRACTO CLIENTES]: Generando Saldos"

    

    puts "[REPORTE][EXTRACTO CLIENTES]: Imprimiendo movimientos"


    @cuentas.each do |c|
      puts " ******************** ******************** ******************** "
      puts "Fecha: #{c.fecha}"
      puts "Factura: #{c.nro_factura}"
      puts "Nro. Contrato: #{c.nro_contrato}"
      puts "Saldo pendiente: #{fnumber(c.saldo_pendiente)}"
      puts "ESTADO: #{c.estado}"
      if c.garante
        puts "Garante: #{c.garante.razon_social}"
      end

      puts "Productos comprados:"
      puts "CANTIDAD \t CONCEPTO \t\t\t PRECIO VENTA \t DESCUENTO \t PRECIO FINAL"
      c.productos.each do |p|
        puts "#{p.cantidad} \t #{p.concepto} \t\t\t\t #{fnumber(p.precio_venta)} \t #{fnumber(p.descuento)} \t #{fnumber(p.precio_final)}"  
      end
      
      puts "Cuotas y Pagos:"
      puts "CONCEPTO \t VENCIMIENTO \t FECHA PAGO \t\t MONTO \t\t DESCUENTO \t\t PAGO \t\t SALDO"
      c.cuotas_pagos.each do |p|
        puts "#{p.concepto} \t #{p.fecha_vencimiento} \t #{p.fecha_pago} \t\t #{fnumber(p.monto)} \t #{fnumber(p.descuento)} \t\t #{fnumber(p.pago)} \t\t #{fnumber(p.saldo)}"
      end
    end

    header
    #Se dibuja el reporte
    @cuentas.each do |c|
      @cuenta = c
      move_down(8.mm)
      old_y = cursor
      bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
        self.y = old_y
        dibujar_tabla(@cuenta)
      end
      move_down(4.mm)
      stroke_horizontal_rule
    end
    footer
  end
  #Clase auxiliar
  class CuotaPago
    attr_accessor :created_at
    attr_accessor :fecha_vencimiento
    attr_accessor :fecha_pago
    attr_accessor :concepto
    attr_accessor :monto
    attr_accessor :descuento
    attr_accessor :pago
    attr_accessor :saldo
  end
  
  #Clase auxiliar
  class VentaAuxiliar
    attr_accessor :created_at
    attr_accessor :fecha
    attr_accessor :nro_factura
    attr_accessor :nro_contrato
    attr_accessor :garante
    attr_accessor :tipo
    attr_accessor :estado
    attr_accessor :cuotas_pagos
    attr_accessor :productos
    attr_accessor :cuota_vencida
    attr_accessor :saldo_pendiente
    attr_accessor :total
  end

  #Clase auxiliar
  class VentaDetalleAuxiliar
    attr_accessor :created_at
    attr_accessor :fecha
    attr_accessor :concepto
    attr_accessor :cantidad
    attr_accessor :precio_venta
    attr_accessor :descuento
    attr_accessor :precio_final
  end  

  def obtener_total_venta(venta, moneda_id)
    puts "[REPORTE][EXTRACTO CLIENTES]: obteniendo total de venta #{venta.nro_factura} en #{Moneda.find(moneda_id).simbolo}"
    total = 0
    venta.venta_detalles.map do |detalle|
      subtotal = detalle.cantidad * detalle.precio - detalle.descuento #monto en detalle.moneda_id
      puts "[REPORTE][EXTRACTO CLIENTES]: SubTotal = #{subtotal} #{detalle.moneda.simbolo}"
      puts "[REPORTE][EXTRACTO CLIENTES]: moneda_id = #{moneda_id} / detalle.moneda_id = #{detalle.moneda_id}"
      if moneda_id === detalle.moneda_id #Si el detalle ya está en la moneda que queremos
        total += subtotal
      else
        if moneda_id == venta.moneda_id #Se puede utilizar la cotización que está guardada en detalle.cotización
          puts "[REPORTE][EXTRACTO CLIENTES]: Cotizando #{subtotal} - det.moneda: #{detalle.moneda_id} - destino: #{moneda_id} - #{detalle.monto_cotizacion}"
          total += cotizar_monto(subtotal, detalle.moneda_id, moneda_id, detalle.monto_cotizacion)
        else
          #La cotización guardada no sirve. El precio guardado no está en lo que queremos. 
          #Se utiliza la cotización actual de detalle.moneda_id a moneda_id
          puts "[REPORTE][EXTRACTO CLIENTES]: Cotizando #{subtotal} - det.moneda: #{detalle.moneda_id} - destino: #{moneda_id} - sin_cotizacion"
          total += cotizar_monto(subtotal, detalle.moneda_id, moneda_id, nil)
        end                      
      end
    end
    puts "[REPORTE][EXTRACTO CLIENTES] << TOTAL >> #{total}"
    return total
  end

  def header
    stroke_horizontal_rule
    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){           
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Extracto de Cliente: #{@nombre_cliente}", :align => :center
        text "Moneda: #{@moneda.nombre}", :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center     
      } 
    end
    stroke_horizontal_rule

  end
	
  def dibujar_tabla(cuenta)
    ancho = self.bounds.right
    time = cuenta.fecha.strftime("%d/%m/%Y")
    text "<b>Fecha:</b> #{time}", size: 10, :inline_format => true
    text "<b>Factura:</b> #{cuenta.nro_factura}", size: 10, :inline_format => true
    if cuenta.tipo != 'Contado'
      text "<b>Nro. Contrato:</b> #{cuenta.nro_contrato}", size: 10, :inline_format => true
      if cuenta.garante
        text "<b>Garante: </b> #{cuenta.garante.razon_social}", size: 10, :inline_format => true
      end
    end
    text "<b>Estado: </b>#{cuenta.estado}", size: 10, :inline_format => true
    if cuenta.estado!='Pagada'
      text "<b>Saldo Pendiente:</b> #{fnumber(cuenta.saldo_pendiente)}", size: 10, :inline_format => true
    end

    text "<b>Lista de productos:</b>", size: 10, style: :bold, :align => :left, :inline_format => true
    move_down(4.mm)
    table dibujar_productos(cuenta.productos), :cell_style => { :size => 7, :padding => 2 } do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [85.0, 200.0,  85.0,  85.0,  85.0]
    end

    if cuenta.tipo != 'Contado'
      move_down(4.mm)
      text "<b>Lista de pagos:</b>", size: 10, style: :bold, :align => :left, :inline_format => true
      move_down(4.mm)
      table dibujar_pagos(cuenta.cuotas_pagos), :cell_style => { :size => 7, :padding => 2 } do
        row(0).font_style = :bold
        row(0).text_color = '3E4D4A'
        self.header = true
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [(ancho / 7.0), (ancho / 7.0),  (ancho / 7.0),  (ancho / 7.0),  (ancho / 7.0),  (ancho / 7.0),  (ancho / 7.0)]
      end
    end

  end

  def dibujar_productos(productos)
    [['Cantidad', 'Descripcion', 'Precio Venta', 'Descuento', 'Subtotal']] +
    productos.map do |producto|
      [fnumber(producto.cantidad), producto.concepto, fnumber(producto.precio_venta), fnumber(producto.descuento), fnumber(producto.precio_final)]
    end  
  end

  def dibujar_pagos(pagos)
    [['Concepto', 'Vencimiento', 'Fecha Pago', 'Monto Cuota', 'Descuento', 'Pago', 'Saldo']] +
    pagos.map do |pago|
      [ pago.concepto, 
        pago.fecha_vencimiento.strftime("%d/%m/%Y"),
        pago.fecha_pago.nil? ? "" : pago.fecha_pago.strftime("%d/%m/%Y"), 
        fnumber(pago.monto), 
        fnumber(pago.descuento), 
        fnumber(pago.pago), 
        fnumber(pago.saldo)]
    end  
  end
    
  def footer
    page_count.times do |i|
      go_to_page(i+1)
      bounding_box([bounds.right-50, bounds.bottom + 25], :width => 50) {text "#{i+1} / #{page_count}"}
    end
  end
  def fnumber(int)
    if @redondeo
      return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
    else
     return ActionController::Base.helpers.number_to_currency(int, precision: 2, unit: "",  separator: ".", delimiter: ",")
    end 
  end
end
