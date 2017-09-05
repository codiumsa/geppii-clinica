class ChangeDescripcionInCategoriaClientes < ActiveRecord::Migration
  def up
    change_column :categoria_clientes, :descripcion, :text
  end
  def down
    change_column :categoria_clientes, :descripcion, :string
  end
end
