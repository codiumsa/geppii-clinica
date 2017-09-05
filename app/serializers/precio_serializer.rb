class PrecioSerializer < ActiveModel::Serializer
  attributes :id, :fecha, :precio_compra
  has_one :compra_detalle
end
