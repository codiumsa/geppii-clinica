class AddColorToSucursales < ActiveRecord::Migration
  def change
    add_column :sucursales, :color, :string, :limit => 10
  end
end
