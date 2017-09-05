class CreateProveedores < ActiveRecord::Migration
  def change
    create_table :proveedores do |t|
      t.string :razon_social
      t.string :ruc
      t.string :direccion
      t.string :telefono
      t.string :email
      t.string :persona_contacto
      t.string :telefono_contacto

      t.timestamps
    end
  end
end
