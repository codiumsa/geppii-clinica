class AddUsoInternoToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :uso_interno, :boolean
  end
end
