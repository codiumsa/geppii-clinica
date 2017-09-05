class SucursalVendedorSerializer < ActiveModel::Serializer
  attributes :id
  has_one :sucursal, embed: :id, include: false
  has_one :vendedor, embed: :id, include: false
end
