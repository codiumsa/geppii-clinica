class AddAjusteInventarioToAjusteInventarioDetalle < ActiveRecord::Migration
  def change
    add_reference :ajuste_inventario_detalles, :ajuste_inventario, index: true
  end
end
