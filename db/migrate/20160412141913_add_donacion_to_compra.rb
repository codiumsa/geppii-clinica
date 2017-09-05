class AddDonacionToCompra < ActiveRecord::Migration
  def change
      add_column :compras, :donacion, :boolean
  end
end
