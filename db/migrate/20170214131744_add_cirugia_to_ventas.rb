class AddCirugiaToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :cirugia, :boolean, :default => false
    add_column :ventas, :cantidad_cirugias, :integer
  end
end
