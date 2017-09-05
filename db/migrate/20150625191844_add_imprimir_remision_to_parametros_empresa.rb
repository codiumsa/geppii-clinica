class AddImprimirRemisionToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :imprimir_remision, :boolean
  end
end
