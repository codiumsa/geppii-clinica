class AddMonedaToVenta < ActiveRecord::Migration
  def change
    add_reference :ventas, :moneda, index: true
  end
end
