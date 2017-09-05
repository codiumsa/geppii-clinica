 # encoding: utf-8
class VentaCuota < ActiveRecord::Base
  belongs_to :venta
	has_many :pago_detalles, dependent: :destroy

	scope :pendientes, -> { where("estado <> ?", "#{Settings.estadosCuotas.pagada}").order(:nro_cuota) }
  scope :by_venta, -> venta_id { where("venta_id = ?", "#{venta_id}") }
	scope :by_cancelado, -> cancelado { where("cancelado = ?", "#{cancelado}") }
	scope :by_cliente_id, -> cliente_id { joins(:venta ).where("ventas.cliente_id = ?", "#{cliente_id}") }
  scope :by_cliente_nombre, -> cliente_nombre {joins(:venta => :cliente).where("clientes.nombre ilike ?", "%#{cliente_nombre}%" )}
  scope :by_cliente_apellido, -> cliente_apellido {joins(:venta => :cliente).where("clientes.apellido ilike ?", "%#{cliente_apellido}%" )}
	scope :by_cliente_ruc, -> cliente_ruc {joins(:venta => :cliente).where("clientes.ruc ilike ?", "%#{cliente_ruc}%" )}
	scope :by_empresa_id, -> empresa_id {
    joins(:venta => :sucursal).where("sucursales.empresa_id = ?", "#{empresa_id}")}
	scope :by_sucursal_id, -> sucursal_id { joins(:venta).where("ventas.sucursal_id = ?", "#{sucursal_id}") }
	scope :by_nro_factura, -> nro_factura { joins(:venta).where("ventas.nro_factura= ?", "#{nro_factura}") }

	scope :by_fecha_venta_before, -> before{ joins(:venta).where("ventas.fecha_registro::date < ?", Date.parse(before)) }
  scope :by_fecha_venta_on, -> on { joins(:venta).where("ventas.fecha_registro::date = ?", Date.parse(on)) }
  scope :by_fecha_venta_after, -> after { joins(:venta).where("ventas.fecha_registro::date > ?", Date.parse(after)) }

	scope :by_fecha_vencimiento_before, -> before{ where("fecha_vencimiento::date < ?", Date.parse(before)) }
  scope :by_fecha_vencimiento_on, -> on { where("fecha_vencimiento::date = ?", Date.parse(on)) }
  scope :by_fecha_vencimiento_after, -> after { where("fecha_vencimiento::date > ?", Date.parse(after)) }

  scope :by_fecha_cobro_before, -> before{ where("fecha_cobro::date < ?", Date.parse(before)) }
  scope :by_fecha_cobro_on, -> on { where("fecha_cobro::date = ?", Date.parse(on)) }
  scope :by_fecha_cobro_after, -> after { where("fecha_cobro::date > ?", Date.parse(after)) }

  scope :by_venta_anulada, -> anulado { joins(:venta ).where("ventas.anulado = ?", "#{anulado}") }


  default_scope { order(:nro_cuota) }

  def registrar_pago(fecha_cobro_param, nro_recibo_param)
    transaction do

        #crear session de caja de entrada de dinero
        tipo = Settings.cajas.operaciones.credito
        sucursal_id = venta.sucursal_id
        fecha_registro = fecha_cobro_param
        observacion = 'PAGO CUOTA Nro. ' + nro_cuota.to_s + ' de Venta #' + venta.nro_factura + '#'
        #SesionCaja.generarSesionCaja(tipo, monto, observacion, sucursal_id, fecha_registro)

        write_attribute(:nro_recibo, nro_recibo_param)
        write_attribute(:fecha_cobro, fecha_cobro_param)
        write_attribute(:cancelado, true)


        #actualizar deuda en venta
        nuevaDeuda =  venta.deuda - monto
        if nuevaDeuda == 0
          venta.pagado = true
        end
        venta.deuda = nuevaDeuda

        save
        venta.save

    end
  end

  def registrar_anulacion_pago
    transaction do

        #crear session de caja de entrada de dinero
        tipo = Settings.cajas.operaciones.debito
        sucursal_id = venta.sucursal_id
        fecha_registro = Date.today
        observacion = 'ANULACIÓN de PAGO CUOTA Nro. ' + nro_cuota.to_s + ' de Venta #' + venta.nro_factura + '#'
        #SesionCaja.generarSesionCaja(tipo, monto, observacion, sucursal_id, fecha_registro)

        write_attribute(:nro_recibo, nil)
        write_attribute(:fecha_cobro, nil)
        write_attribute(:cancelado, false)

        #actualizar deuda en venta
        nuevaDeuda =  venta.deuda + monto
        if nuevaDeuda == 0
          venta.pagado = true
        end
        venta.deuda = nuevaDeuda

        save
        venta.save

    end
  end

	def pendiente
		monto_pendiente = 0
		if self.estado == Settings.estadosCuotas.pendiente
			monto_pendiente = self.monto
		end

		if self.estado == Settings.estadosCuotas.parcialmente_pagada
			self.pago_detalles.each do |detalle|
				if ((not detalle.monto_cuota.nil?) and (not detalle.pago.borrado))
					monto_pendiente = monto_pendiente + detalle.monto_cuota
				end
			end
			monto_pendiente = self.monto - monto_pendiente
		end
		return monto_pendiente
	end


  def self.vence_cuota
     enviado = false
     lista_ventas = []
      transaction do
        begin
          lista_ventas = VentaCuota.where(fecha_vencimiento: Date.today.strftime("%Y-%m-%d"))
          enviado = true
        rescue
          retry
        end
      end

        VencimientoCuotaNotifier.vencimiento_cuota_notifier_mail(lista_ventas, 'Ventas')
  end

end
