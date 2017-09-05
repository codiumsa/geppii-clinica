class RemovePrecioVentaFromProductos < ActiveRecord::Migration
  def change
    remove_column :productos, :precio_venta, :string
  end
end
