class AddPrecioCompraToProducto < ActiveRecord::Migration
  def change
    add_column :productos, :precio_compra, :float
  end
end
