class InventarioLoteSerializer < ActiveModel::Serializer
  attributes :id, :existencia, :existencia_previa
  has_one :lote, embed: :id, include: false
  has_one :inventario, embed: :id, include: false
  has_one :producto, embed: :id, include: false
end
