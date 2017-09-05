class ProductoDetalle < ActiveRecord::Base
  belongs_to :producto, :class_name => 'Producto', :foreign_key => 'producto_id'
  belongs_to :producto_padre, :class_name => 'Producto', :foreign_key => 'producto_padre_id', :inverse_of => :producto_detalles
  scope :ids, lambda { |id| where(:id => id) }

  scope :by_producto_padre, -> value { where("producto_padre_id = ?", "#{value}") }


end
