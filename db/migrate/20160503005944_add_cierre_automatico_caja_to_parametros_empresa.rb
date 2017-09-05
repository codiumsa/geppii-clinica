class AddCierreAutomaticoCajaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :cierre_automatico_caja, :boolean, default: true
  end
end
