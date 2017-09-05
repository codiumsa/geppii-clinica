# encoding: utf-8
# == Schema Information
#
# Table name: documentos
#
#  id                   :integer          not null, primary key
#  tipo_documento_id    :integer
#  nombre               :string(255)
#  estado               :string(255)
#  nombre_archivo       :string(255)
#  archivo              :binary
#  created_at           :datetime
#  updated_at           :datetime
#  cliente_id           :integer
#  adjunto_file_name    :string(255)
#  adjunto_content_type :string(255)
#  adjunto_file_size    :integer
#  adjunto_updated_at   :datetime
#

class Documento < ActiveRecord::Base
  belongs_to :tipo_documento
  belongs_to :cliente

  attr_accessor :url_adjunto

  scope :by_cliente, -> cliente_id { where("cliente_id = ?", "#{cliente_id}") }

  has_attached_file :adjunto,
    :url => "/adjuntos/:cliente_id/:adjunto_uuid-:adjunto_file_name.:extension",
    :path => ':rails_root/public:url',
    :use_timestamp => true,
    :default_url => '/adjuntos/missing_small.png'

  Paperclip.interpolates :cliente_id do |attachment, style|
    "#{attachment.instance.cliente_id}"
  end

  Paperclip.interpolates :adjunto_file_name do |attachment, style|
    "#{attachment.instance.adjunto_file_name}"
  end

  Paperclip.interpolates :adjunto_uuid do |attachment, style|
    "#{attachment.instance.adjunto_uuid}"
  end

  validates_attachment_file_name :adjunto, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/, /pdf\Z/, /doc\Z/, /docx\Z/]
  validates_attachment_content_type :adjunto, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "application/msword"]

  def adjunto_url
    @url_adjunto = adjunto.url()
  end
end
