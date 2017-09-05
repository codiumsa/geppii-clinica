class AddRucClienteToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :ruc_cliente, :string
  end
end
