class RemovePrecioMayoristaFromProducto < ActiveRecord::Migration
  def change
    remove_column :productos, :precio_mayorista, :float
  end
end
