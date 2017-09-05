class AddPackToProducto < ActiveRecord::Migration
  def change
    add_column :productos, :pack, :boolean
  end
end
