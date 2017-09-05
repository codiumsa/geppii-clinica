class AddMonedaBaseToCotizacion < ActiveRecord::Migration
  def change
    add_reference :cotizaciones, :moneda_base, index: true
  end
end
