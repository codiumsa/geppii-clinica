class AddVendedorToVenta < ActiveRecord::Migration
  def change
    add_reference :ventas, :vendedor, index: true
  end
end
