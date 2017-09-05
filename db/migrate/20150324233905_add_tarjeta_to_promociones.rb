class AddTarjetaToPromociones < ActiveRecord::Migration
  def change
    add_reference :promociones, :tarjeta, index: true
    add_column :promociones, :con_tarjeta, :boolean, :default => false
  end
end
