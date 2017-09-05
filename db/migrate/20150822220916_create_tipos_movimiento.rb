class CreateTiposMovimiento < ActiveRecord::Migration
  def change
    create_table :tipos_movimiento do |t|
      t.string :codigo
      t.string :descripcion

      t.timestamps
    end
  end
end
