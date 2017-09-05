# encoding: utf-8
class PersonaSerializer < ActiveModel::Serializer
  attributes :id, :tipo_persona, :ci_ruc, :razon_social, :nombre, :apellido, :direccion, :barrio, :telefono,:edad,
  :celular, :estado_civil, :fecha_nacimiento, :correo, :sexo, :numero_hijos, :estudios_realizados, :tipo_domicilio,
  :antiguedad_domicilio, :nacionalidad
  has_one :ciudad, embed: :id, include: false
  has_one :cargo, embed: :id, include: false
  has_one :conyugue, embed: :id, include: true
end
