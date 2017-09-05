# encoding: utf-8
class CajaMedioPagoReportPdf < Prawn::Document
    def initialize(movimientos,caja,antes_de,en_fecha,despues_de)
    super()
    @color_texto = '3E4D4A'
    caja = Caja.find(caja)
    header(caja,antes_de,en_fecha,despues_de)
    
    lista_movimientos = []

#    totalChequeUSD = 0
#    totalEfectivoUSD = 0 
#    totalCreditoUSD = 0
#    totalDebitoUSD = 0
    totalChequeGS = 0
    totalEfectivoGS = 0 
    totalCreditoGS = 0
    totalDebitoGS = 0

    if(!movimientos.empty?)
      movimientos.map do |movimiento|
          efectivoArray = []
          tarjetaCreditoArray = []
          tarjetaDebitoArray = []
          chequeArray = []
          if(movimiento.operacion.tipo_operacion.codigo == 'venta')
             venta = Venta.find(Movimiento.referencia_id(movimiento))
            if(!venta.venta_medios.empty? and venta.venta_padre_id.nil?)
                  venta.venta_medios.map do |ventaMedioTemp|
                        if(ventaMedioTemp.medio_pago.codigo == 'EF')
                            totalEfectivoGS = totalEfectivoGS + ventaMedioTemp.monto
                            efectivoArray.push(ventaMedioTemp.monto)                    
                        elsif(ventaMedioTemp.medio_pago.codigo == 'TC')
                              tarjetaCreditoArray.push(ventaMedioTemp.monto)
                              totalCreditoGS = totalCreditoGS + ventaMedioTemp.monto
                        elsif(ventaMedioTemp.medio_pago.codigo == 'CH')
                              chequeArray.push(ventaMedioTemp.monto)
                              totalChequeGS = totalChequeGS + ventaMedioTemp.monto
                        elsif(ventaMedioTemp.medio_pago.codigo == 'TD')
                               totalDebitoGS = totalDebitoGS + ventaMedioTemp.monto
                               tarjetaDebitoArray.push(ventaMedioTemp.monto)
                        end
                    end
            end
            #else
            #    if(venta.medio_pago.codigo == 'EF')
            #        totalEfectivoGS = totalEfectivoGS + venta.total
            #        efectivoArray.push(venta.total)                    
            #    elsif(venta.medio_pago.codigo == 'TC')
            #        tarjetaCreditoArray.push(venta.total)
            #        totalCreditoGS = totalCreditoGS + venta.total
            #    elsif(venta.medio_pago.codigo == 'CH')
            #        chequeArray.push(venta.total)
            #        totalChequeGS = totalChequeGS + venta.total
            #    elsif(venta.medio_pago.codigo == 'TD')
            #        totalDebitoGS = totalDebitoGS + venta.total
            #        tarjetaDebitoArray.push(venta.total)
            #    end
            #end
              if efectivoArray.empty?
                  efectivoArray = ''
              end
              if chequeArray.empty?
                  chequeArray = ''
              end
              if tarjetaDebitoArray.empty?
                  tarjetaDebitoArray = ''
              end
              if tarjetaCreditoArray.empty?
                  tarjetaCreditoArray = ''
              end
              lista_movimientos.push(["#{(venta.fecha_registro).strftime("%d/%m/%Y")}","#{venta.id}","#{movimiento.operacion.tipo_operacion.descripcion}",efectivoArray,tarjetaCreditoArray,tarjetaDebitoArray,chequeArray, to_Gs(movimiento.saldo)])
          
          else
              lista_movimientos.push(["#{(movimiento.fecha).strftime("%d/%m/%Y")}","#{movimiento.operacion.id}","#{movimiento.operacion.tipo_operacion.descripcion}",movimiento.monto_cotizado,'','','',to_Gs(movimiento.saldo)])
          end
      end
    end

#      if(lista_ventasGS.length > 0 and lista_ventasUSD.length == 0)
#        lista_ventasGS.push(['TOTAL (Gs) ',' ',' ',to_Gs(totalEfectivoGS),to_Gs(totalCreditoGS),to_Gs(totalChequeGS),to_Gs(totalDebitoGS)])
#        old_y = cursor
#        bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
#          self.y = old_y
#          dibujar_tabla(lista_ventasGS)
#        end
#      elsif(lista_ventasGS.length == 0 and lista_ventasUSD.length > 0)
#        lista_ventasUSD.push(['TOTAL (USD) ',' ',' ',to_USD(totalEfectivoUSD), to_USD(totalCreditoUSD), to_USD(totalChequeUSD), to_USD(totalDebitoUSD)])
#        old_y = cursor
#        bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
#          self.y = old_y
#          dibujar_tabla(lista_ventasUSD)
#        end
#      elsif (lista_ventasGS.length > 0 and lista_ventasUSD.length > 0)
#        lista_ventasGS.push(['TOTAL (Gs) ',' ',' ',to_Gs(totalEfectivoGS),to_Gs(totalCreditoGS),to_Gs(totalChequeGS),to_Gs(totalDebitoGS)])
#        old_y = cursor
#        bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
#          self.y = old_y
#          dibujar_tabla(lista_ventasGS)
#        end
#        start_new_page
#        lista_ventasUSD.push(['TOTAL (USD) ',' ',' ',to_USD(totalEfectivoUSD), to_USD(totalCreditoUSD),to_USD(totalChequeUSD),to_USD(totalDebitoUSD)])
#        bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
#          dibujar_tabla(lista_ventasUSD)
#        end
#      end
        
        lista_movimientos.map do |mov|
            mov.map! do |elem|
                if elem.kind_of?(Array)
                    if(elem.length > 1)
                        elem = elem.combination(1).to_a
                        make_table(elem, :cell_style => { :size => 8, :bottom_margin => 5.mm, :width => 67.5})
                    else
                        elem.first
                    end
                else    
                    elem = elem
                end
            end
        end
        dibujar_tabla(lista_movimientos) 

    footer  
  end
 
  def header (caja,antes_de,en_fecha,despues_de)
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
        text "Reporte de Caja por Medios de Pago", :align => :center
        text "Caja: #{caja.descripcion}", :align => :center
        text "#{fecha_str}", :align => :center   
      } 
    end
    stroke_horizontal_rule
    move_down 5.mm
  end

  def dibujar_tabla(lista_movimientos)
    ancho = self.bounds.right
      lista_movimientos.unshift(['Fecha','ID Origen','Tipo de Operacion','Efectivo', 'T. de Crédito','T. de Débito','Cheque','Saldo en Caja'])
      table lista_movimientos, :cell_style => { :size => 8, :bottom_margin => 5.mm} do
          row(0).font_style = :bold
          row(0).text_color = '3E4D4A'
          columns(6).width = ancho / 8
          self.header = true
          self.row_colors = ['DDDDDD', 'FFFFFF']
#            self.column_widths = [(ancho / 8), (ancho / 8),(ancho / 8), (ancho / 8), (ancho / 8), (ancho / 8),(ancho / 8), (ancho / 8)]
        end

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
