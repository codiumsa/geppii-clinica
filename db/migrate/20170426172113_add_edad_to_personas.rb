class AddEdadToPersonas < ActiveRecord::Migration
  def change
    add_column :personas, :edad, :integer
  end
end
