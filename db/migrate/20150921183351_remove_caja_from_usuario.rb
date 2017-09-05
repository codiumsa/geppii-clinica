class RemoveCajaFromUsuario < ActiveRecord::Migration
  def change
    remove_column :usuarios, :caja_id
  end
end
