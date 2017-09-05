class AddReversionToTipoOperacion < ActiveRecord::Migration
  def change
	add_reference :tipos_operacion, :tipo_operacion_reversion, references: :tipos_operacion, index: true, foreign_key: true
  end
end
