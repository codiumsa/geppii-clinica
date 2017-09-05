class AddTipoProductoToProducto < ActiveRecord::Migration
  def change
      add_reference :productos, :tipo_producto, index: true
  end
end
