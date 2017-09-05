class CreateLotes < ActiveRecord::Migration
  def change
    create_table :lotes do |t|
        t.references :producto, index: true
         t.datetime :fecha_vencimiento
        t.string :codigo_lote
        t.timestamps
    end
  end
end
