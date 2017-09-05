class CreateCompras < ActiveRecord::Migration
  def change
    create_table :compras do |t|
      t.references :sucursal, index: true
      t.references :proveedor, index: true
      t.float :descuento
      t.float :total
      t.float :iva10
      t.float :iva5
      t.boolean :credito
      t.boolean :pagado
      t.integer :cantidad_cuotas
      t.string :nro_factura

      t.timestamps
    end
  end
end
