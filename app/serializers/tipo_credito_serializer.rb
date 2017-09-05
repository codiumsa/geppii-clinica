class TipoCreditoSerializer < ActiveModel::Serializer
  attributes :id, :descripcion, :plazo, :unidad_tiempo
end
