class AddSoportaAjusteInventarioToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_ajuste_inventario, :boolean
  end
end
