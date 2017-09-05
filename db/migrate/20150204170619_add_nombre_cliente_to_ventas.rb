class AddNombreClienteToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :nombre_cliente, :string
  end
end
