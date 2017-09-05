class AddCantidadToProducto < ActiveRecord::Migration
  def change
    add_column :productos, :cantidad, :integer
  end
end
