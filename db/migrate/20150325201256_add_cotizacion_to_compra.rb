class AddCotizacionToCompra < ActiveRecord::Migration
  def change
    add_reference :compras, :cotizacion, index: true
  end
end
