class CreateProductoSucursales < ActiveRecord::Migration
  def change
    create_table :producto_sucursales do |t|
      t.references :producto, index: true
      t.references :sucursal, index: true
      t.integer :existencia

      t.timestamps
    end
  end
end
