class AddtarjetaToVentaMedios < ActiveRecord::Migration
  def change
      add_reference :venta_medios, :tarjeta, index: true
  end
end
