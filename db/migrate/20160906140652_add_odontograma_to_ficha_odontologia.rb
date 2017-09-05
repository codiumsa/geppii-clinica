class AddOdontogramaToFichaOdontologia < ActiveRecord::Migration
  def change
    add_column :fichas_odontologia, :odontograma, :jsonb
  end
end
