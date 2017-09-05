class AddMotivosInventarioToAjusteInvetarioDetalles < ActiveRecord::Migration
  def change
    add_reference :ajuste_inventario_detalles, :motivos_inventario, index: true
  end
end
