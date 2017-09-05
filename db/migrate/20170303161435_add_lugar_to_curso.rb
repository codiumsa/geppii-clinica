class AddLugarToCurso < ActiveRecord::Migration
  def change
    add_column :cursos, :lugar, :string
  end
end
