class TipoOperacionDetalleSerializer < ActiveModel::Serializer
  attributes :id, :descripcion, :caja_destino, :genera_diferencia, :impacta_saldo
  has_one :tipo_movimiento, embed: :id, include: false
end
