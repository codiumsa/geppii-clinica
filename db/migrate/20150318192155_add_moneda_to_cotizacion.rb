class AddMonedaToCotizacion < ActiveRecord::Migration
  def change
    add_reference :cotizaciones, :moneda, index: true
  end
end
