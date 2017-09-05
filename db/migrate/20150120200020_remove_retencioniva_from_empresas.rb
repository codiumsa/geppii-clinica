class RemoveRetencionivaFromEmpresas < ActiveRecord::Migration
  def change
    remove_column :empresas, :retencioniva, :integer
  end
end
