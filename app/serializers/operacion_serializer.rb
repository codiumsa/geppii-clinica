class OperacionSerializer < ActiveModel::Serializer

  attributes :id, :monto, :codigo_tipo_operacion, :referencia_id, :reversado
  has_one :caja, embed: :id, include: false
  has_one :caja_destino, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
  has_one :tipo_operacion, embed: :id, include: false
  has_one :categoria_operacion, embed: :id, include: false
  has_many :movimientos, embed: :id, include: true
   
end
