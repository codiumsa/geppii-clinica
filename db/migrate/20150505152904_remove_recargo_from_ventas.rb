class RemoveRecargoFromVentas < ActiveRecord::Migration
  def change
    remove_column :ventas, :recargo, :float
  end
end
