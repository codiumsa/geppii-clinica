class RemoveTieneFechaVencimientoFromTipoProducto < ActiveRecord::Migration
  def change
    remove_column :tipo_productos, :tiene_fecha_vencimiento
  end
end
