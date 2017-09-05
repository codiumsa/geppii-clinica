class AddTipoOperacionToOperaciones < ActiveRecord::Migration
  def change
	add_reference :operaciones, :tipo_operacion, references: :tipos_operacion, index: true, foreign_key: true
  end
end
