class AddUsuarioToInventario < ActiveRecord::Migration
  def change
    add_reference :inventarios, :usuario, index: true
  end
end
