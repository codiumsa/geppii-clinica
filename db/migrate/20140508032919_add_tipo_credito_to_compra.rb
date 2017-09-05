class AddTipoCreditoToCompra < ActiveRecord::Migration
  def change
    add_reference :compras, :tipo_credito, index: true
  end
end
