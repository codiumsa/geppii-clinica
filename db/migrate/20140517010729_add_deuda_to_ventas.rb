class AddDeudaToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :deuda, :float
  end
end
