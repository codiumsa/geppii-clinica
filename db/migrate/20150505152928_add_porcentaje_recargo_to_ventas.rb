class AddPorcentajeRecargoToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :porcentaje_recargo, :float
  end
end
