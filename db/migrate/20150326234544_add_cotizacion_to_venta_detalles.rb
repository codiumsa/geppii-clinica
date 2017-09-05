class AddCotizacionToVentaDetalles < ActiveRecord::Migration
  def change
    add_reference :venta_detalles, :cotizacion, index: true
  end
end
