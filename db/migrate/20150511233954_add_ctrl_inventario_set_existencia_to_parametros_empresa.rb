class AddCtrlInventarioSetExistenciaToParametrosEmpresa < ActiveRecord::Migration
  def change
  	add_column :parametros_empresas, :ctrl_inventario_set_existencia, :boolean
  end
end
