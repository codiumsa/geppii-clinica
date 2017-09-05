# encoding: utf-8
class VentasMedioPagoReportPdf < Prawn::Document
  def initialize(ventas,empresa,antes_de,en_fecha,despues_de)
    super()
    @color_texto = '3E4D4A'
    header(empresa,antes_de,en_fecha,despues_de)
    
    lista_ventasUSD = []
    lista_ventasGS = []

    totalChequeUSD = 0
    totalEfectivoUSD = 0 
    totalCreditoUSD = 0
    totalDebitoUSD = 0
    totalChequeGS = 0
    totalEfectivoGS = 0 
    totalCreditoGS = 0
    totalDebitoGS = 0

    if(!ventas.empty?)
      ventas.map do |venta|
        if(venta.medio_pago_id)
          if(venta.medio_pago.codigo == 'EF')
            if(venta.moneda.simbolo == 'US$')
              totalEfectivoUSD = totalEfectivoUSD + venta.total
              lista_ventasUSD.push([venta.fecha_registro.to_date,venta.nro_factura, venta.cliente.razon_social,to_USD(venta.total),'-','-','-'])
            elsif(venta.moneda.simbolo == 'Gs.')
              totalEfectivoGS = totalEfectivoGS + venta.total
              lista_ventasGS.push([venta.fecha_registro.to_date,venta.nro_factura,venta.cliente.razon_social,to_Gs(venta.total),'-','-','-'])
            end
          elsif(venta.medio_pago.codigo == 'TC')
            if(venta.moneda.simbolo == 'US$')
              totalCreditoUSD = totalCreditoUSD + venta.total
              lista_ventasUSD.push([venta.fecha_registro.to_date,venta.nro_factura,venta.cliente.razon_social,'-',to_USD(venta.total),'-','-'])
            elsif(venta.moneda.simbolo == 'Gs.')
              totalCreditoGS = totalCreditoGS + venta.total
              lista_ventasGS.push([venta.fecha_registro.to_date,venta.nro_factura,venta.cliente.razon_social,'-',to_Gs(venta.total),'-','-'])
            end
          elsif(venta.medio_pago.codigo == 'CH')
            if(venta.moneda.simbolo == 'US$')
              totalChequeUSD = totalChequeUSD + venta.total
              lista_ventasUSD.push([venta.fecha_registro.to_date,venta.nro_factura,venta.cliente.razon_social,'-','-',to_USD(venta.total),'-'])
            elsif(venta.moneda.simbolo == 'Gs.')
              totalChequeGS = totalChequeGS + venta.total
              lista_ventasGS.push([venta.fecha_registro.to_date,venta.nro_factura,venta.cliente.razon_social,'-','-',to_Gs(venta.total),'-'])
            end
          elsif(venta.medio_pago.codigo == 'TD')
            if(venta.moneda.simbolo == 'US$')
               totalDebitoUSD = totalDebitoUSD + venta.total
               lista_ventasUSD.push([venta.fecha_registro.to_date,venta.nro_factura,venta.cliente.razon_social,'-','-','-',to_USD(venta.total)])
            elsif(venta.moneda.simbolo == 'Gs.')
               totalDebitoGS = totalDebitoGS + venta.total
               lista_ventasGS.push([venta.fecha_registro.to_date,venta.nro_factura,venta.cliente.razon_social,'-','-','-',to_Gs(venta.total)])
            end
          end
        end
      end

      if(lista_ventasGS.length > 0 and lista_ventasUSD.length == 0)
        lista_ventasGS.push(['TOTAL (Gs) ',' ',' ',to_Gs(totalEfectivoGS),to_Gs(totalCreditoGS),to_Gs(totalChequeGS),to_Gs(totalDebitoGS)])
        old_y = cursor
        bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
          self.y = old_y
          dibujar_tabla(lista_ventasGS)
        end
      elsif(lista_ventasGS.length == 0 and lista_ventasUSD.length > 0)
        lista_ventasUSD.push(['TOTAL (USD) ',' ',' ',to_USD(totalEfectivoUSD), to_USD(totalCreditoUSD), to_USD(totalChequeUSD), to_USD(totalDebitoUSD)])
        old_y = cursor
        bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
          self.y = old_y
          dibujar_tabla(lista_ventasUSD)
        end
      elsif (lista_ventasGS.length > 0 and lista_ventasUSD.length > 0)
        lista_ventasGS.push(['TOTAL (Gs) ',' ',' ',to_Gs(totalEfectivoGS),to_Gs(totalCreditoGS),to_Gs(totalChequeGS),to_Gs(totalDebitoGS)])
        old_y = cursor
        bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
          self.y = old_y
          dibujar_tabla(lista_ventasGS)
        end
        start_new_page
        lista_ventasUSD.push(['TOTAL (USD) ',' ',' ',to_USD(totalEfectivoUSD), to_USD(totalCreditoUSD),to_USD(totalChequeUSD),to_USD(totalDebitoUSD)])
        bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
          dibujar_tabla(lista_ventasUSD)
        end
      end
    end

    footer  
  end
 
  def header (empresa,antes_de,en_fecha,despues_de)
    if despues_de and antes_de
      fecha_str = "Ventas realizadas entre #{despues_de.to_date}" + " y " + "#{antes_de.to_date}"
    elsif despues_de 
      fecha_str = "Ventas realizadas después de: #{despues_de.to_date}"
    elsif antes_de 
      fecha_str = "Ventas realizadas antes de:" + "#{antes_de.to_date}"  
    elsif en_fecha 
      fecha_str =  "Ventas del día: #{en_fecha.to_date}"  
    else
      fecha_str =  "Ventas realizadas hasta #{Time.now.to_date}"  
    end
    stroke_horizontal_rule
    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){ 
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte de Ventas por Medio de pago", :align => :center
        idEmpresa = empresa.to_i
        if(idEmpresa != 0)
          nombreEmpresa = Empresa.find(idEmpresa).nombre
          text "Empresa: " + nombreEmpresa, :align => :center
        end
        text "#{fecha_str}", :align => :center   
      } 
    end
    stroke_horizontal_rule
    move_down 5.mm
  end

  def dibujar_tabla(lista_ventas)
    ancho = self.bounds.right
    table dibujar_ventas(lista_ventas), :cell_style => { :size => 8, :bottom_margin => 5.mm} do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      row(-1).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [(ancho / 7), (ancho / 7),(ancho / 7), (ancho / 7), (ancho / 7), (ancho / 7), (ancho / 7)]
    end
  end

  def dibujar_ventas(lista_ventas)
      [['Fecha', 'Número de Factura','Cliente', 'Efectivo','Tarjeta de Crédito','Cheque','Tarjeta de Débito']] + lista_ventas
  end
    
  def footer
    page_count.times do |i|
      go_to_page(i+1)
      bounding_box([bounds.right-50, bounds.bottom + 15], :width => 50) {text "#{i+1} / #{page_count}"}
    end
  end

  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end
  def to_USD(monto)
    return ActionController::Base.helpers.number_to_currency(monto, precision: 2, unit: "",  separator: ",", delimiter: ".")
  end
end
