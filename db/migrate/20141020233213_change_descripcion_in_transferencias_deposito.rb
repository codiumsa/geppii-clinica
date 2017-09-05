class ChangeDescripcionInTransferenciasDeposito < ActiveRecord::Migration
  def up
    change_column :transferencias_deposito, :descripcion, :text
  end
  def down
    change_column :transferencias_deposito, :descripcion, :string
  end
end
