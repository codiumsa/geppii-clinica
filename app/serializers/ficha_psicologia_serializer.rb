class FichaPsicologiaSerializer < ActiveModel::Serializer
  attributes :id,:estado,:nro_ficha,:comentarios, :confidencial, :updated_at
  has_one :paciente, embed: :id, include: false
end
