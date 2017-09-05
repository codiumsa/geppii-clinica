class AddRetencionivaToEmpresa < ActiveRecord::Migration
  def change
    add_column :empresas, :retencioniva, :integer
  end
end
