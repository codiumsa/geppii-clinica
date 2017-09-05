class AddActivoToPaciente < ActiveRecord::Migration
  def change
    add_column :pacientes, :activo, :boolean, default: true
  end
end
