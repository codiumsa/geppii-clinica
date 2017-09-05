class ProductoDetalleSerializer < ActiveModel::Serializer
    attributes :id, :cantidad
    has_one :producto, embed: :id, include: false
    has_one :producto_padre, embed: :id, include: false
end
