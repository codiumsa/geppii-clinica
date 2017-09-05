# encoding: utf-8
class FinalCajaReportPdf < Prawn::Document
  def initialize(operaciones,caja)
    super()    
    @color_texto = '3E4D4A'
    stroke_horizontal_rule
    caja = Caja.find(caja)
    header(caja)
    puts "En el reporte, existen #{operaciones.size} operaciones"

    #ORGANIZAR SESIONES DE CAJA: Una sesion termina cuando hay una operacion de cierre. 
    #Pueden existir varias sesiones en el mismo dia.
    sesiones = [[]]
    #Se agrupa en sesion[] un conjunto de operaciones que terminan en un cierre.
    sesion = []
    
    for op in operaciones
      if op.tipo_operacion.codigo == 'cierre'
        sesion << op
        sesiones << sesion
        sesion = []
      else
        sesion<<op
      end
    end

    #en caso de que no haya terminado con un cierre se deberian ignorar estos movimientos porque son sesiones activas 
    if sesion.size > 0
      sesion = []
      #sesiones << sesion
    end

    #Impresion de Sesiones de Caja.
    total_array = [[]]
    cierres = [[]]
    for sesion in sesiones
      total_efectivo = 0
      total_credito = 0
      total_debito = 0
      total_cheque = 0
      totales = []

      for operacion in sesion
        if operacion.tipo_operacion.codigo == 'cierre'
          saldo_pre_cierre = 0
          monto_cierre = 0
          monto_direrencia = 0

          for movimiento in operacion.movimientos
            if movimiento.tipo_operacion_detalle.secuencia == 1 #Debito a caja de usuario
              saldo_pre_cierre = movimiento.saldo + movimiento.monto
              monto_cierre = movimiento.monto
            end
            if movimiento.tipo_operacion_detalle.secuencia == 3 #Diferencia en cierre
              monto_diferencia = movimiento.monto
              tipo_diferencia = monto_cierre > saldo_pre_cierre ? 'SOBRANTE' : 'FALTANTE'
            end
          end
          if caja.tipo_caja === 'U'
            nombre = caja.usuario.nombre_completo
          elsif caja.tipo_caja === 'P'
            nombre = caja.sucursal.descripcion
          end

          bounding_box([0,cursor], :width => self.bounds.right) do
            pad(10){
                text "Dia: #{operacion.created_at.strftime("%d/%m/%Y")}"
                text "Hora: #{operacion.created_at.strftime("%H:%M")}"
                text "Cajero: #{nombre}", :align => :left
                text "Saldo al Cierre: #{to_Gs(saldo_pre_cierre)} Gs", :align => :left
                text "Monto de Cierre:#{to_Gs(monto_cierre)} Gs", :align => :left
                text "#{tipo_diferencia}: #{to_Gs(monto_diferencia.abs)}Gs", :align => :left
            }
          end
          totales = [total_efectivo, total_credito, total_debito, total_cheque]
          ##DIBUJAR TABLA CON MONTOS POR MEDIO DE PAGO
          dibujar_tabla totales
        else
          for movimiento in operacion.movimientos
            if movimiento.operacion.tipo_operacion.codigo == 'venta'
              venta = Venta.find(Movimiento.referencia_id(movimiento))
              if(!venta.venta_medios.empty?)
                venta.venta_medios.map do |ventaMedio|
                  if(ventaMedio.medio_pago.codigo == 'TC')
                      total_credito = total_credito + ventaMedio.monto
                  elsif(ventaMedio.medio_pago.codigo == 'TD')
                      total_debito = total_debito + ventaMedio.monto
                  elsif(ventaMedio.medio_pago.codigo == 'CH')
                      total_cheque = total_cheque + ventaMedio.monto
                  elsif(ventaMedio.medio_pago.codigo == 'EF')
                      total_efectivo = total_efectivo + ventaMedio.monto
                  end
                end
              end
            end
          end
        end
      end
    end
  end
    
  def dibujar_tabla(totalArray)
    ancho = self.bounds.right
    table dibujar_total(totalArray), :cell_style => { :size => 8, :bottom_margin => 5.mm} do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      row(-1).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [(ancho / 4), (ancho / 4),(ancho / 4), (ancho / 4)]
    end
  end

  def dibujar_total(totalArray)
      [['Efectivo', 'Tarjeta De Crédito','Tarjeta De Débito', 'Cheque']] + [totalArray]
  end

  def header(caja)
      bounding_box([0,cursor], :width => self.bounds.right) do

        pad(20){           
          text "Geppii", size: 15, style: :bold, :align => :center
          text "Reporte Final de cajas", :align => :center
          text "Caja: #{caja.descripcion}", :align => :center
          time = Time.now.strftime("%d/%m/%Y")
          text "Fecha: #{time}", :align => :center    
        } 
      end
      stroke_horizontal_rule
      move_down 5.mm
  end

  def to_Gs(int)
      return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end

end