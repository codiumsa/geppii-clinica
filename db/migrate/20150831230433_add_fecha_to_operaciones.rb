class AddFechaToOperaciones < ActiveRecord::Migration
  def change
  	add_column :operaciones, :fecha, :datetime
  end
end
