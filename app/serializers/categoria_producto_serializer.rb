class CategoriaProductoSerializer < ActiveModel::Serializer
  attributes :id
  has_one :categoria,embed: :id, include: false
  has_one :producto, embed: :id, include: false
end
