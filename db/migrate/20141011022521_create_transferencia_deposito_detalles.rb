class CreateTransferenciaDepositoDetalles < ActiveRecord::Migration
  def change
    create_table :transferencia_deposito_detalles do |t|
      t.references :transferencia, index: true
      t.references :producto, index: true
      t.integer :cantidad

      t.timestamps
    end
  end
end
