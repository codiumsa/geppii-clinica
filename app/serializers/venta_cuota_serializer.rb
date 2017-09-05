class VentaCuotaSerializer < ActiveModel::Serializer
  attributes :id, :nro_cuota, :monto, :fecha_vencimiento, :fecha_cobro, :cancelado, :nro_recibo, :pendiente, :estado
  has_one :venta, embed: :id, include: false
end
