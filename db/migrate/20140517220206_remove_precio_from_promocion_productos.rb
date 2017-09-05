class RemovePrecioFromPromocionProductos < ActiveRecord::Migration
  def change
    remove_column :promocion_productos, :precio, :string
  end
end
