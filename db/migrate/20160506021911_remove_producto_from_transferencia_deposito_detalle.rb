class RemoveProductoFromTransferenciaDepositoDetalle < ActiveRecord::Migration
  def change
	remove_column :transferencia_deposito_detalles, :producto_id
  end
end
