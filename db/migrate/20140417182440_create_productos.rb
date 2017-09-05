class CreateProductos < ActiveRecord::Migration
  def change
    create_table :productos do |t|
      t.string :codigo_barra
      t.text :descripcion
      t.string :unidad
      t.float :margen
      t.float :precio_minorista
      t.float :precio_mayorista
      t.timestamps
    end
    add_index :productos, :codigo_barra, unique: true
  end
end
