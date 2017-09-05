# encoding: utf-8
class CompraCuotasReportPdf < Prawn::Document
  def initialize(cuotas)
    super()
    @color_texto = '3E4D4A'
    @monto_total = 0
    @cantidad_acreedores = 0

    @cuotas = cuotas
    header
		analizados = []
    @cuotas.map do |cuota|
			if not analizados.include? cuota.compra_id
				analizados.push(cuota.compra_id)
				seleccionados = []
				@cuotas.map do |c|
					if c.compra_id == cuota.compra_id
						seleccionados.push(c)
					end
				end
				dibujar_compra seleccionados[0].compra
				dibujar_tabla seleccionados
			end
      @monto_total = @monto_total + cuota.monto
    	@cantidad_acreedores = 1
    end
    
    #dibujar_tabla cuotas
    sumarizado
    footer  
  end
 
  def header
    stroke_horizontal_rule

    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){           
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte de Cuentas por Pagar", :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center     
      } 
    end
    stroke_horizontal_rule

  end
	
	def dibujar_compra (compra)
    move_down 30
    if cursor <80
      start_new_page
    end

    altura = cursor
    
    #Se ubica esta columna primero ya que va a ser mas corta que la segunda columna
    #Como el cursor debe quedar en el punto mas bajo para poder seguir insertando bien los elementos,
    #la columna que va mas hasta abajo debe ser la ultima en insertarse para poder garantizar que el
    #cursor quede en buena posicion
    bounding_box([(self.bounds.right / 3.0) + 20, altura], :width => self.bounds.right / 3.0) do
			 formatted_text [ { :text => "Deposito: ", :color => @color_texto }, { :text => "#{compra.deposito.nombre}"}]
      formatted_text [ { :text => "Fecha de registro: ", :color => @color_texto }, { :text => "#{compra.fecha_registro.strftime("%d/%m/%Y")}"}]
      formatted_text [ { :text => "IVA 5%: ", :color => @color_texto }, { :text => "#{compra.iva5}"}]
      formatted_text [ { :text => "IVA 10%: ", :color => @color_texto }, { :text => "#{compra.iva10}"}]
      formatted_text [ { :text => "Total: ", :color => @color_texto }, { :text => "#{compra.total}"}]
    end
    
    bounding_box([0, altura], :width => (self.bounds.right / 3.0)) do
      formatted_text [ { :text => "Factura: ", :color => @color_texto }, { :text => "#{compra.nro_factura}"}]
			formatted_text [ { :text => "Empresa: ", :color => @color_texto }, { :text => "#{compra.sucursal.empresa.nombre}"}]
      formatted_text [ { :text => "Sucursal: ", :color => @color_texto }, { :text => "#{compra.sucursal.descripcion}"}]
      formatted_text [ { :text => "Proveedor: ", :color => @color_texto }, { :text => "#{compra.proveedor.razon_social}"}]
      formatted_text [ { :text => "RUC: ", :color => @color_texto }, { :text => "#{compra.proveedor.ruc}"}]
      if compra.credito
        formatted_text [ { :text => "Tipo de compra: ", :color => @color_texto }, { :text => "Crédito"}]
        if (compra.tipo_credito)
          formatted_text [ { :text => "Tipo crédito: ", :color => @color_texto }, { :text =>"#{compra.tipo_credito.descripcion}"}]
        end
        formatted_text [ { :text => "Cantidad de cuotas: ", :color => @color_texto }, { :text => "#{compra.cantidad_cuotas}"}]
        formatted_text [ { :text => "Deuda: ", :color => @color_texto }, { :text => "#{compra.deuda}"}]
      else
        formatted_text [ { :text => "Tipo de compra: ", :color => @color_texto }, { :text => "Contado"}]
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
      self.column_widths = [(ancho / 3.0), (ancho / 3.0),  (ancho / 3.0)]
    end
  end

  def dibujar_cuotas(cuotas)
    [['Fecha de Vencimiento', 'Factura', 'Monto']] +
    cuotas.map do |cuota|
      [cuota.fecha_vencimiento, cuota.compra.nro_factura, cuota.monto]
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
      self.column_widths = [(ancho / 2.0), (ancho / 2.0)]
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
