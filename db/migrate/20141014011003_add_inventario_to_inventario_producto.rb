class AddInventarioToInventarioProducto < ActiveRecord::Migration
  def change
    add_reference :inventario_productos, :inventario, index: true
  end
end
