class AddExamenClinicoToFichaOdontologia < ActiveRecord::Migration
  def change
    add_column :fichas_odontologia, :examen_clinico, :jsonb
  end
end
