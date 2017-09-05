class AddExternoToFichasCirugia < ActiveRecord::Migration
  def change
    add_column :fichas_cirugia, :externo, :boolean
  end
end
