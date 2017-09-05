class SucursalSerializer < ActiveModel::Serializer
  attributes :id, :codigo, :descripcion, :color, :vendedor_id
  has_one :deposito, embed: :id, include: false
  has_one :empresa, embed: :id, include: false
end