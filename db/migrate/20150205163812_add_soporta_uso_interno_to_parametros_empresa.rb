class AddSoportaUsoInternoToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_uso_interno, :boolean
  end
end
