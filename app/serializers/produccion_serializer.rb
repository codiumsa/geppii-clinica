class ProduccionSerializer < ActiveModel::Serializer
  attributes :id, :cantidad_produccion
  has_many :produccion_detalles, embed: :id, include: false
  has_one :producto, embed: :id, include: false
  has_one :deposito, embed: :id, include: false
end
