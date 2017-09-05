class AddNroReciboToPago < ActiveRecord::Migration
  def change
    add_column :pagos, :nro_recibo, :string
  end
end
