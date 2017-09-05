class ProduccionDetalleSerializer < ActiveModel::Serializer
  attributes :id, :cantidad
  has_one :producto, embed: :id, include: false
  has_one :lote, embed: :id, include: false
  has_one :deposito, embed: :id, include: false
  has_one :produccion, embed: :id, include: false

end
