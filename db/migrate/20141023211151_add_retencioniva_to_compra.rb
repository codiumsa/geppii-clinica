class AddRetencionivaToCompra < ActiveRecord::Migration
  def change
    add_column :compras, :retencioniva, :float
  end
end
