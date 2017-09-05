class AddNroOrdenCompraToCompra < ActiveRecord::Migration
  def change
    add_column :compras, :nro_orden_compra, :string 	
  end
end
