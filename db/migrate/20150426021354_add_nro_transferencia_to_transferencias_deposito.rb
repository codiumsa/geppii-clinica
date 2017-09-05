class AddNroTransferenciaToTransferenciasDeposito < ActiveRecord::Migration
  def change
    add_column :transferencias_deposito, :nro_transferencia, :string
  end
end
