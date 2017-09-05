class DeleteTipoOperacionFromOperaciones < ActiveRecord::Migration
  def change
    remove_column :operaciones, :tipo_operacion
  end
end
