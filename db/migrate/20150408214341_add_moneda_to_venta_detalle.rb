class AddMonedaToVentaDetalle < ActiveRecord::Migration
  def change
    add_reference :venta_detalles, :moneda, index: true
  end
end
