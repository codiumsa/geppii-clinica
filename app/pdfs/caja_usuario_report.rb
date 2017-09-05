# encoding: utf-8
class CajaUsuarioReportPdf < Prawn::Document
  def initialize(movimientos,usuario)
    puts "Movimientos #{movimientos}"
    super()
      @color_texto = '3E4D4A'
        usuario = Usuario.find(usuario)
        if !usuario.apellido.nil? 
            razon_social = usuario.nombre + ' ' + usuario.apellido
        else
            razon_social = usuario.nombre
        end
        header(movimientos,razon_social)
        fechas = movimientos.map(&:fecha).uniq
        listaMovimientos = []
        fechas.map do |fecha|
          movimientoTemp = movimientos.by_fecha_on("#{fecha}")
          sublista = []
          movimientoTemp.map do |mov|
            montoConSigno = mov.monto 
            if (mov.moneda.simbolo == 'US$')
              montoConSigno = to_USD(montoConSigno)
            elsif (mov.moneda.simbolo == 'Gs.')
              montoConSigno = to_Gs(montoConSigno)
            end
            sublista.push([mov.operacion.id,mov.operacion.tipo_operacion.descripcion,mov.descripcion,mov.tipo_operacion_detalle.tipo_movimiento.descripcion,montoConSigno])
          end
            move_down 30
            if cursor <80
              start_new_page
            end
            bounding_box([0, cursor], :width => (self.bounds.right / 3.0)) do
              formatted_text [ { :text => "Fecha: ", :color => @color_texto }, { :text => "#{fecha.strftime("%d/%m/%Y")}"}]
            end
            dibujar_tabla(sublista)
        end

    footer  
  end
 
  def header(movimientos,usuario)
    stroke_horizontal_rule

    bounding_box([0,cursor], :width => self.bounds.right) do
    usuario = usuario.split.map { |i| i.capitalize }.join(' ')
      pad(20){           
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte de Movimientos Caja por Usuario", :align => :center
        text "Usuario: #{usuario}", :align => :center
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center     
      } 
    end
    stroke_horizontal_rule

  end


  def dibujar_tabla(movimientos)
    #move_down 30
    #if cursor <80
    #  start_new_page
    #end
    ancho = self.bounds.right
    table dibujar_productos(movimientos), :cell_style => { :size => 8, :padding => 2 } do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho*0.2), (ancho*0.2), (ancho*0.2), (ancho*0.2),(ancho*0.2)]
    end
  end

  def dibujar_productos(movimientos)
    [['Operacion ID', 'Tipo de operacion', 'Descripcion del movimiento','Tipo de movimiento', 'Monto']] + movimientos
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
