class AddColumnasToVentaDetalles < ActiveRecord::Migration
  def change
    add_column :venta_detalles, :descuento, :float, :default => 0
    add_column :venta_detalles, :caliente, :boolean, :default => false
  end
end
