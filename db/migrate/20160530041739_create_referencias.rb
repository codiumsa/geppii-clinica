class CreateReferencias < ActiveRecord::Migration
  def change
    create_table :referencias do |t|
      t.references :cliente, index: true
      t.string :nombre
      t.string :telefono
      t.string :tipo_referencia
      t.string :tipo_cuenta
      t.boolean :activa

      t.timestamps
    end
  end
end
