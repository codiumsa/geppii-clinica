class AddnroInventarioToProductos < ActiveRecord::Migration
  def change
    add_column :productos, :nro_inventario, :string
    add_column :productos, :nro_serie, :string
    add_column :productos, :asignado, :string
    add_column :productos, :responsable_mantenimiento, :string
    add_column :productos, :anho_fabricacion, :string
    add_column :productos, :fecha_adquisicion, :datetime
    add_column :productos, :area, :string
    add_column :productos, :modelo, :string
    add_column :productos, :descontinuado, :boolean, default: false
  end
end
