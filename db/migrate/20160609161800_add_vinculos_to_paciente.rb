class AddVinculosToPaciente < ActiveRecord::Migration
  def change
    add_column :pacientes, :vinculos, :jsonb
  end
end
