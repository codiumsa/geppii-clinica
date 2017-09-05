class CreateContactos < ActiveRecord::Migration
  def change
    create_table :contactos do |t|
      t.string :observacion
      t.datetime :fecha
      t.references :sponsor, index: true
      t.references :tipo_contacto, index: true
      t.references :campanha, index: true

      t.timestamps
    end
  end
end
