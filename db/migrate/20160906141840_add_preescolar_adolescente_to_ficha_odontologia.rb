class AddPreescolarAdolescenteToFichaOdontologia < ActiveRecord::Migration
  def change
    add_column :fichas_odontologia, :preescolar_adolescente, :jsonb
  end
end
