class RemovePrecioVentaFromCompraDetalles < ActiveRecord::Migration
  def change
    remove_column :compra_detalles, :precio_venta, :float
  end
end
