class AddStockminimoToProducto < ActiveRecord::Migration
  def change
    add_column :productos, :stock_minimo, :integer
  end
end
