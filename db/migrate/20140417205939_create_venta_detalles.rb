class CreateVentaDetalles < ActiveRecord::Migration
  def change
    create_table :venta_detalles do |t|
      t.references :venta, index: true
      t.references :producto, index: true, :null => false
      t.integer :cantidad
      t.float :precio

      t.timestamps
    end
  end
end
