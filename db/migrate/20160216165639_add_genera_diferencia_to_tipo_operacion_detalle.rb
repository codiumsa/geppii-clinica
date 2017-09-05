class AddGeneraDiferenciaToTipoOperacionDetalle < ActiveRecord::Migration
  def change
    add_column :tipo_operacion_detalles, :genera_diferencia, :boolean, default: false
  end
end
