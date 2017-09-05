class CalificacionSerializer < ActiveModel::Serializer
  attributes :id, :codigo, :descripcion, :dias_atraso
end
