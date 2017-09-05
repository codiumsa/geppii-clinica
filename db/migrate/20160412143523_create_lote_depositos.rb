class CreateLoteDepositos < ActiveRecord::Migration
  def change
    create_table :lote_depositos do |t|
        t.references :lote, index: true
        t.references :deposito, index: true
        t.references :producto, index: true
      t.timestamps
    end
  end
end
