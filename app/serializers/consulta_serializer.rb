class ConsultaSerializer < ActiveModel::Serializer
  attributes :id, :fecha_agenda, :fecha_inicio, :fecha_fin, :estado, :cobrar,
    :evaluacion, :diagnostico, :receta, :indicaciones, :nro_ficha
  has_one :colaborador, embed: :id,  include: false
  has_one :especialidad, embed: :id,  include: false
  has_one :paciente, embed: :id,  include: false
  has_many :consulta_detalles, embed: :id, include: false

end
