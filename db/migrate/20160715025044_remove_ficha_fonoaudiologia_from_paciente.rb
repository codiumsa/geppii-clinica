class RemoveFichaFonoaudiologiaFromPaciente < ActiveRecord::Migration
  def change
    remove_column :pacientes, :fonoaudiologia_id
  end
end
