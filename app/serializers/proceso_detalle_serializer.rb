class ProcesoDetalleSerializer < ActiveModel::Serializer
  attributes :id, :cantidad, :precio_costo, :precio_venta
  has_one :proceso, embed: :id, include: false
  has_one :producto, embed: :id, include: false
end
