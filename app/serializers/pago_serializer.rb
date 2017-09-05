class PagoSerializer < ActiveModel::Serializer
  attributes :id, :fecha_pago, :estado, :fecha_actualizacion_interes, :total, :monto_cotizacion, :borrado, :descuento, :total_moneda_seleccionada, :descuento_moneda_seleccionada, :banco_cheque, :numero_cheque, :nro_recibo
  has_one :venta, embed: :id, include: false
  has_one :compra, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
  has_one :usuario_solicitud_descuento, embed: :id, include: false
  has_one :usuario_aprobacion_descuento, embed: :id, include: false
  has_many :pago_detalles, embed: :id, include: false
end
