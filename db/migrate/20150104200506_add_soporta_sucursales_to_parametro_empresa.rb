class AddSoportaSucursalesToParametroEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_sucursales, :boolean, default: false
  end
end
