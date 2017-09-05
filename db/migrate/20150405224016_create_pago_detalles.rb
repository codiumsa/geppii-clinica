class CreatePagoDetalles < ActiveRecord::Migration
  def change
    create_table :pago_detalles do |t|
      t.float :monto_cuota
      t.float :monto_interes
      t.float :monto_interes_moratorio
      t.float :monto_interes_punitorio
      t.references :pago, index: true
      t.references :compra_cuota, index: true
      t.references :venta_cuota, index: true

      t.timestamps
    end
  end
end
