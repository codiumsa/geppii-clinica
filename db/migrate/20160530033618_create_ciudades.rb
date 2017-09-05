class CreateCiudades < ActiveRecord::Migration
  def change
    create_table :ciudades do |t|
      t.string :codigo
      t.string :nombre

      t.timestamps
    end
    add_index :ciudades, :codigo, unique: true
    add_index :ciudades, :nombre, unique: true
  end
end
