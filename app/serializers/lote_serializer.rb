class LoteSerializer < ActiveModel::Serializer
  attributes :id, :codigo_lote, :fecha_vencimiento
  has_one :producto, embed: :id, include: false
end
