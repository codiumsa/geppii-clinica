class AddEmpresaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_reference :parametros_empresas, :empresa, index: true
  end
end
