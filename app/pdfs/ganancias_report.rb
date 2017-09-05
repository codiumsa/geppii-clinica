# encoding: utf-8
class GananciasReportPdf < Prawn::Document
  def initialize(sesionCajas, ventas, productos)
    super()
    @color_texto = '3E4D4A'
    header
    
    @sesionCajas = sesionCajas
    @ventas = ventas
    @productos = productos
      
    @total_credito = 0
    @total_debito = 0
    @sesiones_filtradas = []
    @sesionCajas.map do |sesion_caja|
      if sesion_caja.operacion_caja.descripcion == 'Salida de dinero'
        @sesiones_filtradas.push(sesion_caja)
        @total_debito = @total_debito + sesion_caja.monto 
      end
    end
    @total_inversion = 0
    @productos.map do |producto|
      @total_inversion = @total_inversion + (producto.existencia * producto.producto.precio_promedio)
    end
    
    @ventas.map do |venta|
      @total_credito = @total_credito + venta.ganancia
    end
    
    dibujar_sesiones_caja @sesiones_filtradas
    dibujar_ventas @ventas
    dibujar_productos @productos
      
    sumarizar

          
    footer
      
  end
 
  def header
    stroke_horizontal_rule

    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){           
        text "Bodega Staff", size: 15, style: :bold, :align => :center
        text "Reporte de Ganancias", :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center     
      } 
    end
    stroke_horizontal_rule

  end
 
    
  def dibujar_sesiones_caja (sesiones_caja)
    move_down 30
    if cursor <80
      start_new_page
    end    
    formatted_text [ { :text => "Egresos", :color => @color_texto }]
    dibujar_sesiones sesiones_caja
  end
    
  def dibujar_sesiones(sesiones_caja)
    ancho = self.bounds.right
    table sesiones_rows sesiones_caja do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho / 4.0),(ancho / 4.0),(ancho / 4.0),(ancho / 4.0),]
    end
  end
  
  def sesiones_rows(sesiones_caja)
    [['Sucursal','Fecha', 'Observación', 'Monto']] +
      sesiones_caja.map do |sesion|
        [sesion.caja.sucursal.descripcion, sesion.fecha.strftime("%d/%m/%Y"), sesion.observacion, sesion.monto]
      end
  end
    
  def dibujar_ventas(ventas)
    move_down 30
    if cursor <80
      start_new_page
    end    
    formatted_text [ { :text => "Ingresos", :color => @color_texto }]
      
    ancho = self.bounds.right
    table ventas_rows ventas do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho / 4.0),(ancho / 4.0),(ancho / 4.0),(ancho / 4.0),]
    end
  end
  
  def ventas_rows(ventas)
    [['Sucursal','Fecha', 'Observación', 'Monto']] +
      ventas.map do |venta|
        cliente_nombre = ''
        if venta.cliente.nombre
          cliente_nombre = cliente_nombre + venta.cliente.nombre
        end
        if venta.cliente.apellido
          cliente_nombre = cliente_nombre + ' ' + venta.cliente.apellido
        end
        [venta.sucursal.descripcion, venta.fecha_registro.strftime("%d/%m/%Y"), 'Venta a cliente ' + cliente_nombre, venta.ganancia]
      end
  end
    
    
    
    
    
  def dibujar_productos(productos)
    move_down 30
    if cursor <80
      start_new_page
    end    
    formatted_text [ { :text => "Inversión en Productos", :color => @color_texto }]
      
    ancho = self.bounds.right
    table productos_rows productos do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho / 5.0),(ancho / 5.0),(ancho / 5.0),(ancho / 5.0),(ancho / 5.0),]
    end
  end
  
  def productos_rows(productos)
    [['Sucursal','Producto', 'Existencia', 'Precio unitario', 'Total']] +
      productos.map do |producto|

        [producto.sucursal.descripcion, producto.producto.descripcion, producto.existencia, producto.producto.precio_promedio, (producto.existencia * producto.producto.precio_promedio).to_s]
      end
  end
    
  def sumarizar
    move_down 30
    if cursor <80
      start_new_page
    end
    formatted_text [ { :text => "Datos sumarizados", :color => @color_texto }]
    formatted_text [ { :text => "Entrada total de dinero: ", :color => @color_texto }, { :text => "#{@total_credito}"}]
    formatted_text [ { :text => "Salida total de dinero: ", :color => @color_texto }, { :text => "#{@total_debito}"}]
    formatted_text [ { :text => "Ganancia: ", :color => @color_texto }, { :text => "#{@total_credito - @total_debito}"}]
    formatted_text [ { :text => "Inversión en Productos: ", :color => @color_texto }, { :text => "#{@total_inversion}"}]
    
  end
    
  def footer
    page_count.times do |i|
      go_to_page(i+1)
      bounding_box([bounds.right-50, bounds.bottom + 25], :width => 50) {text "#{i+1} / #{page_count}"}
    end
  end
end