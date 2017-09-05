class AddDepositoToSucursal < ActiveRecord::Migration
  def change
    add_reference :sucursales, :deposito, index: true
  end
end
