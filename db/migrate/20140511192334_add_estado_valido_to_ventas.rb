class AddEstadoValidoToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :estado_valido, :boolean
  end
end
