class AddMonedaToCompra < ActiveRecord::Migration
  def change
    add_reference :compras, :moneda, index: true
  end
end
