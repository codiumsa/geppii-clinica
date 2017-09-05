class CreateTiposOperacion < ActiveRecord::Migration
  def change
    create_table :tipos_operacion do |t|
      t.string :codigo
      t.string :descripcion
      t.boolean :manual
      t.string :referencia

      t.timestamps
    end
  end
end
