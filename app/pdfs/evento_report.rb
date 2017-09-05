# encoding: utf-8
require "prawn/measurement_extensions"


class EventoReportPdf < Prawn::Document
	def initialize(eventos,despues_de,en_fecha,antes_de)
    super(:page_size => "LEGAL", :bottom_margin => 50)
    font_size 9
    @color_texto = '3E4D4A'
    header(despues_de,en_fecha,antes_de)
    dibujar_detalles(eventos)
    footer
  end

  def header (despues_de,en_fecha,antes_de)
    

    if despues_de and en_fecha and antes_de
      fecha_str = "#{despues_de.to_date}" + "-" + "#{en_fecha.to_date}" + "-" + "#{antes_de.to_date}"
    elsif despues_de and en_fecha and !antes_de
      fecha_str = "Eventos entre #{despues_de.to_date}" + "y " + "#{en_fecha.to_date}"
    elsif despues_de and !en_fecha and antes_de 
      fecha_str = "Eventos entre #{despues_de.to_date}" + " y " +  "#{antes_de.to_date}"
    elsif !despues_de and en_fecha and antes_de 
      fecha_str = "Eventos entre #{en_fecha.to_date}" + "y " +  "#{antes_de.to_date}"
    elsif !despues_de and !en_fecha and antes_de 
      fecha_str =  "Eventos antes de #{antes_de.to_date}"  
    elsif !despues_de and en_fecha and !antes_de 
      fecha_str =  "Eventos del dia: #{en_fecha.to_date}"  
    elsif !despues_de and !en_fecha and !antes_de 
      fecha_str =  "Eventos hasta #{Time.now.to_date}"  
    end
    stroke_horizontal_rule
    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){           
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte de Eventos", :align => :center
        text "#{fecha_str}", :align => :center   
        
      } 
    end
    stroke_horizontal_rule
  end

  def footer
    options = {
        :at => [self.bounds.right - 150, -10],
        :width => 150,
        :align => :right,
        :start_count_at => 1
    }
    self.number_pages "<page>/<total>", options
  end

  def dibujar_detalles(eventos)
    ancho = self.bounds.right
    puts @color_texto

    table detalles_rows(eventos), :cell_style => { :size => 6 } do 
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column(0).style :align => :right

      self.column_widths = [(ancho*0.1), (ancho * 0.2), (ancho * 0.2), (ancho * 0.5)]
    end
  end
  
  def detalles_rows(eventos)
    columnas = ['Fecha', 'Usuario', 'Tipo', 'Observación']
    
    @eventos = eventos
    lista_filas = []

    @eventos.map do |evento|  
        lista_filas.push([evento.fecha.strftime("%d/%m/%Y"), evento.usuario.nombre_completo, evento.tipoFormateado, evento.observacion])
    end
    [columnas] + lista_filas
  end
end