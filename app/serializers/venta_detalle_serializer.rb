class VentaDetalleSerializer < ActiveModel::Serializer
  attributes :id, :cantidad, :precio, :descuento, :imei, :monto_cotizacion, :multiplicar_cotizacion, :caliente
  has_one :venta, embed: :id, include: false
  has_one :producto, embed: :id, include: false
  has_one :promocion, embed: :id, include: false
  has_one :cotizacion, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
end
