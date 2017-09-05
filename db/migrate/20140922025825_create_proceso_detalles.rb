class CreateProcesoDetalles < ActiveRecord::Migration
  def change
    create_table :proceso_detalles do |t|
      t.references :proceso, index: true
      t.references :producto, index: true
      t.integer :cantidad
      t.float :precio_costo
      t.float :precio_venta

      t.timestamps
    end
  end
end
