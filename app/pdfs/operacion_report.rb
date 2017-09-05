# encoding: utf-8
class OperacionesReportPdf < Prawn::Document
  def initialize(operaciones)
    puts "Operaciones #{operaciones}"
    super()
      @color_texto = '3E4D4A'
  		if operaciones.size > 0
        header(operaciones)
        dibujar_tabla(operaciones)
      end
    footer  
  end
 
  def header(operaciones)
    stroke_horizontal_rule

    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){           
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte de Operaciones", :align => :center
        #text "Caja: #{operaciones[0].caja.descripcion}", :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center     
      } 
    end
    stroke_horizontal_rule

  end


  def dibujar_tabla(operaciones)
    #move_down 30
    #if cursor <80
    #  start_new_page
    #end
    ancho = self.bounds.right
    table dibujar_operaciones(operaciones), :cell_style => { :size => 8, :padding => 2 } do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho*0.1), (ancho*0.2), (ancho*0.2), (ancho*0.2), (ancho*0.2), (ancho*0.1)]
    end
  end

  def dibujar_operaciones(operaciones)
    [['Fecha', 'Tipo de operación', 'Caja', 'Caja Destino', 'Referencia', 'Monto']] +
    operaciones.map do |operacion|
 
      if (operacion.moneda.simbolo == 'US$')
        montoConSigno = to_USD(operacion.monto)
      elsif (operacion.moneda.simbolo == 'Gs.')
        montoConSigno = to_Gs(operacion.monto)
      end

      if not operacion.caja_destino.nil?
        caja_destino = operacion.caja_destino.descripcion
      else
        caja_destino = "N/A"
      end

      if not operacion.categoria_operacion.nil?
        referencia = operacion.categoria_operacion.nombre
      else
        referencia = operacion.referencia
      end

      [operacion.fecha.strftime("%d/%m/%Y"), operacion.tipo_operacion.descripcion, operacion.caja.descripcion, caja_destino, referencia, montoConSigno]
    end  
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
