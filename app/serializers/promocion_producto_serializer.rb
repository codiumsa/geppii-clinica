class PromocionProductoSerializer < ActiveModel::Serializer
  attributes :id, :cantidad, :precio_descuento, :porcentaje, :caliente

  has_one :promocion, embed: :id, include: false
  has_one :producto, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
end