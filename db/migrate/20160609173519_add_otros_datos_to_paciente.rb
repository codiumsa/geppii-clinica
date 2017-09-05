class AddOtrosDatosToPaciente < ActiveRecord::Migration
  def change
    add_column :pacientes, :otros_datos, :jsonb
  end
end
