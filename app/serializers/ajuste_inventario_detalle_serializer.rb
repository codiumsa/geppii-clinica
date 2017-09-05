class AjusteInventarioDetalleSerializer < ActiveModel::Serializer
  has_one :ajuste_inventario, embed: :id, include: false
  has_one :producto, embed: :id, include: false
  has_one :motivos_inventario, embed: :id, include: false
  has_one :lote, embed: :id, include: false
  attributes :id, :cantidad
end
