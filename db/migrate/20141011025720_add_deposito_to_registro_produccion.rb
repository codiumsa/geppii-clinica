class AddDepositoToRegistroProduccion < ActiveRecord::Migration
  def change
    add_reference :registros_produccion, :deposito, index: true
  end
end
