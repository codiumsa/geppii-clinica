class ChangeObservacionTypeInRegistrosProduccion < ActiveRecord::Migration
	def up
    change_column :registros_produccion, :observacion, :text
	end
	def down
    change_column :registros_produccion, :observacion, :string
	end
end
