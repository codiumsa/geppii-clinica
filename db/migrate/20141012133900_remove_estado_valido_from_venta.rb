class RemoveEstadoValidoFromVenta < ActiveRecord::Migration
  def change
    remove_column :ventas, :estado_valido, :boolean
  end
end
