# encoding: utf-8
class Compra < ActiveRecord::Base

  attr_accessor :periodos

  scope :by_proveedor_id, -> proveedor_id { where("proveedor_id = ?", "#{proveedor_id}") }
  scope :by_sucursal_id, -> sucursal_id { where("sucursal_id = ?", "#{sucursal_id}") }
  scope :by_campanha_id, -> campanha_id { where("campanha_id = ?", "#{campanha_id}") }
	scope :by_empresa_id, -> empresa_id {joins(:sucursal).where("sucursales.empresa_id = ?", "#{empresa_id}" )}
	scope :by_deposito_id, -> deposito_id { where("deposito_id = ?", "#{deposito_id}" )}
  scope :by_nro_factura, -> nro_factura { where("nro_factura = ?", "#{nro_factura}") }
  scope :by_credito, -> credito { where("credito = ?", "#{credito}") }
  scope :by_tipo_credito_id, -> tipo_credito_id { where("tipo_credito_id = ?", "#{tipo_credito_id}") }
  scope :by_fecha_registro_before, -> before{ where("fecha_registro::date < ?", Date.parse(before)) }
  scope :by_fecha_registro_on, -> on { where("fecha_registro::date = ?", Date.parse(on)) }
  scope :by_fecha_registro_after, -> after { where("fecha_registro::date > ?", Date.parse(after)) }
  scope :by_total_gt, -> gt { where("total > ?", gt) }
  scope :by_total_eq, -> eq { where("total = ?", eq) }
  scope :by_total_lt, -> lt { where("total < ? ", lt) }
  scope :by_muestra_pagado, ->value { where("pagado = ?",value)}
  scope :by_donacion, -> value { where("donacion = ?",value)}


	scope :by_codigo_barra, -> codigo_barra {
    joins(:compra_detalles => :producto).where("productos.codigo_barra ilike ?", "%#{codigo_barra}%")}
  scope :by_all_attributes, -> value { joins(:proveedor).joins(:sucursal).
    where("proveedores.razon_social ilike ? OR nro_factura ilike ? OR sucursales.descripcion ilike ? OR to_char(fecha_registro, 'DD/MM/YYYY') ilike ?" ,
          "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%")
  }
  #default_scope { where(estado_valido: true) }

  scope :sucursal, -> sucursal { where("sucursal_id = ?", "#{sucursal}") }
	has_many :pagos, :dependent => :destroy
  belongs_to :sucursal
  belongs_to :proveedor
  belongs_to :tipo_credito
  belongs_to :deposito
  belongs_to :campanha
  belongs_to :sponsor
  belongs_to :moneda
  belongs_to :cotizacion
  has_many :compra_detalles, :dependent => :destroy
  has_many :compra_cuotas, :dependent => :destroy
  default_scope order("updated_at DESC")

  attr_accessor :razon_social_proveedor

  def razon_social_proveedor
    if !proveedor.nil?
      return proveedor.razon_social

    end
  end

  def guardar
    transaction(requires_new: true) do

      if !save
        raise ActiveRecord::Rollback
      end


      #if(pagado)
      #  generarDebitoSesionCaja()
      #end

      if(credito)

        if(cantidad_cuotas <= 0)
          self.errors[:base] << "La cantidad de cuotas debe ser mayor a cero"
        end
        if not periodos.nil?
          generarCuotas()
        else
          self.errors[:base] << "Debe completar correctamente los pagos según la cantidad de cuotas"
        end
      end

      compra_detalles.each do |detalle|
        begin
          detalle.save!

          Precio.crearHistorialPrecio(fecha_registro, detalle)

            #if(!detalle.lote.nil?)
            if(detalle.producto.tipo_producto.stock)
                Producto.actualizar_stock_lote!(detalle.lote, deposito_id,detalle.cantidad,detalle.contenedor)
            end
            #else
            #  Producto.actualizar_stock!(detalle.producto_id, deposito_id, detalle.cantidad)
            #end

          Producto.actualizarPrecio(detalle.compra_id,
                                    detalle.producto_id,
                                    detalle.precio_compra,
                                    detalle.precio_venta)

        rescue ActiveRecord::RecordInvalid
          self.errors[:base] << "No existe stock suficiente en deposito para descontar"
        end
      end
      if !self.errors[:base].empty?
        raise ActiveRecord::Rollback
      end
    end
  end


  def imprimirRetencion(caja_imp)
    puts '---Dentro de imprimirRetencion---'
    pdf = RetencionReportPdf.new(self)

    codigo = Settings.printers.codigo_retencion
    if caja_imp
        impresora = Impresora.where("tipo_documento='retencion' AND caja_impresion_id=?", caja_imp.id).first
        puts "---Impresora: " + impresora.nombre + "---"
    end
    unless impresora
        #Si no se encuentra la impresora específica se usa la default
        console.log("------------------no se encontró impresora y se vino por la default----------------")
        impresora = Impresora.where("tipo_documento='default'").first
    end
    begin
      PrinterService.new(impresora, pdf)
    rescue => e
      puts "======================================="
      logger.warn "Error al intentar imprimir: #{e}"
      puts "======================================="
    end

  end

  def eliminar
    transaction do
      #if(pagado)
      #  generarCreditoSesionCaja()
      #end

      if(credito)
        #generarCreditoCuotasPagadas()
      end

      #borra el historial de precios
      actualizarPrecios()

      #Actualizar Stock por detalle
      @detalles = CompraDetalle.where("compra_id = ?", id)
      @detalles.each do |det|
        begin
          Producto.actualizar_stock!(det.lote_id, deposito_id,-det.cantidad)
          Producto.actualizarPrecioPromedio(det.producto_id)
        rescue ActiveRecord::RecordInvalid
          self.errors[:base] << "No existe stock suficiente en deposito para descontar"
        end
      end

      if !self.errors[:base].empty?
        raise ActiveRecord::Rollback
      end

      if !destroy
        raise ActiveRecord::Rollback
      end

    end
  end

  def generarCreditoCuotasPagadas()
    @compra_cuotas = CompraCuota.where("compra_id = ?", id)

    observacion = 'BORRADO de Compra #' + id.to_s + '#' + " Factura Nro: "
    if(nro_factura || nro_factura == '')
      observacion += nro_factura
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
          generarCredito(monto,obs,sucursal_id,fecha_registro)
        end
      end
    end
  end

  def generarDebitoSesionCaja


    observacion = 'Compra #' + id.to_s + '#' + "Factura Nro: "
    if(nro_factura || nro_factura == '')
      observacion += nro_factura
    else
      observacion += "--"
    end
    #SesionCaja.generarDebitoCompra(total,observacion,sucursal_id,fecha_registro)
  end

  def generarCreditoSesionCaja
    observacion = 'BORRADO o Cancelacion de Pago de Compra #' + id.to_s + '#' + " Factura Nro: "
    if(nro_factura || nro_factura == '')
      observacion += nro_factura
    else
      observacion += "--"
    end

    #SesionCaja.generarCredito(total,observacion,sucursal_id,fecha_registro)

  end

  def actualizarPrecios()
    @detalles = CompraDetalle.where("compra_id = ?", id)
    @detalles.each do |det|
       @precio = Precio.where("compra_detalle_id = ? ", det.id).first
       @precio.destroy
    end
  end

  def generarRangoPagos(cantidad_cuotas,pagos)
    puts " ******************************* cant pagos // #{cantidad_cuotas} #{pagos}"
    detalles = pagos.split(' ')
    if(cantidad_cuotas != detalles.length)
      self.errors[:base] << "Debe completar correctamente los pagos según la cantidad de cuotas"
    end
    return detalles
  end

  def generarCuotas
    if cantidad_cuotas >= 1
      detallesCuotas = generarRangoPagos(cantidad_cuotas,periodos)
      fechaVencimiento = fecha_registro
      tipoCredito = TipoCredito.find(tipo_credito_id)
      if tipoCredito
        #Calculo del interes
        totalMasInteres = total
        #actualizar dedua
        #@venta.update(deuda: totalMasInteres)
        puts "totalMasInteres: #{totalMasInteres}  -- cantidad_cuotas: #{cantidad_cuotas}"
        montoCuota = (totalMasInteres / cantidad_cuotas).round
        diff = totalMasInteres - (montoCuota * cantidad_cuotas)

        for i in 1..cantidad_cuotas
          fechaVencimiento = fecha_registro
          puts " ******************************* detallesCuotas #{detallesCuotas}"
          for j in 1..(tipoCredito.plazo * detallesCuotas[i-1].to_i)
            fechaVencimiento = fechaVencimiento + TipoCredito.unidades[tipoCredito.unidad_tiempo]

          end
          #Agrega la diferencia faltante
          if i == cantidad_cuotas and diff != 0
            montoCuota = montoCuota + diff
          end

          compraCuota = CompraCuota.new(compra_id: id, nro_cuota: i,  monto: montoCuota,
            fecha_vencimiento: fechaVencimiento, cancelado: false, estado: Settings.estadosCuotas.pendiente)
          compraCuota.save
        end

      else
        puts "Advertencia, no existe el tipoCredito"
      end
    end
  end

	def deuda
		acumulado = 0
		if (not compra_cuotas.nil?)
			compra_cuotas.each do |cuota|
				acumulado = acumulado + cuota.pendiente
			end
		end
		return acumulado
	end
end
