class CategoriaClientePromocionSerializer < ActiveModel::Serializer
  attributes :id
  has_one :categoriaCliente,embed: :id, include: false
  has_one :promocion,embed: :id, include: false
end
