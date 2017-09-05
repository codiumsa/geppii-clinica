class AjusteInventarioDetalle < ActiveRecord::Base
	belongs_to :ajuste_inventario
	belongs_to :motivos_inventario
	belongs_to :producto
	belongs_to :lote
	scope :ids, lambda { |id| where(:id => id) }
end
