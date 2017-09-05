class AddUsaLoteToTipoProducto < ActiveRecord::Migration
  def change
    add_column :tipo_productos, :usa_lote, :boolean
    add_column :tipo_productos, :procedimiento, :boolean
    add_column :tipo_productos, :especialidad, :boolean
    add_column :tipo_productos, :stock, :boolean
    add_column :tipo_productos, :tiene_fecha_vencimiento, :boolean
    add_column :tipo_productos, :producto_osi, :boolean
  end
end
