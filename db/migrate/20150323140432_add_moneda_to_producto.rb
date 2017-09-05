class AddMonedaToProducto < ActiveRecord::Migration
  def change
    add_reference :productos, :moneda, index: true
  end
end
