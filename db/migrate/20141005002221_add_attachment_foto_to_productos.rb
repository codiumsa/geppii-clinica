class AddAttachmentFotoToProductos < ActiveRecord::Migration
  def self.up
    change_table :productos do |t|
      t.attachment :foto
    end
  end

  def self.down
    remove_attachment :productos, :foto
  end
end
