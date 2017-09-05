class AddMontoCotizacionToVentaDetalle < ActiveRecord::Migration
  def change
    add_column :venta_detalles, :monto_cotizacion, :float
  end
end
