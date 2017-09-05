class AddSaldoToMovimiento < ActiveRecord::Migration
  def change
  	add_column :movimientos, :saldo, :float

  end
end
