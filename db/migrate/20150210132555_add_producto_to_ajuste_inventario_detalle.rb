class AddProductoToAjusteInventarioDetalle < ActiveRecord::Migration
  def change
    add_reference :ajuste_inventario_detalles, :producto, index: true
  end
end
