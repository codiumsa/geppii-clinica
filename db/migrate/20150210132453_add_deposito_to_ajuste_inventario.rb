class AddDepositoToAjusteInventario < ActiveRecord::Migration
  def change
    add_reference :ajuste_inventarios, :deposito, index: true
  end
end
