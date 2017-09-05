class AddRecienNacidoToFichaOdontologia < ActiveRecord::Migration
  def change
    add_column :fichas_odontologia, :recien_nacido, :jsonb
  end
end
