class ProcesoSerializer < ActiveModel::Serializer
  attributes :id, :cantidad, :descripcion, :estado
  has_one :producto,  embed: :id, include: false
  has_many :proceso_detalles, embed: :id, include: false
end
