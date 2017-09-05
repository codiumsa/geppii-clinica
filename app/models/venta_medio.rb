class VentaMedio < ActiveRecord::Base
    belongs_to :venta
    belongs_to :medio_pago
    belongs_to :tarjeta
    
    scope :by_id, -> id { where("id = ?", "#{id}") }

end
