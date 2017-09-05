class AddDescripcionLocalToProducto < ActiveRecord::Migration
  def change
    add_column :productos, :descripcion_local, :text
  end
end
