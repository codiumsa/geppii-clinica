class FichaCirugiaSerializer < ActiveModel::Serializer
  attributes :id,:necesita_cirugia,:diagnostico_inicial,:comentarios_adicionales,:fecha_consulta_inicial,:tratamientos_realizados,:diagnosticos_realizados,:estado,:nro_ficha,:externo,:anho_mision
  has_one :colaborador, embed: :id, include: false
  has_one :paciente, embed: :id, include: false
  has_one :campanha, embed: :id, include: false

end
