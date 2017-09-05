class AddSecuenciaToTipoOperacionDetalle < ActiveRecord::Migration
  def change
    add_column :tipo_operacion_detalles, :secuencia, :integer, default: 1
  end
end
