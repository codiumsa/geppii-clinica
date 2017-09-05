class AddCodigoToEmpresas < ActiveRecord::Migration
  def change
    add_column :empresas, :codigo, :string
  end
end
