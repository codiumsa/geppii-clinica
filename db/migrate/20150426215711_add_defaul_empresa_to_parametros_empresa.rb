class AddDefaulEmpresaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :default_empresa, :boolean
  end
end
