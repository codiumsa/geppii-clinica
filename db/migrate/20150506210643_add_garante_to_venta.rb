class AddGaranteToVenta < ActiveRecord::Migration
  def change
	add_reference :ventas, :garante, index: true
  end
end
