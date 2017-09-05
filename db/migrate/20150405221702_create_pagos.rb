class CreatePagos < ActiveRecord::Migration
  def change
    create_table :pagos do |t|
      t.date :fecha_pago
      t.string :estado
      t.date :fecha_actualizacion_interes
      t.float :total
      t.float :monto_cotizacion
      t.references :venta, index: true
      t.references :compra, index: true
      t.references :moneda, index: true
      t.boolean :borrado
      t.float :descuento

      t.timestamps
    end
  end
end
