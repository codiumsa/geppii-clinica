class RemoveCalienteFromPromocionProducto < ActiveRecord::Migration
  def change
    remove_column :promocion_productos, :caliente, :boolean
  end
end
