class AddExternoToTipoOperaciones < ActiveRecord::Migration
  def change
    add_column :tipos_operacion, :externo, :boolean, default: false
  end
end
