class AddVendedorEnVentaToParametrosEmpresas < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :vendedor_en_venta, :boolean
  end
end
