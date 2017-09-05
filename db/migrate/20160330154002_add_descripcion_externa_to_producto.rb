class AddDescripcionExternaToProducto < ActiveRecord::Migration
  def change
      add_column :productos, :descripcion_externa, :text
  end
end
