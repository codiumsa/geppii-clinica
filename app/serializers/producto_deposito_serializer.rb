class ProductoDepositoSerializer < ActiveModel::Serializer
  attributes :id, :existencia
  has_one :producto, embed: :id, include: false
  has_one :deposito, embed: :id, include: false
end
