class CreateInventarioProductos < ActiveRecord::Migration
  def change
    create_table :inventario_productos do |t|
      t.integer :existencia

      t.timestamps
    end
  end
end
