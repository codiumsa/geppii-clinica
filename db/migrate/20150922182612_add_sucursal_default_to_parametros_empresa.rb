class AddSucursalDefaultToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_reference :parametros_empresas, :sucursal_default, references: :sucursales, index: true, foreign_key: true
  end
end
