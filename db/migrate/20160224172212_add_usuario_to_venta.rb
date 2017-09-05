class AddUsuarioToVenta < ActiveRecord::Migration
  def change
	add_reference :ventas, :usuario, index: true
  end
end
