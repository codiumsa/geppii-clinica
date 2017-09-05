class AddAnhoMisionToFichasCirugia < ActiveRecord::Migration
  def change
    add_column :fichas_cirugia, :anho_mision, :integer
  end
end
