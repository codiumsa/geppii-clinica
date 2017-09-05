class CreateCompraDetalles < ActiveRecord::Migration
  def change
    create_table :compra_detalles do |t|
      t.references :compra, index: true
      t.references :producto, index: true
      t.integer :cantidad
      t.float :precio_compra
      t.float :subtotal
      t.float :precio_venta

      t.timestamps
    end
  end
end
