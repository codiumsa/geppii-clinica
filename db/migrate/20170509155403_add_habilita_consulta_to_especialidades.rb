class AddHabilitaConsultaToEspecialidades < ActiveRecord::Migration
  def change
    add_column :especialidades, :habilita_consulta, :boolean, default: false
  end
end
