# encoding: utf-8
class VentasReportPdf < Prawn::Document
  def initialize(ventas,anulado)
    super()
    font_size 9

    @color_texto = '3E4D4A'
    @monto_total = 0
    @monto_iva_5 = 0
    @monto_iva_10 = 0
    @monto_por_cobrar = 0

    @ventas = ventas
    anulado = to_boolean(anulado)
    header(ventas,anulado)
    @ventas.map do |venta|
      @monto_total = @monto_total + venta.total
      @monto_iva_5 = @monto_iva_5 + venta.iva5
      @monto_iva_10 = @monto_iva_10 + venta.iva10
      @monto_por_cobrar = @monto_por_cobrar + venta.deuda
      dibujar_venta venta
    end

    sumarizado
    footer

  end

  def header(ventas,anulado)
    titulo = 'Reporte de Ventas'
    if ventas
      if anulado
        titulo = 'Reporte de Ventas Anuladas'
      end
    end

    stroke_horizontal_rule

    bounding_box([0,cursor], :width => self.bounds.right) do

      pad(20){
        text "Geppii", size: 15, style: :bold, :align => :center
        text "#{titulo}", :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center
      }
    end
    stroke_horizontal_rule

  end


  def dibujar_venta (venta)
    move_down 30
    if cursor <80
      start_new_page
    end

    altura = cursor

    #Se ubica esta columna primero ya que va a ser mas corta que la segunda columna
    #Como el cursor debe quedar en el punto mas bajo para poder seguir insertando bien los elementos,
    #la columna que va mas hasta abajo debe ser la ultima en insertarse para poder garantizar que el
    #cursor quede en buena posicion
    bounding_box([(self.bounds.right / 3.0) + 80, altura], :width => self.bounds.right / 3.0) do
      formatted_text [ { :text => "Fecha de registro: ", :color => @color_texto }, { :text => "#{venta.fecha_registro.strftime("%d/%m/%Y")}"}]
      formatted_text [ { :text => "IVA 5%: ", :color => @color_texto }, { :text => "#{venta.iva5}"}]
      formatted_text [ { :text => "IVA 10%: ", :color => @color_texto }, { :text => "#{venta.iva10}"}]
      formatted_text [ { :text => "Descuento: ", :color => @color_texto }, { :text => "#{venta.descuento}"}]
      formatted_text [ { :text => "Total: ", :color => @color_texto }, { :text => "#{venta.total}"}]
      formatted_text [ { :text => "Concepto: ", :color => @color_texto }, { :text => "#{venta.concepto_by_tipo}"}]
      if(not venta.vendedor.nil?)
        formatted_text [ { :text => "Vendedor: ", :color => @color_texto }, { :text => "#{venta.vendedor.nombre} #{venta.vendedor.apellido}"}]
      end

      if venta.credito
        cuotas = VentaCuota.by_venta(venta.id)
        primeraCuota = cuotas.first.fecha_vencimiento.strftime("%d/%m/%Y")

        formatted_text [ { :text => "Cantidad de cuotas: ", :color => @color_texto }, { :text => "#{venta.cantidad_cuotas}"}]
        formatted_text [ { :text => "Fecha primera cuota: ", :color => @color_texto }, { :text => "#{primeraCuota}"}]
      end
    end

    bounding_box([0, altura], :width => (self.bounds.right / 2.0)) do
      formatted_text [ { :text => "Factura: ", :color => @color_texto }, { :text => "#{venta.nro_factura}"}]
			formatted_text [ { :text => "Empresa: ", :color => @color_texto }, { :text => "#{venta.sucursal.empresa.nombre}"}]
      formatted_text [ { :text => "Sucursal: ", :color => @color_texto }, { :text => "#{venta.sucursal.descripcion}"}]
      formatted_text [ { :text => "Persona: ", :color => @color_texto }, { :text => "#{venta.persona.nombre} #{venta.persona.apellido}"}]
      formatted_text [ { :text => "RUC: ", :color => @color_texto }, { :text => "#{if !venta.persona.ci_ruc.nil? then venta.persona.ci_ruc end}"}]
      formatted_text [ { :text => "Tipo De Salida: ", :color => @color_texto }, { :text => "#{venta.tipo_salida.descripcion}"}]

      if venta.credito
        cuotas = VentaCuota.by_venta(venta.id)
        primeraCuota = cuotas.first.fecha_vencimiento.strftime("%d/%m/%Y")

        formatted_text [ { :text => "Forma de pago: ", :color => @color_texto }, { :text => "Crédito"}]
        if (venta.tipo_credito)
          formatted_text [ { :text => "Tipo crédito: ", :color => @color_texto }, { :text =>"#{venta.tipo_credito.descripcion}"}]
        end
        formatted_text [ { :text => "Deuda: ", :color => @color_texto }, { :text => "#{venta.deuda}"}]
      else
        formatted_text [ { :text => "Forma de pago: ", :color => @color_texto }, { :text => "Contado"}]
      end
    end



    dibujar_detalles venta

  end

  def dibujar_detalles(venta)
    ancho = self.bounds.right
    puts @color_texto
    table detalles_rows venta do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho / 2.5), (ancho / 8.0), (ancho / 6.0),  (ancho / 6.0)]
    end
  end

  def detalles_rows(venta)
    [['Producto', 'Cantidad', 'Promoción', 'Precio']] +
      venta.venta_detalles.map do |detalle|
        nombrePromocion = ''
        if(detalle.promocion)
            nombrePromocion = detalle.promocion.descripcion
        end
        [detalle.producto.descripcion, detalle.cantidad, nombrePromocion, detalle.precio]
      end
  end

  def sumarizado
    move_down 30
    if cursor <80
      start_new_page
    end
    formatted_text [ { :text => "Datos sumarizados", :color => @color_texto }]
    ancho = self.bounds.right
    puts @color_texto
    table sumarizado_row do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho / 2.5), (ancho / 8.0), (ancho / 6.0),  (ancho / 6.0)]
    end
  end

  def sumarizado_row
    [['IVA 5%', 'IVA 10%', 'Monto por cobrar', 'Monto total']] +
      [[@monto_iva_5, @monto_iva_10, @monto_por_cobrar, @monto_total]]
  end
  def to_boolean(str)
    str == 'true'
  end

  def footer
    page_count.times do |i|
      go_to_page(i+1)
      bounding_box([bounds.right-50, bounds.bottom + 25], :width => 50) {text "#{i+1} / #{page_count}"}
    end
  end
end
