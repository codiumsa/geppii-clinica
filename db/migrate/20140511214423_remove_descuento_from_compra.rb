class RemoveDescuentoFromCompra < ActiveRecord::Migration
  def change
    remove_column :compras, :descuento, :float
  end
end
