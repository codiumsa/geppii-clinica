class AddRetencionivaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :retencioniva, :integer
  end
end
