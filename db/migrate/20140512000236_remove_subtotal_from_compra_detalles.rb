class RemoveSubtotalFromCompraDetalles < ActiveRecord::Migration
  def change
    remove_column :compra_detalles, :subtotal, :float
  end
end
