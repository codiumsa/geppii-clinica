class AddSucursalToCajas < ActiveRecord::Migration
  def change
    add_reference :cajas, :sucursal, index: true
  end
end
