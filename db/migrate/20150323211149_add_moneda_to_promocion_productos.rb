class AddMonedaToPromocionProductos < ActiveRecord::Migration
  def change
    add_reference :promocion_productos, :moneda, index: true
  end
end
