class PagoDetalleSerializer < ActiveModel::Serializer
  attributes :id, :monto_cuota, :monto_interes, :monto_interes_moratorio, :monto_interes_punitorio, :numero_cuota_asociado
  has_one :pago, embed: :id, include: false
  has_one :venta_cuota, embed: :id, include: false
	has_one :compra_cuota, embed: :id, include: false
end
