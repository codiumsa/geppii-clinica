class AddResponsableToSucursales < ActiveRecord::Migration
  def change
    add_reference :sucursales, :vendedor, index: true
  end
end
