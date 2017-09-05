class CreateVendedores < ActiveRecord::Migration
  def change
    create_table :vendedores do |t|
      t.string :nombre
      t.string :apellido
      t.string :direccion
      t.string :telefono
      t.string :email

      t.timestamps
    end
  end
end
