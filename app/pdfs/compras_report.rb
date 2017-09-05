# encoding: utf-8
class ReportPdf < Prawn::Document
  def initialize(compras,campanha_id,donacion)
      puts compras.to_yaml
    super()
    font_size 9
    @color_texto = '3E4D4A'
    @monto_total_gs = 0
    @monto_iva_5_gs = 0
    @monto_iva_10_gs = 0
    @monto_por_cobrar_gs = 0

    @monto_total_usd = 0
    @monto_iva_5_usd = 0
    @monto_iva_10_usd = 0
    @monto_por_cobrar_usd = 0

    @compras = compras
    header(campanha_id,donacion)
    @compras.map do |compra|
        if(compra.iva5.nil?)
            compra.iva5 = 0
        end
        if(compra.iva10.nil?)
            compra.iva10 = 0
        end

        if compra.moneda.simbolo.eql? "Gs."
          @moneda_gs = compra.moneda
          @monto_total_gs = @monto_total_gs + compra.total
          @monto_iva_5_gs = @monto_iva_5_gs + compra.iva5
          @monto_iva_10_gs = @monto_iva_10_gs + compra.iva10
          @monto_por_cobrar_gs = @monto_por_cobrar_gs + compra.deuda
        elsif compra.moneda.simbolo.eql? "US$"
          @moneda_usd = compra.moneda
          @monto_total_usd = @monto_total_usd + compra.total
          @monto_iva_5_usd = @monto_iva_5_usd + compra.iva5
          @monto_iva_10_usd = @monto_iva_10_usd + compra.iva10
          @monto_por_cobrar_usd = @monto_por_cobrar_usd + compra.deuda
        end
      dibujar_compra compra
    end

    if @monto_total_gs > 0
      sumarizado(@moneda_gs)
    end
    if @monto_total_usd > 0
      sumarizado(@moneda_usd)
    end
    footer
  end

  def header(campanha_id,donacion)
    stroke_horizontal_rule

    bounding_box([0,cursor], :width => self.bounds.right) do

      pad(20){
        text "Geppii", size: 15, style: :bold, :align => :center

        text "Reporte de Ingresos", :align => :center
        if campanha_id
          campanha = Campanha.find(Integer(campanha_id))
          text "Campaña: #{campanha.nombre}", :align => :center
        end
        if to_boolean(donacion)
          text "Ingreso Donado", :align => :center
        end
        time = Time.now.strftime("%d/%m/%Y")
        text "Fecha: #{time}", :align => :center
      }
    end
    stroke_horizontal_rule
  end


  def dibujar_compra (compra)
    move_down 30
    if cursor <80
      start_new_page
    end

    altura = cursor

    #Se ubica esta columna primero ya que va a ser mas corta que la segunda columna
    #Como el cursor debe quedar en el punto mas bajo para poder seguir insertando bien los elementos,
    #la columna que va mas hasta abajo debe ser la ultima en insertarse para poder garantizar que el
    #cursor quede en buena posicion
    pagadoTemp = compra.pagado
    if pagadoTemp == true
      pagadoTemp = "Si"
    else
      pagadoTemp = "No"
    end
    bounding_box([(self.bounds.right / 3.0) + 20, altura], :width => self.bounds.right / 3.0) do
      formatted_text [ { :text => "Pagado: ", :color => @color_texto }, { :text => pagadoTemp}]
			 formatted_text [ { :text => "Deposito: ", :color => @color_texto }, { :text => "#{compra.deposito.nombre}"}]
      formatted_text [ { :text => "Fecha de registro: ", :color => @color_texto }, { :text => "#{compra.fecha_registro.strftime("%d/%m/%Y")}"}]
      formatted_text [ { :text => "IVA 5%: ", :color => @color_texto }, { :text => "#{compra.iva5}"}]
      if compra.moneda.simbolo.eql? "US$"
        formatted_text [ { :text => "IVA 10%: ", :color => @color_texto }, { :text => "#{to_USD(compra.iva10)}"}]
        formatted_text [ { :text => "Total: ", :color => @color_texto }, { :text => "#{to_USD(compra.total)}"}]
      elsif compra.moneda.simbolo.eql? "Gs."
        formatted_text [ { :text => "IVA 10%: ", :color => @color_texto }, { :text => "#{to_Gs(compra.iva10)}"}]
        formatted_text [ { :text => "Total: ", :color => @color_texto }, { :text => "#{to_Gs(compra.total)}"}]
      end
      formatted_text [ { :text => "Moneda: ", :color => @color_texto }, { :text => "#{compra.moneda.nombre}"}]
    end

    bounding_box([0, altura], :width => (self.bounds.right / 3.0)) do
      formatted_text [ { :text => "Factura: ", :color => @color_texto }, { :text => "#{compra.nro_factura}"}]
			formatted_text [ { :text => "Empresa: ", :color => @color_texto }, { :text => "#{compra.sucursal.empresa.nombre}"}]
      formatted_text [ { :text => "Sucursal: ", :color => @color_texto }, { :text => "#{compra.sucursal.descripcion}"}]
      formatted_text [ { :text => "Proveedor: ", :color => @color_texto }, { :text => "#{compra.proveedor.razon_social if !compra.proveedor.nil?}"}]
      formatted_text [ { :text => "RUC: ", :color => @color_texto }, { :text => "#{compra.proveedor.ruc if !compra.proveedor.nil?}"}]
      if compra.credito
        formatted_text [ { :text => "Tipo de compra: ", :color => @color_texto }, { :text => "Crédito"}]
        if (compra.tipo_credito)
          formatted_text [ { :text => "Tipo crédito: ", :color => @color_texto }, { :text =>"#{compra.tipo_credito.descripcion}"}]
        end
        formatted_text [ { :text => "Cantidad de cuotas: ", :color => @color_texto }, { :text => "#{compra.cantidad_cuotas}"}]
        formatted_text [ { :text => "Deuda: ", :color => @color_texto }, { :text => "#{compra.deuda}"}]
      elsif compra.donacion
        formatted_text [ { :text => "Tipo de compra: ", :color => @color_texto }, { :text => "Donación"}]
      else
        formatted_text [ { :text => "Tipo de compra: ", :color => @color_texto }, { :text => "Contado"}]
      end
      if !compra.campanha_id.nil?
        formatted_text [ { :text => "Campaña: ", :color => @color_texto }, { :text => "#{compra.campanha.nombre}"}]
      end
    end
    move_down 5.mm



    dibujar_detalles compra

  end

  def dibujar_detalles(compra)
    ancho = self.bounds.right
    puts @color_texto
    table detalles_rows compra do
      row(0).font_style = :bold
      row(0).text_color = '3E4D4A'
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [(ancho / 3.0), (ancho / 3.0), (ancho / 3.0)]
    end
  end

  def detalles_rows(compra)
    [['Producto', 'Cantidad', 'Precio']] +
    if compra.moneda.simbolo.eql? "US$"
      compra.compra_detalles.map do |detalle|
        [detalle.producto.descripcion, detalle.cantidad, to_USD(detalle.precio_compra)]
      end
    elsif compra.moneda.simbolo.eql? "Gs."
      compra.compra_detalles.map do |detalle|
        [detalle.producto.descripcion, detalle.cantidad, to_Gs(detalle.precio_compra)]
      end
    end

  end

  def sumarizado(moneda)
    move_down 30
    if cursor <80
      start_new_page
    end
    formatted_text [ { :text => "Datos sumarizados (#{moneda.nombre})", :color => @color_texto }]
    ancho = self.bounds.right
    puts @color_texto
    if moneda.simbolo.eql? "US$"
      table sumarizado_row do
        row(0).font_style = :bold
        row(0).text_color = '3E4D4A'
        self.header = true
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [(ancho / 4.0), (ancho / 4.0), (ancho / 4.0),  (ancho / 4.0)]
      end
    elsif moneda.simbolo.eql? "Gs."
      table sumarizado_row_gs do
        row(0).font_style = :bold
        row(0).text_color = '3E4D4A'
        self.header = true
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [(ancho / 4.0), (ancho / 4.0), (ancho / 4.0),  (ancho / 4.0)]
      end
    end


  end

  def sumarizado_row
    [['IVA 5%', 'IVA 10%', 'Monto a pagar', 'Monto total']] +
      [[to_USD(@monto_iva_5_usd), to_USD(@monto_iva_10_usd), to_USD(@monto_por_cobrar_usd), to_USD(@monto_total_usd)]]
  end
  def sumarizado_row_gs
    [['IVA 5%', 'IVA 10%', 'Monto a pagar', 'Monto total']] +
      [[to_Gs(@monto_iva_5_gs), to_Gs(@monto_iva_10_gs), to_Gs(@monto_por_cobrar_gs), to_Gs(@monto_total_gs)]]
  end
  def to_Gs(int)
    return ActionController::Base.helpers.number_to_currency(int.to_i, precision: 0, unit: "",  separator: ",", delimiter: ".")
  end
  def to_USD(monto)
    return ActionController::Base.helpers.number_to_currency(monto, precision: 2, unit: "",  separator: ".", delimiter: ",")
  end

  def to_boolean(str)
    str == 'true'
  end

  def footer
    page_count.times do |i|
      go_to_page(i+1)
      bounding_box([bounds.right-50, bounds.bottom + 25], :width => 50) {text "#{i+1} / #{page_count}"}
    end
  end
end
