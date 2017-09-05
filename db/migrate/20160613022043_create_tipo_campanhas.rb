class CreateTipoCampanhas < ActiveRecord::Migration
  def change
    create_table :tipo_campanhas do |t|
      t.string :nombre
      t.string :descripcion

      t.timestamps
    end
  end
end
