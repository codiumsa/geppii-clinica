class TransferenciaDepositoDetalleSerializer < ActiveModel::Serializer
  attributes :id, :cantidad
  has_one :lote, embed: :id, include: false
  has_one :transferencia, embed: :id, include: false
end