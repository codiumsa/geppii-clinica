# encoding: utf-8
class VentaCuotasReportPdf < Prawn::Document
  def initialize(cuotas)
    super()
    font_size 9

    @color_texto = '3E4D4A'
    @monto_total = 0
    @cantidad_acreedores = 0

    @cuotas = cuotas
    header(cuotas)

		analizados = []
    
    @cuotas.map do |cuota|
			if not analizados.include? cuota.venta_id
				analizados.push(cuota.venta_id)
				seleccionados = []
				@cuotas.map do |c|
					if c.venta_id == cuota.venta_id
						seleccionados.push(c)
					end
				end
				dibujar_venta seleccionados[0].venta
				dibujar_tabla seleccionados
			end
      @monto_total = @monto_total + cuota.monto
    	@cantidad_acreedores = 1
    end

    
    #dibujar_tabla cuotas
    sumarizado
    footer  
  end
 
  def header(cuotas)
    titulo = 'Reporte de Cuentas por Cobrar'
      if !cuotas.empty?
      if cuotas[0].venta.anulado
        titulo = 'Reporte de Cuentas por Cobrar Anuladas'
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
      formatted_text [ { :text => "Cliente: ", :color => @color_texto }, { :text => "#{venta.cliente.nombre} #{venta.cliente.apellido}"}]
      formatted_text [ { :text => "RUC: ", :color => @color_texto }, { :text => "#{venta.cliente.ruc}"}]
      if venta.credito
        cuotas = VentaCuota.by_venta(venta.id)
        primeraCuota = cuotas.first.fecha_vencimiento.strftime("%d/%m/%Y")

        formatted_text [ { :text => "Tipo de venta: ", :color => @color_texto }, { :text => "Crédito"}]
        if (venta.tipo_credito)
          formatted_text [ { :text => "Tipo crédito: ", :color => @color_texto }, { :text =>"#{venta.tipo_credito.descripcion}"}]
        end
        formatted_text [ { :text => "Deuda: ", :color => @color_texto }, { :text => "#{venta.deuda}"}]
      else
        formatted_text [ { :text => "Tipo de venta: ", :color => @color_texto }, { :text => "Contado"}]
      end
    end

          
  end

  def dibujar_tabla(cuotas)
    #move_down 30
    #if cursor <80
    #  start_new_page
    #end
    ancho = self.bounds.right
    table dibujar_cuotas cuotas do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      (1..cuotas.length).each do |i|
        if Date.parse(row(i)[0,0].content) < Date.new
          row(i).text_color = 'FF0000'
        end
      end
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho / 4.0), (ancho / 4.0),  (ancho / 4.0)]
    end
  end

  def dibujar_cuotas(cuotas)
    [['Fecha de Vencimiento', 'Factura', 'Monto']] +
    cuotas.map do |cuota|
      [cuota.fecha_vencimiento, cuota.venta.nro_factura, cuota.monto]
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
      self.column_widths = [(ancho / 4.0), (ancho / 4.0)]
    end
  end
  
  def sumarizado_row
    [['Cantidad de Acreedores', 'Monto total']] +
      [[@cantidad_acreedores, @monto_total]]
  end
    
  def footer
    page_count.times do |i|
      go_to_page(i+1)
      bounding_box([bounds.right-50, bounds.bottom + 25], :width => 50) {text "#{i+1} / #{page_count}"}
    end
  end
end
