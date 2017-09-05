class CreateCategoriasProductos < ActiveRecord::Migration
  def change
    create_table :categorias_productos do |t|
      t.references :producto, index: true
      t.references :categoria, index: true

      t.timestamps
    end
  end
end
