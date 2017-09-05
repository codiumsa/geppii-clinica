class AddMonedaBaseToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_reference :parametros_empresas, :moneda_base, index: true
  end
end
