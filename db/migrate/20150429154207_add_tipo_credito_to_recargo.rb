class AddTipoCreditoToRecargo < ActiveRecord::Migration
  def change
    add_reference :recargos, :tipo_credito, index: true
  end
end
