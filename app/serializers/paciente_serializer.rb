class PacienteSerializer < ActiveModel::Serializer
  attributes :id, :numero_paciente, :info_paciente,
    :datos_familiares, :contacto_emergencia,
    :vinculos, :otros_datos, :anhos, :datos_importantes, :observacion
  has_one :persona,embed: :id, include: true
  has_many :candidaturas, embed: :id, include: false
end
