class AddPrecioToProductos < ActiveRecord::Migration
  def change
    add_column :productos, :precio, :float
  end
end
