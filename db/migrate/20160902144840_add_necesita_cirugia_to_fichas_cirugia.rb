class AddNecesitaCirugiaToFichasCirugia < ActiveRecord::Migration
  def change
    add_column :fichas_cirugia, :necesita_cirugia, :boolean, default: false
  end
end
