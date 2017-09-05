class AddSoportaProduccionToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_produccion, :boolean, default: false
  end
end
