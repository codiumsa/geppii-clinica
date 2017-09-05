class AddActivoToTarjeta < ActiveRecord::Migration
  def change
  	add_column :tarjetas, :activo, :boolean
  end
end
