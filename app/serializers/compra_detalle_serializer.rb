class CompraDetalleSerializer < ActiveModel::Serializer
  attributes :id, :cantidad, :precio_compra
  has_one :compra, embed: :id, include: false
  has_one :contenedor, embed: :id, include: false
  has_one :producto, embed: :id, include: false
  has_one :lote, embed: :id, include: false
  has_one :contenedor, embed: :id, include: false

end
