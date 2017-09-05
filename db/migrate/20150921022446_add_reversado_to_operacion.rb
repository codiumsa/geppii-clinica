class AddReversadoToOperacion < ActiveRecord::Migration
  def change
    add_column :operaciones, :reversado, :boolean, :default => false
  end
end
