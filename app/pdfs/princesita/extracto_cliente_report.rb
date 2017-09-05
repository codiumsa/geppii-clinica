# encoding: utf-8
class ExtractoClienteReportPdf < Prawn::Document
  #Se deben recibir ventas ordenadas por fecha
  def initialize(ventas, moneda_destino_id)
    super()
    @color_texto = '3E4D4A'
    @monto_total = 0
    @saldo = 0

    @ventas = ventas
    @movimientos = []
    moneda_id = moneda_destino_id.to_i
    @moneda = Moneda.find(moneda_id)
    @redondeo = @moneda.redondeo
    @nombre_cliente = @ventas[0].cliente.razon_social
    header
    puts "[REPORTE][EXTRACTO CLIENTES]: Creando movimientos para #{ventas.count} ventas"
    #Se crean los movimientos con saldos incoherentes
    @ventas.map do |venta|
      if venta.anulado == false
        movimiento_venta = Movimiento.new
        movimiento_venta.created_at = venta.created_at
        movimiento_venta.fecha = venta.fecha_registro
        movimiento_venta.concepto = "Venta Factura Nro. #{venta.nro_factura}"
        movimiento_venta.debe = obtener_total_venta(venta, moneda_id)
        movimiento_venta.haber = 0
        movimiento_venta.saldo = 0
        @movimientos << movimiento_venta

        venta.pagos.map do |pago|
          movimiento_pago = Movimiento.new
          movimiento_pago.created_at = pago.created_at
          movimiento_pago.fecha = pago.fecha_pago
          cuotas = []
          pago.pago_detalles.map do |detalle|
            cuotas << detalle.venta_cuota.nro_cuota
          end
          movimiento_pago.concepto = "Pago Cuota/s #{cuotas.join(",")} - Factura Nro. #{venta.nro_factura}"
          movimiento_pago.debe = 0
          movimiento_pago.haber = obtener_total_pago(venta, pago, moneda_id)
          movimiento_pago.saldo = 0
          @movimientos << movimiento_pago
        end
      end
    end
    #Se ordenan los movimientos
    puts "[REPORTE][EXTRACTO CLIENTES]: Ordenando por fecha"
    @movimientos.sort_by! {|u| u.created_at}

    #Se agrega el saldo
    @saldo = 0
    @movimientos.each do |mov|

      @saldo = @saldo - mov.haber + mov.debe
      mov.saldo = @saldo
    end


    puts "[REPORTE][EXTRACTO CLIENTES]: Imprimiendo movimientos"
    puts "FECHA \t CONCEPTO \t DEBE \t HABER \t SALDO"
    @movimientos.each do |mov|
      puts "#{mov.created_at} \t #{mov.concepto} \t #{fnumber(mov.debe)} \t #{fnumber(mov.haber)} \t #{fnumber(mov.saldo)}"
    end

    #Se dibuja el reporte
    dibujar_tabla(@movimientos)
    footer
  end
  #Clase auxiliar
  class Movimiento
    attr_accessor :created_at
    attr_accessor :fecha
    attr_accessor :concepto
    attr_accessor :debe
    attr_accessor :haber
    attr_accessor :saldo    
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

  def obtener_total_pago(venta, pago, moneda_id)
    total_origen = pago.total - pago.descuento
    total = 0
    if (moneda_id == pago.moneda_id) #Si el detalle ya está en la moneda que queremos
      total += total_origen
    else
      if moneda_id == venta.moneda_id #Se puede utilizar la cotización que está guardada en detalle.cotización
        #Cuando se realizó el pago se paso de venta.moneda_id a pago.moneda_id con una cotización de pago.monto_cotización
        total += total_origen
      else
        #La cotización guardada no sirve. El precio guardado no está en lo que queremos.
        #Se utiliza la cotización actual de detalle.moneda_id a moneda_id
        #pago.monto_cotizacion
        #origen: pago.moneda_id , destino: venta.moneda_id
        total += cotizar_monto(total_origen, venta.moneda_id, moneda_id, nil)
      end                      
    end
    puts "[REPORTE][EXTRACTO CLIENTES] << TOTAL >> #{total}"
    return total
  end

  def cotizar_monto(monto, moneda_origen_id, moneda_destino_id, monto_cotizacion)
    puts "[REPORTE][EXTRACTO CLIENTES].cotizar_monto: cotizando ... cotizacion: #{monto_cotizacion}"
    cotizacion = Cotizacion.get_cotizacion(moneda_origen_id, moneda_destino_id)
    if cotizacion.nil?
      cotizacion = Cotizacion.get_cotizacion(moneda_destino_id, moneda_origen_id)
    end

    if cotizacion.nil?
      puts " ------------- LA COTIZACION NO EXISTE ----------------"
    end

    monto_cotizacion = monto_cotizacion.nil? ? cotizacion.monto : monto_cotizacion
    puts "[REPORTE][EXTRACTO CLIENTES] Monto cotizacion = #{monto_cotizacion}, "
    
    #Verificar cual es el origen de la cotizacion
    if cotizacion.moneda_id == moneda_origen_id
      return monto * monto_cotizacion
    else
      return monto / monto_cotizacion
    end
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
	
  def dibujar_tabla(movimientos)
    ancho = self.bounds.right
    table dibujar_movimientos(movimientos), :cell_style => { :size => 5, :padding => 2 } do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho / 5.0), (ancho / 5.0),  (ancho / 5.0),  (ancho / 5.0),  (ancho / 5.0)]
    end
  end

  def dibujar_movimientos(movimientos)
    [['Fecha', 'Concepto', 'Debe', 'Haber', 'Saldo']] +
    movimientos.map do |movimiento|
      [movimiento.fecha.strftime("%d/%m/%Y"), movimiento.concepto, fnumber(movimiento.debe).to_s, fnumber(movimiento.haber).to_s, fnumber(movimiento.saldo).to_s]
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
