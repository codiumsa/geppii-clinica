class CreateSucursalesVendedores < ActiveRecord::Migration
  def change
    create_table :sucursales_vendedores do |t|
      t.references :sucursal, index: true
      t.references :vendedor, index: true

      t.timestamps
    end
  end
end
