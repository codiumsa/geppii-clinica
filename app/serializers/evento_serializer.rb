class EventoSerializer < ActiveModel::Serializer
  attributes :id, :tipo, :observacion, :fecha
  has_one :usuario, embed: :id, include: false
end
