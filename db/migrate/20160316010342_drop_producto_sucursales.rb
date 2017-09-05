class DropProductoSucursales < ActiveRecord::Migration
  def change
  	drop_table :producto_sucursales
  end
end
