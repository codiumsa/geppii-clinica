class CreateTransferenciasDeposito < ActiveRecord::Migration
  def change
    create_table :transferencias_deposito do |t|
      t.references :origen, index: true
      t.references :destino, index: true
      t.references :usuario, index: true
      t.text :descripcion

      t.timestamps
    end
  end
end
