# encoding: utf-8
require "prawn/measurement_extensions"

class VencimientoCuotaReportPdf < Prawn::Document
	
	def initialize(lista_cuotas,tipo)
		super(:page_size => "LEGAL", :bottom_margin => 0)
		@color_texto = '3E4D4A'
		header(tipo)
		dibujar_detalles(lista_cuotas,tipo)

	end

	def header (tipo)
	    stroke_horizontal_rule
	    bounding_box([0,cursor], :width => self.bounds.right) do
	    
	      pad(20){           
	        text "Geppii", size: 15, style: :bold, :align => :center
	        text "Reporte de Vencimiento de cuotas de #{tipo}", :align => :center
	        text "#{Date.today.strftime("%d/%m/%Y")}", :align => :center   
	      } 
	    end
	    stroke_horizontal_rule
	end

	def dibujar_detalles(lista_cuotas,tipo)
    ancho = self.bounds.right
    table detalles_rows(lista_cuotas,tipo), :cell_style => { :size => 6} do 
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho*0.25), (ancho * 0.15), (ancho * 0.15), (ancho * 0.15),  (ancho * 0.15),  (ancho * 0.15)]
      self.column(0).style :align => :center
      self.column(1).style :align => :right
      self.column(2).style :align => :right
      self.column(3).style :align => :right
      self.column(4).style :align => :right
      self.column(5).style :align => :right
    end
  end

  def detalles_rows(lista_cuotas,tipo)
    destino = ''
  	if tipo == 'Compras'
  		destino = 'Proveedor'
  	else
  		destino = 'Cliente'
    end

    lista_detalles = []
    monto = ''
    lista_cuotas.map do |registro_cuota|
      canceladostr = ''
      if tipo == 'Compras'
        if registro_cuota.compra.moneda.simbolo == 'Gs.'
          monto = "#{to_Gs(registro_cuota.monto)} Gs"
        elsif registro_cuota.compra.moneda.simbolo == 'USD' 
          monto = "#{to_USD(registro_cuota.monto)} USD"
        end
      else
         if registro_cuota.venta.moneda.simbolo == 'Gs.'
          monto = "#{to_Gs(registro_cuota.monto)} Gs"
        elsif registro_cuota.venta.moneda.simbolo == 'USD' 
          monto = "#{to_USD(registro_cuota.monto)} USD"
        end
      end
      if registro_cuota.cancelado
      	canceladostr = 'Si'
      else	
      	canceladostr = 'No'
      end
      if tipo == 'Compras'
        lista_detalles.push([registro_cuota.compra.proveedor.razon_social, registro_cuota.compra.nro_factura, registro_cuota.nro_cuota,registro_cuota.fecha_vencimiento,monto,canceladostr])
      else
        lista_detalles.push([registro_cuota.venta.cliente.razon_social, registro_cuota.venta.nro_factura, registro_cuota.nro_cuota,registro_cuota.fecha_vencimiento,monto,canceladostr])

      end 
    end
    
    [[destino, 'Numero de factura', 'Numero de cuota', 'Fecha de vencimiento', 'Monto','Atrasado']] + lista_detalles
  end

  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end

  def to_USD(monto)
    return ActionController::Base.helpers.number_to_currency(monto, precision: 2, unit: "",  separator: ",", delimiter: ".")
  end
end


