class AddTarjetaCreditoToVenta < ActiveRecord::Migration
  def change
    add_column :ventas, :tarjeta_credito, :bool
  end
end
