class AddSoportaMultiempresaToParametroEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_multiempresa, :boolean, default: false
  end
end
