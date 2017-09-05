class FichaFonoaudiologiaSerializer < ActiveModel::Serializer
  attributes :id, :prioridad, :comunicacion_lenguaje, :estimulos, :alimentacion, :fistula,:nro_ficha,:estado
  has_one :paciente, embed: :id, include: false

end
