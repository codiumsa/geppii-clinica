class ChangeDescripcionInPromocioncion < ActiveRecord::Migration
	def up
    change_column :promociones, :descripcion, :text
	end
	def down
    change_column :promociones, :descripcion, :string
	end
end
