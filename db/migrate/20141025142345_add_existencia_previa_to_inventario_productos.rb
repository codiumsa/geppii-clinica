class AddExistenciaPreviaToInventarioProductos < ActiveRecord::Migration
  def change
    add_column :inventario_productos, :existencia_previa, :integer
  end
end
