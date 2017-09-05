class AjusteInventarioSerializer < ActiveModel::Serializer
  has_one :deposito, embed: :id, include: false
  has_one :usuario, embed: :id, include: false
  has_many :detalles, embed: :id, include: false
  attributes :id, :fecha, :observacion
end
