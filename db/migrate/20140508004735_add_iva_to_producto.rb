class AddIvaToProducto < ActiveRecord::Migration
  def change
    add_column :productos, :iva, :float
  end
end
