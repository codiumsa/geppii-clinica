class CampanhaColaboradorSerializer < ActiveModel::Serializer
  attributes :id, :observaciones
  has_one :colaborador, embed: :id, include: false
  has_one :campanha, embed: :id, include: false
end
