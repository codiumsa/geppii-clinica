class AddSucursalToVentas < ActiveRecord::Migration
  def change
    add_reference :ventas, :sucursal, index: true
  end
end
