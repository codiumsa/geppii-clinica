class API::V1::ComprasController < ApplicationController
  respond_to :json
  # before_filter :ensure_authenticated_user
  # before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_compras" end
  # before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_compras" end
  # before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_compras" end
  # before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_compras" end
  # before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_compras" end

  PER_PAGE_RECORDS = 15

  has_scope :by_proveedor_id
  has_scope :by_sucursal_id
	has_scope :by_empresa_id
	has_scope :by_deposito_id
  has_scope :by_campanha_id
  has_scope :by_nro_factura
  has_scope :by_credito
  has_scope :by_tipo_credito_id
  has_scope :by_fecha_registro_before
  has_scope :by_fecha_registro_after
  has_scope :by_fecha_registro_on
  has_scope :by_total_gt
  has_scope :by_total_lt
  has_scope :by_total_eq
  has_scope :by_all_attributes, allow_blank: true
  has_scope :sucursal
  has_scope :by_codigo_barra
	has_scope :by_donacion

  def index

    tipo = params[:content_type]
    if tipo.eql? "pdf"
      #require 'compras_report.rb'
      @compras = apply_scopes(Compra).order(:fecha_registro).reverse_order
      pdf = ReportPdf.new(@compras,params[:by_campanha_id], params[:by_donacion])
      send_data pdf.render, filename: 'reporte_ingresos.pdf', type: 'application/pdf', disposition: 'attachment'
    else
      if tipo.eql? "retencion"
        @compras = Compra.find(params[:compra_id])
        pdf = RetencionReportPdf.new(@compras)
        send_data pdf.render, filename: 'retencion.pdf', type: 'application/pdf', disposition: 'attachment'
      else
        @compras = apply_scopes(Compra).page(params[:page]).per(PER_PAGE_RECORDS)

        if @compras.count > 0
          render json: @compras, each_serializer: CompraSerializer, meta: {total: apply_scopes(Compra).all.count, total_pages: @compras.num_pages}
        else
          render json: @compras, each_serializer: CompraSerializer
        end
      end
    end
  end

  def show
    respond_with Compra.find(params[:id])
  end

  def new
    respond_with Compra.new
  end

  def create
    #compra_inner_params.delete()

    puts "------ create params-----------------------"
    puts compra_inner_params
    @compra = Compra.new(compra_inner_params)

    detalles = []

    if(not params[:compra][:compra_detalles].nil?)
      params[:compra][:compra_detalles].each do |detalle_params|
          if(detalle_params[:codigo_lote]) #si trae codigo de lote
              lote = Lote.by_codigo(detalle_params[:codigo_lote])
              if(lote.length == 0) # si el lote no existe
                  @loteNew = Lote.new(codigo_lote: detalle_params[:codigo_lote], producto_id: detalle_params[:producto_id],
                                      fecha_vencimiento: detalle_params[:fecha_vencimiento])
                  @loteNew.save
                  if(!detalle_params[:codigo_contenedor].nil?) # se crea nuevo lote y si se envio codigo de contenedor
                    container = Contenedor.by_codigo(detalle_params[:codigo_contenedor])
                      if(container.length == 0)  # si el contenedor no existe se crea un nuevo
                        @containerNew = Contenedor.new(codigo: detalle_params[:codigo_contenedor], nombre: detalle_params[:codigo_contenedor])
                          @containerNew.save
                        @detalle_compra = CompraDetalle.new(producto_id: detalle_params[:producto_id],
                                                cantidad: detalle_params[:cantidad],
                                                precio_compra: detalle_params[:precio_compra],
                                                precio_venta: detalle_params[:precio_venta],
                                                precio_promedio: detalle_params[:precio_promedio],
                                                lote_id: @loteNew.id,
                                                contenedor_id: @containerNew.id)
                      else #si el contenedor existe se agrega simplemente el id en compra detalle
                           @detalle_compra = CompraDetalle.new(producto_id: detalle_params[:producto_id],
                                                    cantidad: detalle_params[:cantidad],
                                                    precio_compra: detalle_params[:precio_compra],
                                                    precio_venta: detalle_params[:precio_venta],
                                                    precio_promedio: detalle_params[:precio_promedio],
                                                    lote_id: @loteNew.id,
                                                    contenedor_id: container.first.id)
                      end

                  else #si no se envio codigo de contenedor
                                                 @detalle_compra = CompraDetalle.new(producto_id: detalle_params[:producto_id],
                                                    cantidad: detalle_params[:cantidad],
                                                    precio_compra: detalle_params[:precio_compra],
                                                    precio_venta: detalle_params[:precio_venta],
                                                    precio_promedio: detalle_params[:precio_promedio],
                                                    lote_id: @loteNew.id)
                  end
              else # si el lote existe
                  if(!detalle_params[:codigo_contenedor].nil?) # si se envio codigo de contenedor
                    container = Contenedor.by_codigo(detalle_params[:codigo_contenedor])
                      if(container.length == 0) #si el contenedor no existe se crea
                        @containerNew = Contenedor.new(codigo: detalle_params[:codigo_contenedor], nombre: detalle_params[:codigo_contenedor])
                        @containerNew.save
                        @detalle_compra = CompraDetalle.new(producto_id: detalle_params[:producto_id],
                                                cantidad: detalle_params[:cantidad],
                                                precio_compra: detalle_params[:precio_compra],
                                                precio_venta: detalle_params[:precio_venta],
                                                precio_promedio: detalle_params[:precio_promedio],
                                                lote_id: lote.first.id,
                                                contenedor_id: @containerNew.id)
                      else # si ya existe se agrega a compra detalle el id
                           @detalle_compra = CompraDetalle.new(producto_id: detalle_params[:producto_id],
                                                    cantidad: detalle_params[:cantidad],
                                                    precio_compra: detalle_params[:precio_compra],
                                                    precio_venta: detalle_params[:precio_venta],
                                                    precio_promedio: detalle_params[:precio_promedio],
                                                    lote_id: lote.first.id,
                                                    contenedor_id: container.first.id)
                      end
                  else #si no se envio codigo de contenedor
                                                 @detalle_compra = CompraDetalle.new(producto_id: detalle_params[:producto_id],
                                                    cantidad: detalle_params[:cantidad],
                                                    precio_compra: detalle_params[:precio_compra],
                                                    precio_venta: detalle_params[:precio_venta],
                                                    precio_promedio: detalle_params[:precio_promedio],
                                                    lote_id: lote.first.id)
                  end
              end
          else #si no se trajo codigo de lote se crean los detalles normalmente
            @productoTemp = Producto.find(detalle_params[:producto_id])
             @loteNew = Lote.where("codigo_lote ilike ?", "loteUnico#{@productoTemp.id}").first
            if(!@loteNew.nil?)
                @detalle_compra = CompraDetalle.new(producto_id: detalle_params[:producto_id],
                                                    cantidad: detalle_params[:cantidad],
                                                    precio_compra: detalle_params[:precio_compra],
                                                    precio_venta: detalle_params[:precio_venta],
                                                    precio_promedio: detalle_params[:precio_promedio],
                                                    lote_id: @loteNew.id)
            else
              @loteNew = Lote.new(codigo_lote: "loteUnico#{@productoTemp.id}", producto_id: detalle_params[:producto_id])
              @loteNew.save
              @detalle_compra = CompraDetalle.new(producto_id: detalle_params[:producto_id],
                                                  cantidad: detalle_params[:cantidad],
                                                  precio_compra: detalle_params[:precio_compra],
                                                  precio_venta: detalle_params[:precio_venta],
                                                  precio_promedio: detalle_params[:precio_promedio],
                                                  lote_id: @loteNew.id)
            end
          end
          detalles.push(@detalle_compra)
        end
    end


    @compra.compra_detalles = detalles
    @compra.guardar

    if(!compra_params[:pagado].nil? || compra_params[:pagado] == true)
      if(!compra_params[:nro_cheque].nil?)
        @cuenta = Cuenta.where("nro_cuenta ilike ? AND moneda_id = ? AND banco ilike ?", "#{compra_params[:nro_cuenta]}", compra_params[:moneda_id], "#{compra_params[:banco]}")
        if @cuenta.first.nil?
          @cuenta = Cuenta.new(nro_cuenta: compra_params[:nro_cuenta], moneda_id: compra_params[:moneda_id], banco: compra_params[:banco])
          @cuenta.save!
          @compra_medio = CompraMedio.new(compra_id: @compra.id,
                                        cuenta_id: @cuenta.id,
                                        tarjeta_id: compra_params[:tarjeta_id],
                                        medio_pago_id: compra_params[:medio_pago_id],
                                        nro_cheque: compra_params[:nro_cheque])

        else
          @compra_medio = CompraMedio.new(compra_id: @compra.id,
                                        cuenta_id: @cuenta.first.id,
                                        tarjeta_id: compra_params[:tarjeta_id],
                                        medio_pago_id: compra_params[:medio_pago_id],
                                        nro_cheque: compra_params[:nro_cheque])
        end
      else
        @compra_medio = CompraMedio.new(compra_id: @compra.id,
                                      tarjeta_id: compra_params[:tarjeta_id],
                                      medio_pago_id: compra_params[:medio_pago_id])
      end
      @compra_medio.save!
    end

    if(compra_params[:sponsor_id])
      contacto = Contacto.by_campanha(compra_params[:campanha_id]).by_sponsor(compra_params[:sponsor_id]).first
      puts "entra sponsor id"
      puts "contacto #{contacto.to_yaml}"
      @contacto_detalle = ContactoDetalle.new(contacto_id: contacto.id,
                                              compromiso: @compra.total,
                                              estado: "Recibido",
                                              moneda_id: @compra.moneda_id,
                                              fecha: compra_params[:fecha_registro])
     @contacto_detalle.save!

    end

    if (ParametrosEmpresa.default_empresa().first.soporta_cajas && genera_movimiento && @compra.credito = false)
      puts "Caja: #{current_caja.id} TipoOperacion: #{Settings.cajas.tipos_operaciones.compra}, Compra: #{@compra}, Compra Moneda: #{@compra.moneda}"
      Operacion.generarOperacion(current_caja.id, Settings.cajas.tipos_operaciones.compra, nil, @compra.id, @compra.total, @compra.moneda.id, current_sucursal)
    end


    imprimirRetencion = params[:compra][:imprimir_retencion]
    puts '--------------------SIN RETEncion NEW--------------------'
    puts imprimirRetencion
      if imprimirRetencion
        puts '--------------------SE INTENTA IMPRIMIR RETEncion--------------------'
        if @compra.retencioniva > 0
            puts '------------------------RETENCION DE IVA > 0-------------------'
          if current_caja_impresion
                puts '---------------Invocacion a @compra.imprimirRetencion current_caja_impresion---------------'
                @compra.imprimirRetencion current_caja_impresion
          else
              puts '------------no se soporta caja de impresion---------------------'
          end
        else
            puts '------------------------RETENCION DE IVA = 0-------------------'
        end
      end

    respond_with @compra
  end

  def update
    @compra = Compra.unscoped.find_by(id: params[:id])
    if @compra.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      pagado = params[:compra][:pagado]
      if not @compra.pagado &&  pagado#Se pago
        Compra.transaction do
          @compra.update_attributes(compra_inner_params)
          @compra.generarDebitoSesionCaja()
        end
      elsif not pagado && @compra.pagado #Se cancelo pago
        Compra.transaction do
          @compra.update_attributes(compra_inner_params)
          @compra.generarCreditoSesionCaja()
        end
      else

        @compra.update_attributes(compra_inner_params)
      end

      imprimirRetencion = params[:compra][:imprimir_retencion]
      puts '--------------------SIN RETEncion EDIT--------------------'
      puts imprimirRetencion
      if imprimirRetencion
        puts '--------------------SE INTENTA IMPRIMIR RETEncion--------------------'
        if @compra.retencioniva > 0
            puts '------------------------RETENCION DE IVA > 0-------------------'
          if current_caja_impresion
                puts '---------------Invocacion a @compra.imprimirRetencion current_caja_impresion---------------'
                @compra.imprimirRetencion current_caja_impresion
          else
              puts '------------no se soporta caja de impresion---------------------'
          end
        else
            puts '------------------------RETENCION DE IVA = 0-------------------'
        end
      end
			if ParametrosEmpresa.default_empresa().first.soporta_cajas
        op_anterior = Operacion.get_operacion_by_referencia(@compra, Settings.cajas.tipos_operaciones.compra)
  			if (op_anterior)
          Operacion.reversarOperacion(op_anterior, current_sucursal)
          Operacion.generarOperacion(current_caja.id, Settings.cajas.tipos_operaciones.compra, nil, @compra.id, @compra.total, @compra.moneda.id, current_sucursal)
        end
      end
      respond_with @compra
    end
  end

  def destroy
    @compra = Compra.find_by(id: params[:id])
    if @compra.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
			if ParametrosEmpresa.default_empresa().first.soporta_cajas
				Compra.transaction do
					op_anterior = Operacion.get_operacion_by_referencia(@compra, Settings.cajas.tipos_operaciones.compra)
					if(op_anterior)
						Operacion.reversarOperacion(op_anterior, current_sucursal)
					end
				end
			end
			@compra.eliminar
      respond_with @compra
    end
  end

  def generarCreditoSesionCaja(compra)

    observacion = 'BORRADO de Compra #' + compra.id.to_s + '#' + " Factura Nro: "
    if(compra.nro_factura || compra.nro_factura == '')
      observacion += compra.nro_factura
    else
      observacion += "--"
    end

    generarCredito(compra, compra.total, observacion)

  end

  def generarCreditoCuotasPagadas(compra)
    @compra_cuotas = CompraCuota.where("compra_id = ?", compra.id)

    observacion = 'BORRADO de Compra #' + compra.id.to_s + '#' + " Factura Nro: "
    if(compra.nro_factura || compra.nro_factura == '')
      observacion += compra.nro_factura
    else
      observacion += "--"
    end

    if(@compra_cuotas != nil)
      @compra_cuotas.each do |cuota|
        if(cuota.cancelado)
          if(cuota.nro_recibo)
            obs = observacion + " Cuota Nro:" + cuota.nro_recibo.to_s
          else
            obs = observacion + " Cuota Nro: --"
          end
          monto = cuota.monto
          generarCredito(compra,monto,obs)
        end
      end
    end
  end

  def generarCredito(compra,monto,observacion)
    @cajaChica = Caja.where("sucursal_id = ? AND tipo_caja = 'C'", current_sucursal.id).first
    @operacionCaja = OperacionCaja.where("tipo = 'Credito'").first

    @sesionCaja = SesionCaja.new(:fecha =>Time.now,
      :observacion => observacion, :monto => compra.total,
      :caja_id => @cajaChica.id, :operacion_caja_id => @operacionCaja.id)

    @sesionCaja.save
  end

  def actualizarStock(compra)
    #@detalles = CompraDetalle.where("compra_id = ?", compra.id)
    #@detalles.each do |det|
    #   @producto_sucursal = ProductoSucursal.where("producto_id = ? AND sucursal_id = ?", det.producto_id, current_sucursal.id).first
    #   @producto_sucursal.existencia =  @producto_sucursal.existencia - det.cantidad
    #   @producto_sucursal.save
       Producto.actualizar_stock(det.producto_id, current_sucursal.deposito_id,- det.cantidad)
    #end
  end

  def actualizarPrecios(compra)
    @detalles = CompraDetalle.where("compra_id = ?", compra.id)
    @detalles.each do |det|
       @precio = Precio.where("compra_detalle_id = ? ", det.id).first
       @precio.destroy
    end
  end

  def compra_params
    params.require(:compra).permit(:descuento, :total, :iva10, :iva5, :credito, :pagado,
      :cantidad_cuotas, :fecha_registro, :proveedor_id , :sucursal_id,
      :nro_factura, :tipo_credito_id, :deuda, :deposito_id, :retencioniva, :moneda_id,:sponsor_id,:campanha_id,
      :cotizacion_id, :monto_cotizacion, :periodos, :nro_cheque, :banco, :nro_cuenta, :medio_pago_id, :tarjeta_id, :donacion, :nro_orden_compra,
      compra_detalles: [:producto_id, :cantidad, :precio_compra, :precio_venta, :precio_promedio, :observacion, :codigo_lote,
                        :codigo_contenedor, :contenedor_id, :lote_id, :fecha_registro, :fecha_vencimiento])
  end

  def compra_inner_params
    params.require(:compra).permit(:descuento, :total, :iva10, :iva5, :credito, :pagado,
          :cantidad_cuotas, :fecha_registro, :proveedor_id , :sucursal_id, :periodos,:sponsor_id,:campanha_id,
          :nro_factura, :tipo_credito_id, :deuda, :deposito_id, :retencioniva, :moneda_id,:donacion, :nro_orden_compra,
          :cotizacion_id, :monto_cotizacion)
  end
end
