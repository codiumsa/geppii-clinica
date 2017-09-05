class AddNecesitaConsentimientoFirmadoToProductos < ActiveRecord::Migration
  def change
    add_column :productos, :necesita_consentimiento_firmado, :boolean, :default => false
  end
end
