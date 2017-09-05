class AddDatosImportantesToPacientes < ActiveRecord::Migration
  def change
    add_column :pacientes, :datos_importantes, :jsonb
  end
end
