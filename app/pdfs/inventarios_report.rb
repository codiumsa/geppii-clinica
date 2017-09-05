# encoding: utf-8
class ReportInventarioPdf < Prawn::Document
  def initialize(inventarios)
    super()
    @color_texto = '3E4D4A'

    @inventarios = inventarios

    header

    @inventarios.map do |inventario|
    if inventario.control
      control = 'Sí'
    else
      control = 'No'
    end


    @inventario_lotes = inventario.inventario_lotes

    productos_ids = []
    categorias_ids = []

    resultado = [[]]


    @inventario_lotes.map do |inventario_producto|
      if not productos_ids.include?(inventario_producto.producto.id)
        productos_ids.push(inventario_producto.producto.id)
      end

      @categorias = inventario_producto.producto.categorias
      @categorias.map do |categoria|
        if not categorias_ids.include?(categoria.id)
          categorias_ids.push(categoria.id)
        end
      end
    end
    
    k = 0
    @inventario_lotes.map do |inventario_producto|
      @categorias = inventario_producto.producto.categorias
      @categorias.map do |categoria|
        if categoria.productos.include?(inventario_producto.producto)
          resultado[k] = [inventario_producto.producto.descripcion, categoria.nombre, inventario_producto.existencia,]
          k += 1
        end
      end

      if inventario_producto.producto.categorias.length == 0 #si no tiene categoría se agrega acá
        resultado[k] = [inventario_producto.producto.descripcion, '', inventario_producto.existencia]
        k += 1
      end
    end

    resultado.sort! { |a,b| a[0].downcase <=> b[0].downcase }

    dibujar_inventario(inventario, resultado,control)
  end

footer  
end
 
  def header
    stroke_horizontal_rule

    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){           
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte de Inventarios", :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center     
      } 
    end
    stroke_horizontal_rule

  end
 
    
  def dibujar_inventario (inventario, resultado,control)
    move_down 30
    if cursor <80
      start_new_page
    end

    altura = cursor
    
    #Se ubica esta columna primero ya que va a ser mas corta que la segunda columna
    #Como el cursor debe quedar en el punto mas bajo para poder seguir insertando bien los elementos,
    #la columna que va mas hasta abajo debe ser la ultima en insertarse para poder garantizar que el
    #cursor quede en buena posicion
    #bounding_box([(self.bounds.right / 3.0) + 20, altura], :width => self.bounds.right / 3.0) do
      #text "IVA 5%: #{compra.iva5}"
      #formatted_text [ { :text => "IVA 5%: ", :color => @color_texto }, { :text => "#{compra.iva5}"}]
      #text "IVA 10%: #{compra.iva10}"
      #formatted_text [ { :text => "IVA 10%: ", :color => @color_texto }, { :text => "#{compra.iva10}"}]
      #text "Descuento: #{compra.descuento}"
      #formatted_text [ { :text => "Descuento ", :color => @color_texto }, { :text => "#{compra.descuento}"}]
      #text "Total: #{compra.total}"
      #formatted_text [ { :text => "Total: ", :color => @color_texto }, { :text => "#{compra.total}"}]
    #end
    
    bounding_box([0, altura], :width => (self.bounds.right / 3.0)) do
      formatted_text [ { :text => "Depósito: ", :color => @color_texto }, { :text => "#{inventario.deposito.nombre}"}]
      formatted_text [ { :text => "Desde fecha: ", :color => @color_texto }, { :text => "#{inventario.fecha_inicio.strftime("%d/%m/%Y")}"}]
      #text "Proveedor: #{compra.proveedor.razon_social}"
      formatted_text [ { :text => "Hasta fecha: ", :color => @color_texto }, { :text => "#{inventario.fecha_fin.strftime("%d/%m/%Y")}"}]
      #text "Fecha de registro: #{compra.fecha_registro}"
      formatted_text [ { :text => "Descripción: ", :color => @color_texto }, { :text => "#{inventario.descripcion}"}]
      formatted_text [ { :text => "Control de Inventario: ", :color => @color_texto }, { :text => "#{control}"}]

    end

    

    dibujar_detalles resultado
      
  end
    
  def dibujar_detalles(resultado)
    #resultado.sort! { |x,y| x.producto <=> y.producto }
    ancho = self.bounds.right
    table detalles_rows resultado do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho / 3.0), (ancho / 3.0), (ancho / 3.0)]
    end
  end
  
  def detalles_rows(resultado)
    [['Producto', 'Categoría', 'Existencia']] +
      resultado.map do |fila|
        fila
      end
  end
    
  def footer
    page_count.times do |i|
      go_to_page(i+1)
      bounding_box([bounds.right-50, bounds.bottom + 25], :width => 50) {text "#{i+1} / #{page_count}"}
    end
  end
end