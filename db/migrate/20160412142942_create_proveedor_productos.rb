class CreateProveedorProductos < ActiveRecord::Migration
  def change
    create_table :proveedor_productos do |t|
        t.references :proveedor, index: true
        t.references :producto, index: true
        t.timestamps
    end
  end
end
