# encoding: utf-8
require 'axlsx'

class ProductoLoteReportXls

    def initialize(lotes)
    super()
    # header
        cantidadLotes = lotes.count.to_i
        if(cantidadLotes >1)
            productoTemp =  lotes.first.producto_id
            variosProductos = false
            lotes.map do |lote|
                variosProductos = lote.producto_id == productoTemp ? false : true
                break if variosProductos == true
            end
        elsif(cantidadLotes == 0)
             bounding_box([0,cursor], :width => self.bounds.right) do
                pad(20){
                    text "No existen lotes para el rango de fechas asignado", :align => :center
                }
             end
            return
        end

        if(!variosProductos)
            lotesArray = []
            producto = Producto.find(lotes.first.producto_id)
            lotes.map do |lote|
                lotesArray.push(["#{lote.codigo_lote}","#{lote.fecha_vencimiento.strftime("%d/%m/%Y") if !lote.fecha_vencimiento.nil?}"])
            end
            # dibujar_producto(producto.descripcion)
            wb = xlsx_package.workbook
            wb.add_worksheet(name: "Lotes") do |sheet|
              lotesArray.each do |lote|
                sheet.add_row [lote[0], lote[1]]
              end
            end

            return wb
        else
            productos = []
            lotesArray = []
            lotes.map do |lote|
                if(productos.include? lote.producto_id)
                    lotesArray.push(["#{lote.codigo_lote}","#{lote.fecha_vencimiento.strftime("%d/%m/%Y") if !lote.fecha_vencimiento.nil?}"])
                else
                    if(productos.empty?)
                        productos.push(lote.producto_id)
                        lotesArray = [["#{lote.codigo_lote}","#{lote.fecha_vencimiento.strftime("%d/%m/%Y") if !lote.fecha_vencimiento.nil?}"]]
                    else
                        productoTemp = Producto.find(productos.last)
                        dibujar_producto(productoTemp.descripcion)
                        dibujar_lotes(lotesArray)
                        productos.push(lote.producto_id)
                        lotesArray = [["#{lote.codigo_lote}","#{lote.fecha_vencimiento.strftime("%d/%m/%Y") if !lote.fecha_vencimiento.nil?}"]]
                    end
                end
            end
            productoTemp = Producto.find(productos.last)
            dibujar_producto(productoTemp.descripcion)

            wb = xlsx_package.workbook
            wb.add_worksheet(name: "Lotes") do |sheet|
              lotesArray.each do |lote|
                sheet.add_row [lote[0], lote[1]]
              end
            end

            return wb


            # dibujar_lotes(lotesArray)
        end
    # footer
  end

  # def header
  #   stroke_horizontal_rule
  #
  #   bounding_box([0,cursor], :width => self.bounds.right) do
  #
  #     pad(20){
  #       text "Geppii", size: 15, style: :bold, :align => :center
  #         text "Reporte de Lotes por Producto", :align => :center
  #       time = Time.now.strftime("%d/%m/%Y")
  #       text "Fecha: #{time}", :align => :center
  #     }
  #   end
  #   stroke_horizontal_rule
  #
  # end

  #   def dibujar_producto(descripcionProducto)
  #   move_down 30
  #   if cursor <80
  #     start_new_page
  #   end
  #
  #   altura = cursor
  #   bounding_box([0, altura], :width => (self.bounds.right / 3.0)) do
  #       formatted_text [ { :text => "Producto: ", :color => @color_texto }, { :text => "#{descripcionProducto}"}]
	# 	end
  # end
  #
  # def dibujar_lotes(lotes)
  #   #move_down 30
  #   #if cursor <80
  #   #  start_new_page
  #   #end
  #   ancho = self.bounds.right
  #     table dibujar_productos(lotes), :cell_style => { :size => 8, :padding => 2 } do
  #     row(0).font_style = :bold
  #     row(0).text_color = '3E4D4A'
  #     self.header = true
  #     self.row_colors = ['DDDDDD', 'FFFFFF']
  #     self.column_widths = [(ancho/2),(ancho/2)]
  #   end
  # end

# def dibujar_productos(lotes)
#     [['Código del lote', 'Fecha de Vencimiento']] + lotes
#   end
#
#   def footer
#     page_count.times do |i|
#       go_to_page(i+1)
#       bounding_box([bounds.right-50, bounds.bottom + 15], :width => 50) {text "#{i+1} / #{page_count}"}
#     end
#   end
end
