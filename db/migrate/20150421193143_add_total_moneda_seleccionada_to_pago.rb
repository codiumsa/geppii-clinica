class AddTotalMonedaSeleccionadaToPago < ActiveRecord::Migration
  def change
    add_column :pagos, :total_moneda_seleccionada, :float
  end
end
