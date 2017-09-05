class AddEstadoToVentaCuota < ActiveRecord::Migration
  def change
    add_column :venta_cuotas, :estado, :string
  end
end
