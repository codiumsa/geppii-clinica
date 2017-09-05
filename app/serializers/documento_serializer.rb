# encoding: utf-8
class DocumentoSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :estado, :nombre_archivo, :url_adjunto, :adjunto_file_name, :adjunto_content_type, :adjunto_file_size, :adjunto_uuid
  has_one :tipo_documento, embed: :id, embed_in_root: true
end
