class RemoveAnuladoFromCotizacion < ActiveRecord::Migration
  def change
    remove_column :cotizaciones, :anulado, :boolean
  end
end
