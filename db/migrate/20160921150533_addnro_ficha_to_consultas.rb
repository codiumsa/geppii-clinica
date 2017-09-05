class AddnroFichaToConsultas < ActiveRecord::Migration
  def change
    add_column :consultas, :nro_ficha, :integer
  end
end
