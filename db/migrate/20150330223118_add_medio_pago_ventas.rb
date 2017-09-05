class AddMedioPagoVentas < ActiveRecord::Migration
  def change
    add_reference :ventas, :medio_pago, index: true
  end
end
