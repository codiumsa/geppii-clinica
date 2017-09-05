class ConsultorioSerializer < ActiveModel::Serializer
  attributes :id, :codigo, :descripcion
  has_one :especialidad, embed: :id, include: false
end
