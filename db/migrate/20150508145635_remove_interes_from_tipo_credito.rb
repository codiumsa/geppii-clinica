class RemoveInteresFromTipoCredito < ActiveRecord::Migration
  def change
    remove_column :tipo_creditos, :interes, :float
  end
end
