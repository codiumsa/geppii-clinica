class CreateEmpresas < ActiveRecord::Migration
  def change
    create_table :empresas do |t|
      t.string :nombre
      t.boolean :activo
      t.string :ruc

      t.timestamps
    end
    add_index :empresas, :nombre, unique: true
  end
end
