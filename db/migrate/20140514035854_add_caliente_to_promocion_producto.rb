class AddCalienteToPromocionProducto < ActiveRecord::Migration
  def change
    add_column :promocion_productos, :caliente, :boolean
  end
end
