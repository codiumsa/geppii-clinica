class CompraCuotaSerializer < ActiveModel::Serializer
  attributes :id, :nro_cuota, :monto, :fecha_vencimiento, :fecha_cobro, :cancelado, :nro_recibo, :pendiente
  has_one :compra, embed: :id, include: false
end
