class CompraMedio < ActiveRecord::Base
  belongs_to :compra
  belongs_to :medio_pago
  belongs_to :tarjeta
  belongs_to :cuenta

  scope :by_id, -> id { where("id = ?", "#{id}") }
end
