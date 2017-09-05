class CreateTipoOperacionDetalles < ActiveRecord::Migration
  def change
    create_table :tipo_operacion_detalles do |t|
      t.references :tipo_operacion, index: true
      t.string :descripcion
      t.references :tipo_movimiento, index: true
      t.boolean :caja_destino

      t.timestamps
    end
  end
end
