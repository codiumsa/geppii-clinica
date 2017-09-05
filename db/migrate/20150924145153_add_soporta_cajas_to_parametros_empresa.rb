class AddSoportaCajasToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_cajas, :boolean, default: false
  end
end
