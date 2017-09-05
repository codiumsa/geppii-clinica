class AddExclusivaToPromocion < ActiveRecord::Migration
  def change
    add_column :promociones, :exclusiva, :boolean
  end
end
