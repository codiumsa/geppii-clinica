class CreateProductoDepositos < ActiveRecord::Migration
  def change
    create_table :producto_depositos do |t|
      t.references :producto, index: true
      t.references :deposito, index: true
      t.integer :existencia

      t.timestamps
    end
  end
end
