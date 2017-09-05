# encoding: utf-8
require "prawn/measurement_extensions"


class DescuentoReportPdf < Prawn::Document
	def initialize(ventas,despues_de,en_fecha,antes_de,moneda, tipo_descuento, producto_id)
    super(:page_size => "LEGAL", :bottom_margin => 50)
    font_size 9
    @color_texto = '3E4D4A'
    header(despues_de,en_fecha,antes_de,moneda)
    dibujar_detalles(ventas, tipo_descuento, producto_id)
    footer
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
        text "Reporte de Descuentos Realizados", :align => :center
        text "#{fecha_str}", :align => :center   
        if (moneda)
          text "Moneda: #{moneda}", :align => :center
        end
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

  def dibujar_detalles(ventas, tipo_descuento, producto_id)
    ancho = self.bounds.right
    puts @color_texto
    ventas.sort_by! {|u| u.fecha_registro}
    if tipo_descuento === 'tiene_descuento' || tipo_descuento === 'tiene_descuento_redondeo'
      detalles = false;
    else
      detalles = true;
    end

    table detalles_rows(ventas, detalles, producto_id), :cell_style => { :size => 6} do 
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column(0).style :align => :right
      self.column(1).style :align => :right
      self.column(3).style :align => :right
      
      if not detalles
        self.column_widths = [(ancho*0.1), (ancho * 0.1), (ancho * 0.3), (ancho * 0.1),  (ancho * 0.2),  (ancho * 0.2)]
        self.column(4).style :align => :right
        self.column(5).style :align => :right
      else
        self.column_widths = [(ancho*0.1), (ancho * 0.1), (ancho * 0.25), (ancho * 0.05),  (ancho * 0.15), (ancho * 0.15), (ancho * 0.1), (ancho * 0.1)]
        self.column(6).style :align => :right
        self.column(7).style :align => :right
      end

      row(-1).font_style = :bold
    end
  end
  
  def detalles_rows(ventas, detalles, producto_id)
    if not ventas[0].nil?
      if ventas[0].moneda.redondeo
        moneda = 'GS' 
      else
        moneda = 'USD'
      end
    end

    if not detalles
      columnas = ['Nro.', 'Fecha', 'Usuario', 'Redondeo', 'Desc. Total', 'Total']
    else
      columnas = ['Nro.', 'Fecha', 'Usuario', 'Cant.', 'Producto', 'Promo', 'Descuento', 'Subtotal']
    end

    @ventas = ventas
    lista_filas = []
    suma_total = 0
    suma_descuento_total = 0
    if not producto_id.nil?
      conProducto = true 
      producto_id = producto_id.to_i
    else
      conProducto = false 
    end

    @ventas.map do |venta|
      if (detalles)
        venta.venta_detalles.map do |detalle|
          if (detalle.descuento > 0 and ((conProducto and producto_id == detalle.producto_id) or not conProducto))
            if venta.moneda.redondeo
              descuento = to_Gs(detalle.descuento)
              total = to_Gs((detalle.precio)*(detalle.cantidad))
            else
              descuento = to_USD(detalle.descuento)
              total = to_USD((detalle.precio)*(detalle.cantidad))
            end

            if not detalle.promocion.nil?
              promocion = detalle.promocion.descripcion
            else 
              promocion = "Sin Promo"
            end

            suma_descuento_total = suma_descuento_total + (detalle.descuento)
            suma_total = suma_total + ((detalle.precio)*(detalle.cantidad))
            lista_filas.push([venta.nro_factura, venta.fecha_registro.strftime("%d/%m/%Y"), venta.usuario.nombre_completo, detalle.cantidad, detalle.producto.descripcion, promocion, descuento, total])
          end
        end
      else
        lista_filas.push([venta.nro_factura, venta.fecha_registro.strftime("%d/%m/%Y"), venta.usuario.nombre_completo, venta.descuento_redondeo, venta.descuento, venta.total])
        suma_descuento_total = suma_descuento_total + venta.descuento
        suma_total = suma_total +  venta.total
      end
    end

    if moneda == 'GS'
      suma_total = to_Gs(suma_total)
      suma_descuento_total = to_Gs(suma_descuento_total)
    elsif moneda == 'USD'
      suma_total = to_USD(suma_total)
      suma_descuento_total = to_USD(suma_descuento_total)
    end
    
    if (detalles)
      lista_filas.push(['','','','','','',suma_descuento_total,suma_total])
    else
      lista_filas.push(['','','','',suma_descuento_total,suma_total])
    end

    [columnas] + lista_filas
  end

  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end

  def to_USD(monto)
    return ActionController::Base.helpers.number_to_currency(monto, precision: 2, unit: "",  separator: ",", delimiter: ".")
  end
end