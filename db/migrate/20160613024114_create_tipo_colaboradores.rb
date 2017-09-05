class CreateTipoColaboradores < ActiveRecord::Migration
  def change
    create_table :tipo_colaboradores do |t|
      t.string :nombre
      t.string :descripcion
      t.boolean :tiene_viajes
      t.boolean :tiene_licencia

      t.timestamps
    end
  end
end
