class AddTarjetaCreditoEnVentaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :tarjeta_credito_en_venta, :boolean
  end
end
