class AddMuestraMedioPagoToTipoSalida < ActiveRecord::Migration
  def change
    add_column :tipo_salidas, :muestra_medios_pago, :boolean, default: false
  end
end
