class CompraDetalle < ActiveRecord::Base
  belongs_to :compra
  belongs_to :producto
  belongs_to :lote
  belongs_to :contenedor
  has_one :precio
  attr_accessor :precio_venta
  attr_accessor :precio_promedio
  scope :ids, lambda { |id| where(:id => id) }
  scope :by_lote, -> lote_id { where("lote_id = ?", "#{lote_id}") }

end
