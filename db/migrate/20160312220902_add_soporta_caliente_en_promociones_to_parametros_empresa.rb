class AddSoportaCalienteEnPromocionesToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_parametro_caliente, :boolean, default: false
  end
end
