class AddObservacionToRegistroProduccion < ActiveRecord::Migration
  def change
    add_column :registros_produccion, :observacion, :string
  end
end
