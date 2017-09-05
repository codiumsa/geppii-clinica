class AddnroFichaToFichasCirugia < ActiveRecord::Migration
  def change
    add_column :fichas_cirugia, :nro_ficha, :integer
  end
end
