class AddServicioToProductos < ActiveRecord::Migration
  def change
    add_column :productos, :servicio, :boolean, default: false
  end
end
