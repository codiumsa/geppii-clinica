# encoding: utf-8
require "prawn/measurement_extensions"


class MovimientoVentaReportPdf < Prawn::Document
	def initialize(ventas,despues_de,en_fecha,antes_de,moneda)
    super(:page_size => "LEGAL", :bottom_margin => 0)
    @color_texto = '3E4D4A'
    header(despues_de,en_fecha,antes_de,moneda)
		if !ventas.empty?
			dibujar_detalles ventas
		else
			bounding_box([0,cursor], :width => self.bounds.right) do
				pad(20){
					text "No existen Productos Vendidos", size: 13, style: :bold, :align => :center
				}
			end
		end
  end

  def header (despues_de,en_fecha,antes_de,moneda)


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
        text "Reporte de Productos Vendidos (Movimiento de Ventas)", :align => :center
        text "#{fecha_str}", :align => :center
        if (moneda)
          text "Moneda: #{moneda}", :align => :center
        end
      }
    end
    stroke_horizontal_rule
  end

  def dibujar_detalles(ventas)
    ancho = self.bounds.right
    puts @color_texto
    ventas.sort_by! {|u| u.fecha_registro}
    table detalles_rows(ventas), :cell_style => { :size => 6} do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho*0.1), (ancho * 0.1), (ancho * 0.05), (ancho * 0.45),  (ancho * 0.15),  (ancho * 0.15)]
      self.column(1).style :align => :right
      self.column(5).style :align => :right
      row(-1).font_style = :bold
    end
  end

  def detalles_rows(ventas)
    if ventas[0].moneda.redondeo
      moneda = 'GS'
    else
      moneda = 'USD'
    end
    @ventas = ventas
    lista_detalles = []
    suma_total = 0
    @ventas.map do |venta|
      medio_pago = ""
      if venta.medio_pago
        medio_pago = venta.medio_pago.nombre
      end
      venta.venta_detalles.map do |detalle|
        if venta.moneda.redondeo
          total = to_Gs((detalle.precio)*(detalle.cantidad))
        else
          total = to_USD((detalle.precio)*(detalle.cantidad))
        end
        suma_total = suma_total + ((detalle.precio)*(detalle.cantidad))
        lista_detalles.push([venta.nro_factura, venta.fecha_registro.strftime("%d/%m/%Y"), detalle.cantidad, detalle.producto.descripcion, medio_pago, total])
      end
      if venta.descuento != 0
        lista_detalles.push([venta.nro_factura, venta.fecha_registro.strftime("%d/%m/%Y"), '1','Descuento general aplicado','-',to_Gs(venta.descuento)])
      end
    end
    if moneda == 'GS'
      suma_total = to_Gs(suma_total)
    elsif moneda == 'USD'
      suma_total = to_USD(suma_total)
    end

    lista_detalles.push(['','','','','',suma_total])
    [['Nro. Factura', 'Fecha', 'Cantidad', 'Producto', 'Medio de pago','Total']] + lista_detalles
  end

  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end

  def to_USD(monto)
    return ActionController::Base.helpers.number_to_currency(monto, precision: 2, unit: "",  separator: ",", delimiter: ".")
  end
end
