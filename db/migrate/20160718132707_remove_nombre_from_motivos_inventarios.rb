class RemoveNombreFromMotivosInventarios < ActiveRecord::Migration
  def change
    remove_column :motivos_inventarios, :nombre, :string
  end
end
