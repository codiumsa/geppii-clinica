class CursoColaboradorSerializer < ActiveModel::Serializer
  attributes :id, :observacion
  has_one :curso, embed: :id, include: false
  has_one :colaborador, embed: :id, include: false
end
