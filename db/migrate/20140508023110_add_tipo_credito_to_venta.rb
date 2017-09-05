class AddTipoCreditoToVenta < ActiveRecord::Migration
  def change
    add_reference :ventas, :tipo_credito, index: true
  end
end
