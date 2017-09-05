class AddCtrlInventarioCantidadToParametrosEmpresa < ActiveRecord::Migration
  def change
  	add_column :parametros_empresas, :ctrl_inventario_cantidad, :integer
  end
end
