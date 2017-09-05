class CreateSucursales < ActiveRecord::Migration
  def change
    create_table :sucursales do |t|
      t.string :codigo
      t.string :descripcion

      t.timestamps
    end
  end
end
