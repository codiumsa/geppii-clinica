class CreatePrecios < ActiveRecord::Migration
  def change
    create_table :precios do |t|
      t.datetime :fecha
      t.float :precio_compra
      t.references :compra_detalle, index: true

      t.timestamps
    end
  end
end
