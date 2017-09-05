class AddVentaPadretoVenta < ActiveRecord::Migration
  def change
    add_column :ventas, :venta_padre_id, :integer
  end
end
