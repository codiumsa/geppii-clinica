class AddCampanhaToFichasCirugia < ActiveRecord::Migration
  def change
    add_reference :fichas_cirugia, :campanha, index: true
  end
end
