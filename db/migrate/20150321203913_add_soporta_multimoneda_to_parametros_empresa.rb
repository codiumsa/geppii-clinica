class AddSoportaMultimonedaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_multimoneda, :boolean
  end
end
