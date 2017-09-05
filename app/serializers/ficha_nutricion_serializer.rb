class FichaNutricionSerializer < ActiveModel::Serializer
  attributes :id, :nro_ficha, :datos, :consulta_id,:estado
  has_one :paciente, embed: :id, include: false
end
