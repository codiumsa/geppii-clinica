class ContactoDetalleSerializer < ActiveModel::Serializer
  attributes :id, :fecha, :fecha_siguiente, :observacion,:comentario,:compromiso,:estado
  has_one :contacto, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
end
