class AddEstadoToFichasOdontologia < ActiveRecord::Migration
  def change
    add_column :fichas_odontologia, :estado, :string
  end
end
