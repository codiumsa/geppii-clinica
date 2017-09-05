class AddControlToInventarios < ActiveRecord::Migration
  def change
    add_column :inventarios, :control, :boolean, default: false
  end
end
