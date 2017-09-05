class RegistroProduccionSerializer < ActiveModel::Serializer
  attributes :id, :cantidad, :estado, :observacion, :fecha
  has_one :proceso,  embed: :id, include: false
  has_one :deposito,  embed: :id, include: false
end
