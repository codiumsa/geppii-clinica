class CandidaturaSerializer < ActiveModel::Serializer
  attributes :id, :fecha, :clinica, :fecha_posible
  has_one :paciente, embed: :id, include: false
  has_one :especialidad, embed: :id, include: false
  has_one :colaborador, embed: :id, include: false
  has_one :campanha, embed: :id, include: false
end
