class ChangeDescripcionInDepositos < ActiveRecord::Migration
  def up
    change_column :depositos, :descripcion, :text
  end
  def down
    change_column :depositos, :descripcion, :string
  end
end
