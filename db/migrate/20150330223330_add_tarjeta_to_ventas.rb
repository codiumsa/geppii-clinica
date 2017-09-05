class AddTarjetaToVentas < ActiveRecord::Migration
  def change
    add_reference :ventas, :tarjeta, index: true
  end
end
