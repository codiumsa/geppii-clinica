class AddReferenciaIdToOperaciones < ActiveRecord::Migration
  def change
    add_column :operaciones, :referencia_id, :integer
  end
end
