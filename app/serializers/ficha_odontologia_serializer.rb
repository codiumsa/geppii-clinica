class FichaOdontologiaSerializer < ActiveModel::Serializer
  attributes :id, :recien_nacido, :examen_clinico, :odontograma, :preescolar_adolescente,:nro_ficha
  has_one :paciente, embed: :id, include: false
  has_many :consulta_detalles, embed: :id, include: false
end
