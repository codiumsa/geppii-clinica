class AddObservacionToPacientes < ActiveRecord::Migration
  def change
    add_column :pacientes, :observacion, :string, :limit => 524
  end
end
