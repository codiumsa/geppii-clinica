class AddFechaRegistroToTransferenciasDeposito < ActiveRecord::Migration
  def change
    add_column :transferencias_deposito, :fecha_registro, :datetime
  end
end
