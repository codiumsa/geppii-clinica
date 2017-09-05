class AddColumnsToDocumentos < ActiveRecord::Migration
  def change
    add_column :documentos, :adjunto_file_name, :string
    add_column :documentos, :adjunto_content_type, :string
    add_column :documentos, :adjunto_file_size, :integer
    add_column :documentos, :adjunto_updated_at, :datetime
    add_column :documentos, :adjunto_uuid, :string
  end
end
