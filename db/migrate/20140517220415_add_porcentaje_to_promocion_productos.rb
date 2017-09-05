class AddPorcentajeToPromocionProductos < ActiveRecord::Migration
  def change
    add_column :promocion_productos, :porcentaje, :boolean
  end
end
