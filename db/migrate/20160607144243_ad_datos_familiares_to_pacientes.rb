class AdDatosFamiliaresToPacientes < ActiveRecord::Migration
  def change
    add_column :pacientes, :datos_familiares, :jsonb
  end
end
