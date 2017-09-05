class TratamientoSerializer < ActiveModel::Serializer
  attributes :id, :nombre
  has_one :especialidad, embed: :id, include: true
end
