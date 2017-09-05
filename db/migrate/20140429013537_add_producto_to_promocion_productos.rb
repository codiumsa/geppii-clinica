class AddProductoToPromocionProductos < ActiveRecord::Migration
  def change
    add_reference :promocion_productos, :producto, index: true
  end
end
