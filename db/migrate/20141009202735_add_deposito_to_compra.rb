class AddDepositoToCompra < ActiveRecord::Migration
  def change
    add_reference :compras, :deposito, index: true
  end
end
