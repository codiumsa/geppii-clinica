class AddPreciopromedioToProducto < ActiveRecord::Migration
  def change
    add_column :productos, :precio_promedio, :float
  end
end
