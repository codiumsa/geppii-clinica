class AddFechaRegistroToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :fecha_registro, :datetime
  end
end
