class CreateVentaCuotas < ActiveRecord::Migration
  def change
    create_table :venta_cuotas do |t|
      t.references :venta, index: true, :null => false
      t.integer :nro_cuota
      t.float :monto
      t.date :fecha_vencimiento
      t.date :fecha_cobro
      t.boolean :cancelado, :default => false
      t.string :nro_recibo

      t.timestamps
    end
  end
end
