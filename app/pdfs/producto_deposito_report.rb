# encoding: utf-8
class ProductoDepositoReportPdf < Prawn::Document
  def initialize(productoDepositos, parametros_empresa)
    super()
    @color_texto = '3E4D4A'
		
    @productoDepositos = productoDepositos
    header
		analizados = []
    @total_inversion = 0
    @moneda = parametros_empresa.moneda

    @productoDepositos.map do |productoDeposito|
			if not analizados.include? productoDeposito.deposito_id
				analizados.push(productoDeposito.deposito_id)
				seleccionados = []
				@productoDepositos.map do |pd|
					if pd.deposito_id == productoDeposito.deposito_id and pd.producto.activo == true
						seleccionados.push(pd)
					end
				end
        if(seleccionados.size > 0)
  				dibujar_deposito seleccionados[0].deposito
          seleccionados.sort! { |a,b| a.producto.descripcion.downcase <=> b.producto.descripcion.downcase }
  				dibujar_tabla seleccionados
        end
			end
    end

    sumarizar

    footer  
  end
 
  def header
    stroke_horizontal_rule

    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){           
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte de Productos por Depósitos", :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center     
      } 
    end
    stroke_horizontal_rule

  end
	
	def dibujar_deposito (deposito)
    move_down 30
    if cursor <80
      start_new_page
    end

    altura = cursor
    bounding_box([0, altura], :width => (self.bounds.right / 3.0)) do
      formatted_text [ { :text => "Depósito: ", :color => @color_texto }, { :text => "#{deposito.nil? ? "" : deposito.nombre}"}]
		end
  end

  def dibujar_tabla(productoDepositos)
    #move_down 30
    #if cursor <80
    #  start_new_page
    #end
    ancho = self.bounds.right
    table dibujar_productos(productoDepositos), :cell_style => { :size => 8, :padding => 2 } do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho*3 / 7.0), (ancho / 7.0), (ancho / 7.0), (ancho / 7.0), (ancho / 7.0)]
    end
  end

  def dibujar_productos(productoDepositos)
    [['Descripción del Producto', 'Código de barras', 'Existencia', 'Precio Promedio', 'Valor Total']] +
    productoDepositos.map do |productoDeposito|

      moneda_producto_id = productoDeposito.producto.moneda.id
      monto_cotizacion = cotizar(@moneda.id, moneda_producto_id)
     
      precio_promedio = productoDeposito.producto.precio_promedio * monto_cotizacion 
      total = precio_promedio * productoDeposito.existencia

      @total_inversion = @total_inversion + total

      precio_promedio = montoMonedaFormateado(precio_promedio, productoDeposito.producto.moneda)
      total = montoMonedaFormateado(total, productoDeposito.producto.moneda)

      [productoDeposito.producto.descripcion, productoDeposito.producto.codigo_barra, productoDeposito.existencia,
        precio_promedio, total]
    end  
  end

  def cotizar(moneda_id, moneda_destino_id)
    cotizacion = Cotizacion.get_cotizacion(moneda_id, moneda_destino_id)
      
    if not cotizacion.nil?
      monto_cotizacion = cotizacion.monto
    end

    if monto_cotizacion.nil?
      monto_cotizacion = 1
    end

    monto_cotizacion
  end

  def montoMonedaFormateado(monto, moneda)
    if (moneda.simbolo == 'US$')
      monto = to_USD(monto)
    elsif (moneda.simbolo == 'Gs.')
      monto = to_Gs(monto)
    end
    monto
  end

  def sumarizar
    move_down 30
    if cursor <80
      start_new_page
    end

    inversionFormateada = montoMonedaFormateado(@total_inversion, @moneda)
    formatted_text [ { :text => "Datos sumarizados", :color => @color_texto }]
    formatted_text [ { :text => "Inversión en Productos: ", :color => @color_texto }, { :text => "#{inversionFormateada}"}]
  end
    
  def footer
    page_count.times do |i|
      go_to_page(i+1)
      bounding_box([bounds.right-50, bounds.bottom + 15], :width => 50) {text "#{i+1} / #{page_count}"}
    end
  end

  def to_USD(monto)
    return ActionController::Base.helpers.number_to_currency(monto, precision: 2, unit: "",  separator: ",", delimiter: ".")
  end
  
  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end
end
