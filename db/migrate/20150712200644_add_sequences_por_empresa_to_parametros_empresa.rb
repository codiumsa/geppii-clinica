class AddSequencesPorEmpresaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :sequences_por_empresa, :boolean
  end
end
