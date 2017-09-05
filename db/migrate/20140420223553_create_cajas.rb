class CreateCajas < ActiveRecord::Migration
  def change
    create_table :cajas do |t|
      t.string :codigo
      t.string :descripcion

      t.timestamps
    end
  end
end
