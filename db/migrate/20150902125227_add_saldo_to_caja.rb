class AddSaldoToCaja < ActiveRecord::Migration
  def change
    add_column :cajas, :saldo, :float 	
  end
end
