class AddDescuentoRedondeoToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :descuento_redondeo, :float, :default => 0
  end
end
