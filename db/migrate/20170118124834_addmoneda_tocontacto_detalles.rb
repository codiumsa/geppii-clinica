class AddmonedaTocontactoDetalles < ActiveRecord::Migration
  def change
    add_reference :contacto_detalles, :moneda, index: true
  end
end
