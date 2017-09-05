class AddLoteToAjusteInventarioDetalles < ActiveRecord::Migration
  def change
    add_reference :ajuste_inventario_detalles, :lote, index: true
  end
end
