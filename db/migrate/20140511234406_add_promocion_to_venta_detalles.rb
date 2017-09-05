class AddPromocionToVentaDetalles < ActiveRecord::Migration
  def change
    add_reference :venta_detalles, :promocion, index: true
  end
end
