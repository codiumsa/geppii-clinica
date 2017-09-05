class CreateCampanhas < ActiveRecord::Migration
  def change
    create_table :campanhas do |t|
      t.string :nombre
      t.string :descripcion
      t.date :fecha_incio
      t.date :fecha_fin
      t.string :estado
      t.references :persona, index: true
      t.references :tipo_campanha, index: true

      t.timestamps
    end
  end
end
