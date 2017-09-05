class CursoSerializer < ActiveModel::Serializer
  attributes :id, :observaciones, :descripcion, :fecha_inicio, :fecha_fin, :lugar
  has_many :curso_colaboradores, embed: :id, include: false

end
