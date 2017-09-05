class AddColumnToTipoOperacion < ActiveRecord::Migration
  def change
    add_column :tipos_operacion, :muestra_saldo, :boolean, default: false
  end
end
