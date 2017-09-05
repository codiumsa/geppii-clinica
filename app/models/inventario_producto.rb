class InventarioProducto < ActiveRecord::Base
	belongs_to :inventario
	belongs_to :producto
	scope :ids, lambda { |id| where(:id => id) }
	
end
