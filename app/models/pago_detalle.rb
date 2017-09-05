class PagoDetalle < ActiveRecord::Base
  belongs_to :pago
  belongs_to :venta_cuota
	belongs_to :compra_cuota
	scope :ids, lambda { |id| where(:id => id) }
  	scope :by_username, -> username {joins(:usuario).where("usuarios.username ilike ?", "%#{username}%" )}
  	scope :by_pago_activo, -> {joins(:pago).where("pagos.borrado = false")}

	def numero_cuota_asociado
		numero_cuota = 0
		if(not self.compra_cuota_id.nil?)
			numero_cuota = self.compra_cuota.nro_cuota
		end
		if(not self.venta_cuota_id.nil?)
			numero_cuota = self.venta_cuota.nro_cuota
		end
		
		return numero_cuota
	end
end
