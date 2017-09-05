class AddCantidadToPromocion < ActiveRecord::Migration
  def change
    add_column :promociones, :cantidad, :integer
  end
end
