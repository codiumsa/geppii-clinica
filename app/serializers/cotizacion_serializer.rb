class CotizacionSerializer < ActiveModel::Serializer
  attributes :id, :monto, :fecha_hora
  has_one :moneda, embed: :id, include: false
  has_one :moneda_base, embed: :id, include: false
  has_one :usuario, embed: :id, include: false
end
