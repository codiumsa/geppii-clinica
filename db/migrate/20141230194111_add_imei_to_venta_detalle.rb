class AddImeiToVentaDetalle < ActiveRecord::Migration
  def change
    add_column :venta_detalles, :imei, :string
  end
end
