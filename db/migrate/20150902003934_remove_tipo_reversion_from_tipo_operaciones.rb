class RemoveTipoReversionFromTipoOperaciones < ActiveRecord::Migration
  def change
    remove_column :tipos_operacion, :tipo_operacion_reversion_id
    add_column :tipos_operacion, :tipo_operacion_reversion, :string
  end
end
