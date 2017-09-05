class RemoveUniqueIndexCodigoBarra < ActiveRecord::Migration
  def change
    remove_index :productos, :codigo_barra
    add_index :productos, :codigo_barra
  end
end
