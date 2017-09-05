class AddColumnToTipoOperacionDetalle < ActiveRecord::Migration
  def change
    add_column :tipo_operacion_detalles, :impacta_saldo, :boolean, default: false
  end
end
