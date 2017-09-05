class AddActivoToVendedor < ActiveRecord::Migration
  def change
    add_column :vendedores, :activo, :boolean
  end
end
