class RemoveEstadoFromPromocionProducto < ActiveRecord::Migration
  def change
    remove_column :promocion_productos, :estado, :string
  end
end
