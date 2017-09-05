# encoding: utf-8
require "prawn/measurement_extensions"


class MovimientoVentaReportPdf < Prawn::Document
	def initialize(ventas,despues_de,en_fecha,antes_de)
    super(:page_size => "LEGAL", :bottom_margin => 0)
    @color_texto = '3E4D4A'
    header(despues_de,en_fecha,antes_de)
    dibujar_detalles ventas 
  end

  def header (despues_de,en_fecha,antes_de)
    

    if despues_de and en_fecha and antes_de
      fecha_str = "#{despues_de.to_date}" + "-" + "#{en_fecha.to_date}" + "-" + "#{antes_de.to_date}"
    elsif despues_de and en_fecha and !antes_de
      fecha_str = "Ventas realizadas entre #{despues_de.to_date}" + "y " + "#{en_fecha.to_date}"
    elsif despues_de and !en_fecha and antes_de 
      fecha_str = "Ventas realizadas entre #{despues_de.to_date}" + " y " +  "#{antes_de.to_date}"
    elsif !despues_de and en_fecha and antes_de 
      fecha_str = "Ventas realizadas entre#{en_fecha.to_date}" + "y " +  "#{antes_de.to_date}"
    elsif !despues_de and !en_fecha and antes_de 
      fecha_str =  "Ventas realizadas antes de #{antes_de.to_date}"  
    elsif !despues_de and en_fecha and !antes_de 
      fecha_str =  "Ventas del dia: #{en_fecha.to_date}"  
    elsif !despues_de and !en_fecha and !antes_de 
      fecha_str =  "Ventas realizadas hasta #{Time.now.to_date}"  
    end
    stroke_horizontal_rule
    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){           
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte de Movimiento de Ventas", :align => :center
        text "#{fecha_str}", :align => :center     
      } 
    end
    stroke_horizontal_rule
  end

  def dibujar_detalles(ventas)
    ancho = self.bounds.right
    puts @color_texto
    table detalles_rows(ventas), :cell_style => { :size => 6} do 
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho*0.1), (ancho * 0.1), (ancho * 0.5),  (ancho * 0.15),  (ancho * 0.15)]
    end
  end
  
  def detalles_rows(ventas)
    @ventas = ventas
    lista_detalles = []
    @ventas.map do |venta|
      venta.venta_detalles.map do |detalle|
        lista_detalles.push([venta.nro_factura,detalle.cantidad, detalle.producto.descripcion, venta.medio_pago.nombre, to_Gs((detalle.precio)*(detalle.cantidad))])
      end
      lista_detalles.push([venta.nro_factura,'1','Descuento general aplicado','-',to_Gs(venta.descuento)])
    end

    [['Nro. Factura', 'Cantidad', 'Producto', 'Medio de pago','Total']] + lista_detalles
  end

    def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end
end