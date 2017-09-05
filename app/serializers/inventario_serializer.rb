class InventarioSerializer < ActiveModel::Serializer
  has_one :deposito, embed: :id, include: false
  has_one :usuario, embed: :id, include: false
  has_many :inventario_lotes, embed: :id, include: false
  attributes :id, :fecha_inicio, :fecha_fin, :descripcion, :control, :correcto, :procesado
end
