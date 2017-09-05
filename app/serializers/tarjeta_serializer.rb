class TarjetaSerializer < ActiveModel::Serializer
  attributes :id, :banco, :marca, :afinidad, :activo
  has_one :medio_pago, embed: :id, include: false
end
