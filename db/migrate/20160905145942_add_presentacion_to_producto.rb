class AddPresentacionToProducto < ActiveRecord::Migration
  def change
    add_column :productos, :presentacion, :string
  end
end
