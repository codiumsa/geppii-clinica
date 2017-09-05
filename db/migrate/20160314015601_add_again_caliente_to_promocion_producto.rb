class AddAgainCalienteToPromocionProducto < ActiveRecord::Migration
  def change
    add_column :promocion_productos, :caliente, :boolean, default: false
  end
end
