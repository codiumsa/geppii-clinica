class AddDepositoToProduccion < ActiveRecord::Migration
  def change
    add_reference :producciones, :deposito, index: true
  end
end
