class AddPrecioDescuentoToPromocionProductos < ActiveRecord::Migration
  def change
    add_column :promocion_productos, :precio_descuento, :float
  end
end
