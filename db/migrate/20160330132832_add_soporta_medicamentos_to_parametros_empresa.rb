class AddSoportaMedicamentosToParametrosEmpresa < ActiveRecord::Migration
  def change
      add_column :parametros_empresas, :soporta_medicamentos, :boolean, default: false
  end
end
