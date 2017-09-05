class TransferenciaDepositoSerializer < ActiveModel::Serializer
  attributes :id, :descripcion, :fecha_registro, :nro_transferencia
  has_one :origen, embed: :id, include: false
  has_one :usuario, embed: :id, include: false
  has_one :destino, embed: :id, include: false
  has_many :detalles, embed: :id, include: false

end