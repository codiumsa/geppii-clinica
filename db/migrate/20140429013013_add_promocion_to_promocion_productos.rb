class AddPromocionToPromocionProductos < ActiveRecord::Migration
  def change
    add_reference :promocion_productos, :promocion, index: true
  end
end
