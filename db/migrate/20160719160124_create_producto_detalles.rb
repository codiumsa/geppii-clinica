class CreateProductoDetalles < ActiveRecord::Migration
  def change
    create_table :producto_detalles do |t|
      t.references :producto, index:true
      t.references :producto, :producto_padre, index:true
      t.integer :cantidad
      t.timestamps
    end
  end
end
