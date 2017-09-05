# encoding: utf-8
require "prawn/measurement_extensions"

class UsoInternoReportPdf < Prawn::Document
  def initialize(venta)
    super(:page_size => "LEGAL", :page_layout => :landscape)

    @color_texto = '3E4D4A'
    venta = Venta.unscoped.find(venta.id)

    dibujar_venta(venta, 25.mm)
    move_cursor_to(self.bounds.top)
    
    dibujar_venta(venta, 195.mm)
  end
 

  def dibujar_venta (venta, offset)
    if venta.moneda.redondeo
      decimales = 0
    else
      decimales = 2
    end

    move_down 15.mm
    altura = cursor
    bounding_box([offset + 55.mm, altura], :width => self.bounds.right) do
      formatted_text_box([{ :text => "Venta N. ", size:10,:styles => [:bold]}, {:text => "#{venta.id}",size:10}])
    end

    move_down 10.mm
    altura = cursor

    bounding_box([offset, altura], :width => self.bounds.right) do
      formatted_text_box([{:text => "Fecha de emisión: ", size:8,:styles => [:bold]}, {:text=> "#{venta.fecha_registro.strftime("%d/%m/%Y")}", size:8}])
    end
    if venta.credito.eql? false
      bounding_box([80.mm + offset, altura], :width => self.bounds.right) do
        formatted_text_box([{:text => "Condición de venta: ", size:8, :styles => [:bold]},{:text => "Contado", size:8} ])
        end
    else
      bounding_box([80.mm + offset, altura], :width => self.bounds.right) do
        formatted_text_box([{:text => "Condición de venta: ", size:8, :styles => [:bold]},{:text => "Crédito", size:8} ])
      end
    end
  

    move_down 5.mm
    altura = cursor

    bounding_box([offset, altura], :width => self.bounds.right) do
      if venta.nombre_cliente
        formatted_text_box([{:text => "Nombre o Razón Social: ", size:8, :styles => [:bold]},{:text => "#{venta.nombre_cliente}", size:8} ])
      else
        formatted_text_box([{:text => "Nombre o Razón Social: ", size:8, :styles => [:bold]},{:text => "#{venta.cliente.razon_social}", size:8} ])
      end
    end

    bounding_box([80.mm + offset, altura], :width => self.bounds.right) do
      if venta.nombre_cliente
          formatted_text_box([{:text => "RUC o C.I. N: ", size:8, :styles => [:bold]},{:text => "#{venta.ruc_cliente}", size:8} ])
      else
          formatted_text_box([{:text => "RUC o C.I. N: ", size:8, :styles => [:bold]},{:text => "#{venta.cliente.ruc}", size:8} ])
      end
    end

    move_down 5.mm
    altura = cursor

    if venta.nombre_cliente or venta.cliente.direccion.nil? or venta.cliente.direccion.empty?
        #formatted_text_box([{:text => "Dirección: ", size:8, :styles => [:bold]}, {:text => "-", size:8} ])
    else
        direccion = venta.cliente.direccion
    end
    #bounding_box([offset, altura], :width => self.bounds.right) do
    #    formatted_text_box([{:text => "Dirección: ", size:8, :styles => [:bold]}, {:text => "#{direccion}", size:8} ])
    #end

    if venta.nombre_cliente or venta.cliente.telefono.nil? or venta.cliente.telefono.empty?
        telefono = "-"
    else
        telefono = venta.cliente.telefono
    end
    bounding_box([offset, altura], :width => self.bounds.right) do
      formatted_text_box([{:text => "Teléfono: ", size:8, :styles => [:bold]}, {:text => "#{telefono}", size:8} ])
    end

    move_down 5.mm
    altura = cursor

    if !venta.vendedor.nil?
      nombre_vendedor = venta.vendedor.nombre + ' ' + venta.vendedor.apellido
    else
      nombre_vendedor = ""
    end

    bounding_box([offset, altura], :width => self.bounds.right) do
      formatted_text_box([{:text => "Vendedor: ", size:8, :styles => [:bold]}, {:text => "#{nombre_vendedor}", size:8} ])
    end

    move_down 10.mm
    altura = cursor
    
    dibujar_detalles(venta,offset,altura) 


    move_down 10.mm
    altura = cursor

    subtotal_exentas = 0
    subtotal_iva5 = 0
    subtotal_iva10 = 0
    
    venta.venta_detalles.map do |detalle|
      if detalle.producto.iva.eql? 0.0
        subtotal_exentas += detalle.subtotal
      end
      if detalle.producto.iva.eql? 5.0
        subtotal_iva5 += detalle.subtotal
      end
      if detalle.producto.iva.eql? 10.0
        subtotal_iva10 += detalle.subtotal
      end
    end

    subtotal_exentas = subtotal_exentas - venta.descuento_redondeo



    if not venta.descuento_redondeo.nil? and not venta.descuento_redondeo.eql? 0.0
      bounding_box([offset,altura], :width => self.bounds.right) do
        formatted_text_box([{:text => "Descuento General: ", size:8, :styles => [:bold]}, {:text => "#{to_Gs((-venta.descuento_redondeo).round(decimales))}", size:8} ])
      end
    # else
    #   bounding_box([offset,altura], :width => self.bounds.right) do
    #     formatted_text_box([{:text => "Descuento General: ", size:8, :styles => [:bold]}, {:text => "-", size:8} ])
    #   end
    end


    move_down 6.mm
    altura = cursor

    # pos_exentas = offset
    # pos_iva5 = 50.mm + offset  
    # pos_iva10 = 100.mm + offset 


    # bounding_box([pos_exentas, altura], :width => self.bounds.right) do
    #   formatted_text_box([{:text => "Subtotal Exentas: ", size:8, :styles => [:bold]}, {:text => "#{to_Gs((subtotal_exentas).round(decimales))}", size:8} ])
    # end

    # bounding_box([pos_iva5, altura], :width => self.bounds.right) do
    #   formatted_text_box([{:text => "Subtotal IVA 5%: ", size:8, :styles => [:bold]}, {:text => "#{to_Gs((subtotal_iva5).round(decimales))}", size:8} ])
    # end

    # bounding_box([pos_iva10, altura], :width => self.bounds.right) do
    #   formatted_text_box([{:text => "Subtotal IVA 10%: ", size:8, :styles => [:bold]}, {:text => "#{to_Gs((subtotal_iva10).round(decimales))}", size:8} ])
    # end
    
    # move_down 6.mm
    # altura = cursor 

    total_a_pagar = (subtotal_exentas + subtotal_iva5 + subtotal_iva10).round(decimales)
    parte_entera_en_letras = numero_a_palabras(Integer(total_a_pagar)).upcase
    parte_decimal = Integer((total_a_pagar - Integer(total_a_pagar)) * 100)
    
    total_en_letras = to_Gs(total_a_pagar.round(decimales)).to_s + " (" + parte_entera_en_letras
    if(!venta.moneda.redondeo)
      parte_decimal_en_letras = numero_a_palabras(parte_decimal).upcase
      if(parte_decimal > 0)
        total_en_letras = total_en_letras + " CON " + parte_decimal_en_letras + " CENTAVOS"
      end

    end
    total_en_letras = total_en_letras + ")"
    bounding_box([offset, altura], :width => self.bounds.right) do
        formatted_text_box([{:text => "Total a pagar: ", size:8, :styles => [:bold]}, {:text => "#{total_en_letras}", size:8} ])
    end

    move_down 6.mm
    altura = cursor

    # total_iva = venta.iva5 + venta.iva10
    # bounding_box([pos_exentas, altura], :width => self.bounds.right) do
    #   formatted_text_box([{:text => "Liquidación del IVA 5%: ", size:8, :styles => [:bold]}, {:text => "#{to_Gs((venta.iva5).round(decimales))}", size:8} ])
    # end

    # bounding_box([pos_iva5, altura], :width => self.bounds.right) do
    #   formatted_text_box([{:text => "Liquidación del IVA 10%: ", size:8, :styles => [:bold]}, {:text => "#{to_Gs((venta.iva10).round(decimales))}", size:8} ])
    # end

    # bounding_box([pos_iva10, altura], :width => self.bounds.right) do
    #   formatted_text_box([{:text => "Total IVA: ", size:8, :styles => [:bold]}, {:text => "#{to_Gs((total_iva).round(decimales))}", size:8} ])
    # end
  end

  def dibujar_detalles(venta,offset,altura)
    ancho = 155.mm
    puts @color_texto
    bounding_box([offset,altura], :width=> self.bounds.right) do 
      table detalles_rows (venta)  do
        row(0).font_style = :bold
        row(0).text_color = '3E4D4A'
        self.header = true
        self.cell_style = {size:8}
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [(ancho / 2.5), (ancho / 9.5), (ancho / 6.7),  (ancho / 6.7)]
      end
    end
  end
  
  def detalles_rows(venta)
    [['Producto', 'Cantidad','Precio', 'Valor de Venta']] +
      venta.venta_detalles.map do |detalle|
        [detalle.producto.descripcion, detalle.cantidad, to_Gs(detalle.subtotal / detalle.cantidad), to_Gs(detalle.subtotal)]
      end
  end





  def numero_a_palabras(numero)
    de_tres_en_tres = numero.to_i.to_s.reverse.scan(/\d{1,3}/).map{|n| n.reverse.to_i}
   
    millones = [
      {true => nil, false => nil},
      {true => 'millon', false => 'millones'},
      {true => "billon", false => "billones"},
      {true => "trillon", false => "trillones"}
    ]
   
    centena_anterior = 0
    contador = -1
    palabras = de_tres_en_tres.map do |numeros|
      contador += 1
      if contador%2 == 0
        centena_anterior = numeros
        [centena_a_palabras(numeros), millones[contador/2][numeros==1]].compact if numeros > 0
      elsif centena_anterior == 0
        [centena_a_palabras(numeros), "mil", millones[contador/2][false]].compact if numeros > 0
      else
        [centena_a_palabras(numeros), "mil"] if numeros > 0
      end
    end
 
    palabras.compact.reverse.join(' ')
  end 
 
  def centena_a_palabras(numero)
    especiales = {
      11 => 'once', 12 => 'doce', 13 => 'trece', 14 => 'catorce', 15 => 'quince',
      10 => 'diez', 20 => 'veinte', 100 => 'cien'
    }
    if especiales.has_key?(numero)
      return especiales[numero]
    end
   
    centenas = [nil, 'ciento', 'doscientos', 'trescientos', 'cuatrocientos', 'quinientos', 'seiscientos', 'setecientos', 'ochocientos', 'novecientos']
    decenas = [nil, 'dieci', 'veinti', 'treinta', 'cuarenta', 'cincuenta', 'sesenta', 'setenta', 'ochenta', 'noventa']
    unidades = [nil, 'un', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho', 'nueve']
   
    centena, decena, unidad = numero.to_s.rjust(3,'0').scan(/\d/).map{|i| i.to_i}
   
    palabras = []
    palabras << centenas[centena]
   
    if especiales.has_key?(decena*10 + unidad)
      palabras << especiales[decena*10 + unidad]
    else
      tmp = "#{decenas[decena]}#{' y ' if decena > 2 && unidad > 0}#{unidades[unidad]}"
      palabras << (tmp.blank? ? nil : tmp)
    end
   
    palabras.compact.join(' ')
  end

  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end
end