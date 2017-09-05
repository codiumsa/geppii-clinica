class CategoriaProducto < ActiveRecord::Base
  belongs_to :producto
  belongs_to :categoria
  
  scope :by_producto, -> producto { where("producto_id = ?", "#{producto}") }
end
