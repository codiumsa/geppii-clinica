class AddProductoToProducto < ActiveRecord::Migration
  def change
    add_reference :productos, :producto, index: true
  end
end
