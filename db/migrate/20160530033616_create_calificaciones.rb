class CreateCalificaciones < ActiveRecord::Migration
  def change
    create_table :calificaciones do |t|
      t.string :codigo
      t.string :descripcion
      t.integer :dias_atraso

      t.timestamps
    end
    add_index :calificaciones, :codigo, unique: true
    add_index :calificaciones, :descripcion, unique: true
    add_index :calificaciones, :dias_atraso, unique: true
  end
end
