class CreateContactoDetalles < ActiveRecord::Migration
  def change
    create_table :contacto_detalles do |t|
      t.references :contacto, index: true
      t.string :estado
      t.string :observacion
      t.float :compromiso
      t.string :comentario
      t.datetime :fecha
      t.datetime :fecha_siguiente
      t.timestamps
    end
  end
end
