class AddSoportaGaranteToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_garante_venta, :boolean, default: false
  end
end
