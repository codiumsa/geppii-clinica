class AddGananciaToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :ganancia, :float
  end
end
