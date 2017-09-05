class CreateCategoriaOperaciones < ActiveRecord::Migration
  def change
    create_table :categoria_operaciones do |t|
      t.string :nombre
      t.string :descripcion
      t.boolean :activo

      t.timestamps
    end
  end
end
