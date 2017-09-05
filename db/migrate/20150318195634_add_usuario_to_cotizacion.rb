class AddUsuarioToCotizacion < ActiveRecord::Migration
  def change
    add_reference :cotizaciones, :usuario, index: true
  end
end
