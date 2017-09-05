class AddProductoToInventarioProducto < ActiveRecord::Migration
  def change
    add_reference :inventario_productos, :producto, index: true
  end
end
