class AddLoteToVentaDetalle < ActiveRecord::Migration
  def change
    add_reference :venta_detalles, :lote , index: true
  end
end
