class CreateTipoContactos < ActiveRecord::Migration
  def change
    create_table :tipo_contactos do |t|
      t.string :codigo
      t.string :descripcion
      t.boolean :con_campanha
      t.boolean :con_mision
      t.boolean :activo

      t.timestamps
    end
  end
end
