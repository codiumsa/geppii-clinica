class AddFechaRegistroToCompra < ActiveRecord::Migration
  def change
    add_column :compras, :fecha_registro, :datetime
  end
end
