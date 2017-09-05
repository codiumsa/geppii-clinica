class ViajeSerializer < ActiveModel::Serializer
  attributes :id, :descripcion, :fecha_inicio, :fecha_fin,:origen,:destino
  has_many :viaje_colaboradores, embed: :id, include: false

end
