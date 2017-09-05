class AddActivoToCampanhas < ActiveRecord::Migration
  def change
    add_column :campanhas, :activo, :boolean
  end
end
