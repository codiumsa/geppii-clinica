class AddDeudaToCompra < ActiveRecord::Migration
  def change
    add_column :compras, :deuda, :float
  end
end
