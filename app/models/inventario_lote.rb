class InventarioLote < ActiveRecord::Base
  belongs_to :lote
  belongs_to :inventario
  scope :ids, lambda { |id| where(:id => id) }


  attr_accessor :producto

  def producto
  	return lote.nil? ? nil : lote.producto
  end
end
