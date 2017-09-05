class CreateMotivosInventarios < ActiveRecord::Migration
  def change
    create_table :motivos_inventarios do |t|
      t.string :nombre
      t.string :descripcion
      t.timestamps
    end
  end
end
