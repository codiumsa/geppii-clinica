class CreateVentaMedios < ActiveRecord::Migration
  def change
    create_table :venta_medios do |t|
      t.references :venta, index: true, :null => false
        t.references :medio_pago, index: true, :null => false
        t.float :monto
      t.timestamps
    end
  end
end
