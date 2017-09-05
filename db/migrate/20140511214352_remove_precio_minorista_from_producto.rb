class RemovePrecioMinoristaFromProducto < ActiveRecord::Migration
  def change
    remove_column :productos, :precio_minorista, :float
  end
end
