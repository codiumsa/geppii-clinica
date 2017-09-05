class AddRecargoToVenta < ActiveRecord::Migration
  def change
    add_column :ventas, :recargo, :float
  end
end
