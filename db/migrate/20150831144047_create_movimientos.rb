class CreateMovimientos < ActiveRecord::Migration
  def change
    create_table :movimientos do |t|
      t.references :caja, index: true
      t.references :operacion, index: true
      t.references :tipo_operacion_detalle, index: true
      t.references :moneda, index: true
      t.float :monto
      t.float :monto_cotizado
      t.string :descripcion

      t.timestamps
    end
  end
end
