class AddActivoToPromociones < ActiveRecord::Migration
  def change
    add_column :promociones, :activo, :boolean, default: true
  end
end
