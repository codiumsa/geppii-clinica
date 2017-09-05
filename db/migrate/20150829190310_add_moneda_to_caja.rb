class AddMonedaToCaja < ActiveRecord::Migration
  def change
    add_reference :cajas, :moneda, index: true
  end
end
