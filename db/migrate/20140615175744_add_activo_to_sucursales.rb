class AddActivoToSucursales < ActiveRecord::Migration
  def change
    add_column :sucursales, :activo, :boolean
  end
end
