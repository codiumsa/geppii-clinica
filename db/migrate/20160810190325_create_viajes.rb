class CreateViajes < ActiveRecord::Migration
  def change
    create_table :viajes do |t|
      t.string :descripcion
      t.string :origen
      t.string :destino
      t.datetime :fecha_inicio
      t.datetime :fecha_fin
      t.timestamps
    end
  end
end
