class AddnroFichaToFichasOdontologia < ActiveRecord::Migration
  def change
    add_column :fichas_odontologia, :nro_ficha, :integer
  end
end
