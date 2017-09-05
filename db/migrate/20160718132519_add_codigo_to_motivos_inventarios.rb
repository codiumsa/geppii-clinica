class AddCodigoToMotivosInventarios < ActiveRecord::Migration
  def change
    add_column :motivos_inventarios, :codigo, :string
  end
end
