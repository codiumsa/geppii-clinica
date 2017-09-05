class CreateTarjetas < ActiveRecord::Migration
  def change
    create_table :tarjetas do |t|
      t.string :banco
      t.string :marca
      t.string :afinidad
      t.references :medio_pago, index: true

      t.timestamps
    end
  end
end
