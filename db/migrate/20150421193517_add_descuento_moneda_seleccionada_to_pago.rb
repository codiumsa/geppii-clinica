class AddDescuentoMonedaSeleccionadaToPago < ActiveRecord::Migration
  def change
    add_column :pagos, :descuento_moneda_seleccionada, :float
  end
end
