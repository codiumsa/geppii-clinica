class TipoOperacionSerializer < ActiveModel::Serializer
  attributes :id, :codigo, :descripcion, :manual, :referencia, :tipo_operacion_reversion,:tiene_caja_destino,  :caja_origen_default, :caja_destino_default, :muestra_saldo, :operacion_basica, :caja_default, :externo
  has_many :tipo_operacion_detalles, embed: :id, include: true
end
