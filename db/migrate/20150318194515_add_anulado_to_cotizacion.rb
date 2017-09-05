class AddAnuladoToCotizacion < ActiveRecord::Migration
  def change
    add_column :cotizaciones, :anulado, :boolean
  end
end
