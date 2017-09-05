class AddColumnToConsulta < ActiveRecord::Migration
  def change
    add_column :consultas, :edad, :float, :default => 0
    add_reference :consultas, :paciente, index: true
    add_column :consultas, :evaluacion, :string
    add_column :consultas, :diagnostico, :string
    add_column :consultas, :receta,:string
    add_column :consultas, :indicaciones,:string
  end
end
