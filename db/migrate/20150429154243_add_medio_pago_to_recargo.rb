class AddMedioPagoToRecargo < ActiveRecord::Migration
  def change
    add_reference :recargos, :medio_pago, index: true
  end
end
