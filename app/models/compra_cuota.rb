class CompraCuota < ActiveRecord::Base
  belongs_to :compra
	has_many :pago_detalles, dependent: :destroy

	scope :pendientes, -> { where("estado <> ?", "#{Settings.estadosCuotas.pagada}").order(:nro_cuota) }
	scope :by_cancelado, -> cancelado { where("cancelado = ?", "#{cancelado}") }
  scope :by_compra, -> compra_id { where("compra_id = ?", "#{compra_id}") }
  scope :by_proveedor_id, -> proveedor_id { joins(:compra).where("compras.proveedor_id = ?", "#{proveedor_id}") }
  scope :by_sucursal_id, -> sucursal_id { joins(:compra).where("compras.sucursal_id = ?", "#{sucursal_id}") }
	scope :by_deposito_id, -> deposito_id { joins(:compra).where("compras.deposito_id = ?", "#{deposito_id}") }
  scope :by_nro_factura, -> nro_factura { joins(:compra).where("compras.nro_factura= ?", "#{nro_factura}") }
	scope :by_empresa_id, -> empresa_id { 
    joins(:compra => :sucursal).where("sucursales.empresa_id = ?", "#{empresa_id}")}

  scope :by_fecha_compra_before, -> before{ joins(:compra).where("compras.fecha_registro::date < ?", Date.parse(before)) }
  scope :by_fecha_compra_on, -> on { joins(:compra).where("compras.fecha_registro::date = ?", Date.parse(on)) }
  scope :by_fecha_compra_after, -> after { joins(:compra).where("compras.fecha_registro::date > ?", Date.parse(after)) }

  scope :by_fecha_vencimiento_before, -> before{ where("fecha_vencimiento::date < ?", Date.parse(before)) }
  scope :by_fecha_vencimiento_on, -> on { where("fecha_vencimiento::date = ?", Date.parse(on)) }
  scope :by_fecha_vencimiento_after, -> after { where("fecha_vencimiento::date > ?", Date.parse(after)) }

  scope :by_fecha_cobro_before, -> before{ where("fecha_cobro::date < ?", Date.parse(before)) }
  scope :by_fecha_cobro_on, -> on { where("fecha_cobro::date = ?", Date.parse(on)) }
  scope :by_fecha_cobro_after, -> after { where("fecha_cobro::date > ?", Date.parse(after)) }

  default_scope { order(:nro_cuota) }
	
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
	   lista_compras = []
	    transaction do
	      begin
	       	lista_compras = CompraCuota.where(fecha_vencimiento: Date.today.strftime("%Y-%m-%d"))
        	enviado = true
	      rescue
	      	retry
	      end
	    end
	      VencimientoCuotaNotifier.vencimiento_cuota_notifier_mail(lista_compras, 'Compras')
	end


	

end
