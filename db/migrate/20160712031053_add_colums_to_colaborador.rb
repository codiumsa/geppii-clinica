class AddColumsToColaborador < ActiveRecord::Migration
  def change
    add_column :colaboradores, :licencia, :string
    add_column :colaboradores, :activo, :boolean
  end
end
