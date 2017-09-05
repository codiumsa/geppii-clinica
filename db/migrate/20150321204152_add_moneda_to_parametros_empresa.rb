class AddMonedaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_reference :parametros_empresas, :moneda, index: true
  end
end
