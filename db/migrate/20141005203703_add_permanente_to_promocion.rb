class AddPermanenteToPromocion < ActiveRecord::Migration
  def change
    add_column :promociones, :permanente, :boolean
  end
end
