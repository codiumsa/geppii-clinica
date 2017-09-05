class RemovePrecioVentaFromPromocionProducto < ActiveRecord::Migration
  def change
    remove_column :promocion_productos, :precio_venta, :string
  end
end
