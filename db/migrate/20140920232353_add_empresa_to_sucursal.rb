class AddEmpresaToSucursal < ActiveRecord::Migration
  def change
    add_reference :sucursales, :empresa, index: true
  end
end
