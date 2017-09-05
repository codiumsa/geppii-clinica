class AddLoteFromTransferenciaDepositoDetalle < ActiveRecord::Migration
  def change
  	add_reference :transferencia_deposito_detalles, :lote, index: true
  end
end
