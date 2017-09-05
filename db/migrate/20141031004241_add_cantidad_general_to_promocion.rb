class AddCantidadGeneralToPromocion < ActiveRecord::Migration
  def change
    add_column :promociones, :cantidad_general, :integer
  end
end
