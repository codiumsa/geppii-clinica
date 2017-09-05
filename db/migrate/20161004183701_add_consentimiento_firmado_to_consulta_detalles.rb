class AddConsentimientoFirmadoToConsultaDetalles < ActiveRecord::Migration
  def change
    add_column :consulta_detalles, :consentimiento_firmado, :boolean, :default => false
  end
end
