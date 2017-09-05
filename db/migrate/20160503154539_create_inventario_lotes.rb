class CreateInventarioLotes < ActiveRecord::Migration
  def change
    create_table :inventario_lotes do |t|
      t.references :lote, index: true
      t.references :inventario, index: true
      t.float :existencia
      t.float :existencia_previa

      t.timestamps
    end
  end
end
