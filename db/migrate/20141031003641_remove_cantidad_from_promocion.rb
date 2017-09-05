class RemoveCantidadFromPromocion < ActiveRecord::Migration
  def change
    remove_column :promociones, :cantidad, :integer
  end
end
