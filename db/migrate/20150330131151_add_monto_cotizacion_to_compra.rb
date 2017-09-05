class AddMontoCotizacionToCompra < ActiveRecord::Migration
  def change
    add_column :compras, :monto_cotizacion, :float
  end
end
