class CreatePromocionProductos < ActiveRecord::Migration
  def change
    create_table :promocion_productos do |t|
      t.float :cantidad
      t.float :precio_venta
      t.string :estado

      t.timestamps
    end
  end
end
