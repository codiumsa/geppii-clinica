class AddPrecioToPromocionProducto < ActiveRecord::Migration
  def change
    add_column :promocion_productos, :precio, :float
  end
end
