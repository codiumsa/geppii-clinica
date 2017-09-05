# encoding: utf-8
class PreciosVentaReportPdf < Prawn::Document
  def initialize(producto,precioCompra,empresa)
    super()
    @color_texto = '3E4D4A'
    header(empresa)

    precioCompra = to_boolean(precioCompra)
    lista_recargos = []
    recargos = Recargo.all
    if(!recargos.empty?)
      if (producto != '-1')
        productotemp = Producto.find(producto)
        recargos.map do |recargoTemp|
          recargoTemp.interes = recargoTemp.interes / 100
          if (precioCompra)
            if(productotemp.moneda.simbolo == 'US$')
                if(!(productotemp.tipo_producto.codigo == 'S'))
                lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, "#{to_USD(recargoTemp.interes*productotemp.precio_promedio + productotemp.precio_promedio)} USD"])
              else
                lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, "#{to_USD(recargoTemp.interes*productotemp.precio + productotemp.precio)} USD"])
              end
            elsif(productotemp.moneda.simbolo == 'Gs.')
              if(!productotemp)
               lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, "#{to_Gs(recargoTemp.interes*productotemp.precio_promedio + productotemp.precio_promedio)} Gs."])
              else
               lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, "#{to_Gs(recargoTemp.interes*productotemp.precio + productotemp.precio)} Gs."])
              end
            end
          else
            if(productotemp.moneda.simbolo == 'US$')
              if(!productotemp)
                lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, recargoTemp.interes * 100, "#{to_USD(productotemp.precio_promedio)} USD", "#{to_USD(recargoTemp.interes*productotemp.precio_promedio + productotemp.precio_promedio)} USD"])                
              else
                lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, recargoTemp.interes * 100, "#{to_USD(productotemp.precio)} USD", "#{to_USD(recargoTemp.interes*productotemp.precio + productotemp.precio)} USD"])
              end
            elsif(productotemp.moneda.simbolo == 'Gs.')
              if(!productotemp)
                lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, recargoTemp.interes * 100, "#{to_Gs(productotemp.precio_promedio)} Gs.", "#{to_Gs(recargoTemp.interes*productotemp.precio_promedio + productotemp.precio_promedio)} Gs."])
              else
                lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, recargoTemp.interes * 100, "#{to_Gs(productotemp.precio)} Gs.", "#{to_Gs(recargoTemp.interes*productotemp.precio + productotemp.precio)} Gs."])
              end
            end
          end
        end
      else
          productos = Producto.by_activo()
          productos.map do |productotemp|
            recargos.map do |recargoTemp|
              if (precioCompra)
                if(productotemp.moneda.simbolo == 'US$')
                  if(!productotemp)
                    lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, "#{to_USD((recargoTemp.interes/100)*productotemp.precio_promedio + productotemp.precio_promedio)} USD"])
                  else
                    lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, "#{to_USD((recargoTemp.interes/100)*productotemp.precio + productotemp.precio)} USD"])
                  end
                elsif(productotemp.moneda.simbolo == 'Gs.')
                  if(!productotemp)
                    lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, "#{to_Gs((recargoTemp.interes/100)*productotemp.precio_promedio + productotemp.precio_promedio)} Gs."])
                  else
                    lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, "#{to_Gs((recargoTemp.interes/100)*productotemp.precio + productotemp.precio)} Gs."])
                  end
                end
              else
                if(productotemp.moneda.simbolo == 'US$')
                  if(!productotemp)
                    lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, recargoTemp.interes, "#{to_USD(productotemp.precio_promedio)} USD", "#{to_USD((recargoTemp.interes/100)*productotemp.precio_promedio + productotemp.precio_promedio)} USD"])
                  else
                    lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, recargoTemp.interes, "#{to_USD(productotemp.precio)} USD", "#{to_USD((recargoTemp.interes/100)*productotemp.precio + productotemp.precio)} USD"])
                  end
                elsif(productotemp.moneda.simbolo == 'Gs.')
                  if(!productotemp)
                    lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, recargoTemp.interes, "#{to_Gs(productotemp.precio_promedio)} Gs.", "#{to_Gs((recargoTemp.interes/100)*productotemp.precio_promedio + productotemp.precio_promedio)} Gs."])
                  else
                    lista_recargos.push([recargoTemp.medio_pago.nombre, recargoTemp.tipo_credito.descripcion, recargoTemp.cantidad_cuotas, recargoTemp.interes, "#{to_Gs(productotemp.precio)} Gs.", "#{to_Gs((recargoTemp.interes/100)*productotemp.precio + productotemp.precio)} Gs."])
                  end
                end
              end
          end
        end
      end
      formatted_text [ { :text => "Producto: ", :color => @color_texto }, { :text => "#{productotemp.descripcion}"}]
      old_y = cursor
      bounding_box([bounds.left, bounds.top],:width => bounds.width, :height => bounds.height - 20) do
        self.y = old_y
        dibujar_tabla(lista_recargos,precioCompra)
      end
    else
      bounding_box([0,cursor], :width => self.bounds.right) do
        pad(20){           
          text "El recargo no esta definido", size: 15, style: :bold, :align => :center 
        } 
      end
    end

    footer  
  end
 
  def header (empresa)
    stroke_horizontal_rule
    bounding_box([0,cursor], :width => self.bounds.right) do
    
      pad(20){           
        text "Geppii", size: 15, style: :bold, :align => :center
        text "Reporte de Precios de Venta", :align => :center
        idEmpresa = empresa.to_i
        if(idEmpresa != 0)
          nombreEmpresa = Empresa.find(idEmpresa).nombre
          text "Empresa: " + nombreEmpresa, :align => :center
        end
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center
      } 
    end
    stroke_horizontal_rule
    move_down 5.mm

  end
	
	def dibujar_deposito (deposito)
    move_down 30
    if cursor <80
      start_new_page
    end

    altura = cursor
    bounding_box([0, altura], :width => (self.bounds.right / 3.0)) do
      formatted_text [ { :text => "Depósito: ", :color => @color_texto }, { :text => "#{deposito.nil? ? "" : deposito.nombre}"}]
		end
  end

  def dibujar_tabla(lista_recargos,precioCompra)
    ancho = self.bounds.right
    table dibujar_productos(lista_recargos,precioCompra), :cell_style => { :size => 8, :bottom_margin => 5.mm} do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      if(precioCompra)
        self.column_widths = [(ancho / 4), (ancho / 4), (ancho / 4), (ancho / 4)]
      else
        self.column_widths = [(ancho / 6), (ancho / 6), (ancho / 6), (ancho / 6), (ancho / 6), (ancho / 6)]
      end
    end
  end

  def dibujar_productos(lista_recargos,precioCompra)
    if(precioCompra)
      [['Medio de Pago','Tipo de Credito','Cantidad de Cuotas','Precio Calculado']] + lista_recargos
    else
      [['Medio de Pago','Tipo de Credito', 'Cantidad de Cuotas', 'Recargo (%)','Precio Compra', 'Precio Calculado']] + lista_recargos
    end 
  end
    
  def footer
    page_count.times do |i|
      go_to_page(i+1)
      bounding_box([bounds.right-50, bounds.bottom + 15], :width => 50) {text "#{i+1} / #{page_count}"}
    end
  end

  def to_boolean(str)
    str == 'true'
  end

  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end

  def to_USD(monto)
    return ActionController::Base.helpers.number_to_currency(monto, precision: 2, unit: "",  separator: ",", delimiter: ".")
  end
end
