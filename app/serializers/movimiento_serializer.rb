class MovimientoSerializer < ActiveModel::Serializer
  attributes :id, :monto, :monto_cotizado, :descripcion, :saldo, :referencia
  has_one :caja, embed: :id, include: false
  has_one :operacion, embed: :id, include: false
  has_one :tipo_operacion_detalle, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
end
